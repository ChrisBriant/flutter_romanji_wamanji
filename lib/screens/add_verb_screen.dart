import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:romanji_wamanji/data/database.dart';
import '../services/network.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../data/verb.dart';



class AddVerbScreen extends StatefulWidget {
  static const String routeName = "/addverbscreen";

  const AddVerbScreen({super.key});

  @override
  State<AddVerbScreen> createState() => _AddVerbScreenState();
}

class _AddVerbScreenState extends State<AddVerbScreen> {
  TextEditingController verbTextEdit = TextEditingController();
  bool _loading = false;

  _addNewVerb() async {
    setState(() {
      _loading = true;
    });
    AppDatabase db = AppDatabase();
    //Make the call to the backend
    Map<String,dynamic>? newVerb = await NetworkServices.addNewVerbApi(verbTextEdit.text).catchError((err) => null);
    logInfo("RESULT FROM API CALL $newVerb");
    // Map<String,dynamic>? newVerb  = { 
    //   "id": 1000, 
    //   "english": "to larapododah", 
    //   "japanese": "iku", 
    //   "present": "iku", 
    //   "past": "itta", 
    //   "negative": "ikanai", 
    //   "polite_present": "ikimasu", 
    //   "polite_negative": "ikimasen", 
    //   "polite_past": "ikimashita", 
    //   "polite_past_negative": "ikimasen deshita", 
    //   "te_form": "itte", 
    //   "volitional": "ikou", 
    //   "created_at": "2026-05-02T06:57:15.178669Z", 
    //   "updated_at": "2026-05-02T06:57:15.178669Z"
    // };
    //Try adding to the database
    if(newVerb != null) {
      try {
        Map<String,dynamic> inserted_record  = await db.insertVerb(newVerb);
        logInfo("TRYING TO ADD TO PROVIDER");
        if(mounted) {
          DataProvider dp = Provider.of(context, listen: false);
          Paginator? existingPaginator = dp.allVerbsPaginator;
          
          if(existingPaginator != null) {
            if(existingPaginator.pages.isNotEmpty) {
              List<Verb> newVerbs = existingPaginator.allItems.cast<Verb>();
              bool exists = newVerbs.any((verb) => verb.id == newVerb['id']);
              logInfo("Does the verb exist $exists");
              //Display message
              if(!exists) {
                //Convert to list of  map string dynamic
                // List<Map<String,dynamic>> rawVerbsList =existingPaginator.toRawList((v) => v.toJson());
                // rawVerbsList.add(newVerb);
                // logInfo("HERE ARE THE RAW VERBS $rawVerbsList");
                List<Map<String,dynamic>> rawVerbsList = await db.getAllVerbsRaw();
                // List<Map<String, dynamic>> growableList = [...rawVerbsList];
                // growableList.add(
                //   {
                //     "id" : "junkvalue", 
                //     ...newVerb
                //   }
                // );
                logInfo("NEW RAW LIST $rawVerbsList");
                final newPaginator = Paginator<Verb>.fromRawData(
                  data: rawVerbsList,
                  pageSize: 10,
                  fromJson: (map) => Verb.fromJson(map),
                );
                logInfo("HERE IS THE NEW PAGINATOR $newPaginator");
                dp.setAllVerbsPaginator(newPaginator);
                if(mounted) {
                  //Get the verb object and navigate to it
                  try {
                    //Get the new verb
                    Map<String,dynamic> newVerb = rawVerbsList.firstWhere(
                      (Map<String,dynamic> v) => v['id'] == inserted_record['id'],
                    );
                    dp.setSelectedVerb(
                      Verb.fromJson(newVerb)
                    );
                    logInfo("NEW VERB IS $newVerb");
                    Navigator.of(context).pushNamed("/verbdisplayscreen");
                  } catch (err) {
                    logError("Unable to get new verb");
                  }

                  //dp.setSelectedVerb(v)
                  //Navigator.of(context).popAndPushNamed("");
                }
                
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("The verb already exists.")));
                setState(() {
                  _loading = false;
                });
              }
            }
            
          }
          
        }
      } catch(err) {
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error - Please Try Again Later")));
        }
        setState(() {
          _loading = false;
        });
        logError("Error adding to database $err");
      }
    } else {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Network Problem - Please Try Again Later")));
      }
      setState(() {
        _loading = false;
      });
      return;   
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 5, 6, 4),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("assets/add_verb.jpg"),
            TextField(
              controller: verbTextEdit,
            ),
            Wrap(
              children: [
                ElevatedButton(
                  onPressed: _loading ? null : () => _addNewVerb(),
                  child: _loading ? const CircularProgressIndicator() : const Text("Add"),
                ),
                const SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: _loading ? null : () => Navigator.of(context).pop(),
                  child: const Text("Exit"),
                ),
              ],

            )
          ],
        ),

      ),
    );
  }
}