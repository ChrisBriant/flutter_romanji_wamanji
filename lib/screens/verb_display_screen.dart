import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../widgets/listpair_widget.dart';

class VerbDisplayScreen extends StatelessWidget {
  static const String routeName = "/verbdisplayscreen";

  const VerbDisplayScreen({super.key});

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
          body: Center(
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
                        ListPair(
                          textA: "Presenet",
                          textB: dp.selectedVerb!.present,
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
                  onPressed: () => Navigator.of(context).pop(), 
                  child: const Text("Close")
                )
              ],
            ),
          ),
        )
      );
  }
}