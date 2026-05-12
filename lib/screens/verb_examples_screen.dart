import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../data/verb.dart';
import '../widgets/listpair_widget.dart';

class VerbExamplesScreen extends StatelessWidget {
  static const String routeName = "/verbexamplesscreen";
  const VerbExamplesScreen({super.key});

  List<Widget> _getVerbExamplesAsChildWidgets(List<VerbExample> examples) {
    List<Widget> examplesAsWidgets = [];

    for (VerbExample verbExample in examples) {
      examplesAsWidgets.add(Center(
        child: ListPair(
          textA: verbExample.form,
          textB: verbExample.romaji,
          alignment: MainAxisAlignment.center,
        ),
      ));
    }

    return examplesAsWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context,dp,_) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/example_title.jpg"),
              Text(
                dp.selectedVerb!.english,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
        
                ),
              ),
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .5,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white
                      ),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: SingleChildScrollView(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _getVerbExamplesAsChildWidgets(dp.examplesForVerb!)
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(), 
                    child: const Text("Close")
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}