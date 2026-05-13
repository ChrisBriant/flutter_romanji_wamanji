import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:provider/provider.dart';
import 'package:romanji_wamanji/data/database.dart';
import 'package:romanji_wamanji/services/network.dart';
import '../providers/data_provider.dart';
import '../widgets/listpair_widget.dart';
import '../widgets/list_pair_with_action.dart';
import '../services/http_overrides.dart';
import '../providers/data_provider.dart';
import 'package:provider/provider.dart';
import '../data/verb.dart';

class VerbDisplayScreen extends StatelessWidget {
  static const String routeName = "/verbdisplayscreen";

  const VerbDisplayScreen({super.key});

  formClickAction(BuildContext context, verbId,localVerbId,form) async {
    logInfo("FORM AND ID $verbId, $localVerbId, $form");
    Map<String, dynamic>? verbExample = await NetworkServices.getVerbExampleApi(
      verbId, 
      form.toString().toLowerCase()
    );

    AppDatabase db = AppDatabase();

    Map<String,dynamic>? newVerbExample;

    if(verbExample == null) {
      //Try to retrieve from the database
      newVerbExample = await db.getVerbExampleByIdAndForm(localVerbId, form);
      if(newVerbExample == null) {
        if(context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar( content: Text("Unable to get an example, please try again later when online.")));
        }
        return;
      }

    } else {
      //logInfo("This is the result of the call $verbExample");
      //Insert into the database
      
      newVerbExample = await db.insertVerbExample({
        "verbExampleId" : localVerbId,
        ...verbExample!
      });
    }

    
    //Get the provider
    if(context.mounted) {
      DataProvider dp = Provider.of(context,listen: false);

      logInfo("This is the new verb example $newVerbExample");
      //Get all the verb examples to create a new paginator
      List<Map<String,dynamic>> allVerbExamples = await db.getAllVerbExamplesRaw();
      logInfo("This is all of the verb examples $allVerbExamples");
      List<Verb> rawVerbs = dp.allVerbsPaginator!.allItems;
      logInfo("RAW VERBS LIST $rawVerbs");
      List<Map<String,dynamic>> allVerbExamplesWithVerbObject = allVerbExamples.map<Map<String,dynamic>>((ve) {
        Verb v = rawVerbs.firstWhere((verb) => verb.localId == ve["verb_id"]);
        return {
          "verb" : v,
          ...ve
        }; 
      }).toList();
      logInfo("RAW VERB EXAMPLES $allVerbExamplesWithVerbObject");
      final verbExamplePaginator = Paginator<VerbExample>.fromRawData(
        data: allVerbExamplesWithVerbObject,
        pageSize: 10,
        fromJson: (map) => VerbExample.fromJson(map),
      );
      dp.setAllVerbExamplesPaginator(verbExamplePaginator);
      Map<String,dynamic> newVerbExampleCopy = {...newVerbExample};
      newVerbExampleCopy["verb"] = dp.selectedVerb;
      logInfo("VERB EXAMPLE RETRIEVED $newVerbExample");
      dp.setSelectedVerbExample(VerbExample.fromJson(newVerbExampleCopy));
      //Need to navigate to screen also regression test with the API connected
      if(context.mounted) {
        Navigator.of(context).pushNamed("/verbexamplescreen");
      }
    }

  }


  @override
  Widget build(BuildContext context) {


    return Consumer<DataProvider>(
      builder: (context, dp, _) =>  Scaffold(
          
          // appBar: AppBar(
          //   title: Text(dp.selectedVerb!.english, style: TextStyle(color: Colors.white),),
          //   automaticallyImplyLeading: false,
          //   backgroundColor: Colors.black,
          // ),
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Text(
                    dp.selectedVerb!.english,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
            
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_circle_outlined, size: 30,),
                      const SizedBox(width: 10,),
                      Flexible(
                        child: const Text(
                          "Press on the lightbulb next to the verb form to get an example.",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      AppDatabase db = AppDatabase();
                      logInfo("Fetching Examples for ${dp.selectedVerb!.localId.toString()}");
                      //Get examples for the selected verb
                      List<Map<String,dynamic>> verbExamplesRaw = await db.getVerbExamplesByIdRaw(dp.selectedVerb!.localId);
                      logInfo("RAW VERB EXAMPLES $verbExamplesRaw");
                      //Prepare the data so that it has verbs as object
                      List<Map<String,dynamic>> verbExamplesWithVerbObject = verbExamplesRaw.map<Map<String,dynamic>>((ve) {
                        Verb v = dp.selectedVerb!;
                        return {
                          "verb" : v,
                          ...ve
                        }; 
                      }).toList();
                      dp.setExamplesForVerb(verbExamplesWithVerbObject);
                      if(context.mounted) {
                        logInfo("WHY IS THIS NOT GOING TO THE RIGHT SCREEN");
                        Navigator.of(context).pushNamed("/verbexamplesscreen");
                      }
                    }, 
                    child: const Text("Show Examples")
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .7,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white
                      ),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: SingleChildScrollView(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Column(
                        children: [
                          ListPair(
                            textA: "English",
                            textB: dp.selectedVerb!.english,
                          ),
                         ListPair(
                            textA: "Japanese",
                            textB: dp.selectedVerb!.japanese,
                          ),
                          ListPairWithAction(
                            textA: "Present",
                            textB: dp.selectedVerb!.present,
                            formClickAction: () => formClickAction(context,dp.selectedVerb!.id,dp.selectedVerb!.localId,"present"),
                          ),
                         ListPair(
                            textA: "Past",
                            textB: dp.selectedVerb!.past,
                          ),
                         ListPair(
                            textA: "Negative",
                            textB: dp.selectedVerb!.negative,
                          ),
                          ListPair(
                            textA: "Polite Present",
                            textB: dp.selectedVerb!.politePresent,
                          ),
                         ListPair(
                            textA: "Polite Negative",
                            textB: dp.selectedVerb!.politeNegative,
                          ),
                          ListPair(
                            textA: "Polite Past",
                            textB: dp.selectedVerb!.politePast,
                          ),
                         ListPair(
                            textA: "Polite Past Negative",
                            textB: dp.selectedVerb!.politePastNegative,
                          ),
                         ListPair(
                            textA: "Te Form",
                            textB: dp.selectedVerb!.teForm,
                          ),
                         ListPair(
                            textA: "Volitional",
                            textB: dp.selectedVerb!.volitional,
                          ),
                        ]
                      
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).popAndPushNamed("/homescreen"),                     child: const Text("Close")
                  )
                ],
              ),
            ),
          ),
        )
      );
  }
}