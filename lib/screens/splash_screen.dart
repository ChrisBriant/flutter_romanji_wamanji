import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loggy/loggy.dart';
import '../data/database.dart';


String baseUrl = "https://10.0.2.2:8000";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    logInfo("INIT STATE - SPLASH SCREEN");
    AppDatabase db = AppDatabase();
    //Make the call to the backend
      final url = Uri.parse('$baseUrl/translate/getverbssince'); 
      try {
        http.get(url,
        ).then((res) async {
          logInfo("RESPONSE ${res.statusCode}");
          if (res.statusCode == 200) {
            //1. GET DATA FROM BACKEND INTO MAP
            final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(jsonDecode(res.body));
            //logInfo("This is the response ${data[0]}");
            //2. ADD TO THE DATABASE
            
            try {
              await db.createTables();
              logInfo("Poo poo");
              await db.insertVerbsBatch(data);
              
            } catch(err) {
              logError("Error adding items to the database ${err}");
              logInfo("Error adding items to the database ${err}");
            }
            //RETRIEVE ALL THE ITEMS FROM THE DATABASE
            List<Map<String,dynamic>> allVerbs = await db.getAllVerbsRaw();
            logInfo("This is from the database $allVerbs");
          } else {
            logError('Request failed with status: ${res.statusCode}');
            //setState(() => registrationError = true);
          }
        } );

    } catch(err) {
      logInfo("FAILED");
      logError("Error $err");
      setState(() {
        //registrationError = true;
      });
    }
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}