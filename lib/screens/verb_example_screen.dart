import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:romanji_wamanji/widgets/listpair_widget.dart';
import 'package:romanji_wamanji/widgets/verb_example_widget.dart';
import '../providers/data_provider.dart';

class VerbExampleScreen extends StatelessWidget {
  static const String routeName ="/verbexamplescreen";

  const VerbExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Consumer<DataProvider>(
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
              Container(
                height: MediaQuery.of(context).size.height * .4,
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
                      Center(
                        child: VerbExampleWidget(
                          form: dp.selectedVerbExample!.form, 
                          english: dp.selectedVerbExample!.english, 
                          romaji: dp.selectedVerbExample!.romaji
                        ),
                        // child: ListPair(
                        //   alignment: MainAxisAlignment.center,
                        //   textA: dp.selectedVerbExample!.form, 
                        //   textB: dp.selectedVerbExample!.romaji
                        // ),
                      )
                    ]
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Close"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}