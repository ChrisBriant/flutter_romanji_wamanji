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

  _addNewVerb() async {
    AppDatabase db = AppDatabase();
    //Make the call to the backend
    Map<String,dynamic>? newVerb = await NetworkServices.addNewVerbApi(verbTextEdit.text);
    logInfo("RESULT FROM API CALL $newVerb");
    //Try adding to the database
    if(newVerb != null) {
      try {
        await db.insertVerb(newVerb);
        logInfo("TRYING TO ADD TO PROVIDER");
        if(mounted) {
          DataProvider dp = Provider.of(context, listen: false);
          Paginator? newPaginator = dp.allVerbsPaginator;
          
          if(newPaginator != null) {
            if(newPaginator.pages.isNotEmpty) {
              List<Verb> newVerbs = newPaginator.pages[0][0];
              bool exists = newVerbs.any((verb) => verb.id == newVerb['id']);
              logInfo("Does the verb exist $exists");
            }
            
          }
          
        }
      } catch(err) {
        logError("Error adding to database $err");
      }
    } else { return; }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("assets/add_verb.jpg"),
            TextField(
              controller: verbTextEdit,
            ),
            ElevatedButton(
              onPressed: () => _addNewVerb(),
              child: const Text("Add"),
            )
          ],
        ),

      ),
    );
  }
}