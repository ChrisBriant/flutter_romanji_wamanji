import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
              Text(
                dp.selectedVerb!.english,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
        
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