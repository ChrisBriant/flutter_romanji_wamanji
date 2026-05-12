import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loggy/loggy.dart';
import 'package:romanji_wamanji/widgets/loading_widget.dart';
import '../data/database.dart';
import '../data/verb.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';


String baseUrl = "https://10.0.2.2:8000";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //final Paginator<Verb>? _paginator = null;
  
  @override
  void initState() {
    logInfo("INIT STATE - SPLASH SCREEN");

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
    //_loadData();
  }

  Future<void> _loadData() async {
    logInfo("INIT STATE - SPLASH SCREEN");
    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    AppDatabase db = AppDatabase();

    //db.purgeAppData();

    //Get the most recent item
    String lastUpdated = await db.getLatestUpdatedAt() ?? "";

    logInfo("$baseUrl/translate/getverbssince?since=$lastUpdated");

    try {
      Uri url = Uri.parse('$baseUrl/translate/getverbssince?since=$lastUpdated');

      final res = await http.get(url);

      logInfo("RESPONSE ${res.statusCode}");

      if (res.statusCode == 200) {
        logError('Request failed with status: ${res.statusCode}');
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(jsonDecode(res.body));

        logInfo("Trying to insert data $data");
        await db.insertVerbsBatch(data);
        logInfo("Batch data inserted");
      }
    } catch (err, stack) {
      logError("ERROR: $err");
      logError("STACK: $stack");
    }


    final allVerbs = await db.getAllVerbsRaw();
    logInfo("DB contents: $allVerbs");
    //Load data into the provider
    final verbPaginator = Paginator<Verb>.fromRawData(
      data: allVerbs,
      pageSize: 10,
      fromJson: (map) => Verb.fromJson(map),
    );

    dataProvider.setAllVerbsPaginator(verbPaginator);
    await Future.delayed(Duration(seconds: 1));


    //Get the verb examples ldata
    //MIGHT NOT BE NEEDED AS WHY HAVE ALL THE VERB EXAMPLES?
    final allVerbExamples = await db.getAllVerbExamplesRaw();
    List<Verb> rawVerbs = verbPaginator.allItems;
    List<Map<String,dynamic>> allVerbExamplesWithVerbObject = allVerbExamples.map<Map<String,dynamic>>((ve) {
      Verb v = rawVerbs.firstWhere((verb) => verb.localId == ve["verb_id"]);
      return {
        "verb" : v,
        ...ve
      }; 
    }).toList();
    //Load data into the provider
    final verbExamplePaginator = Paginator<VerbExample>.fromRawData(
      data: allVerbExamplesWithVerbObject,
      pageSize: 10,
      fromJson: (map) => VerbExample.fromJson(map),
    );

    dataProvider.setAllVerbExamplesPaginator(verbExamplePaginator);
    await Future.delayed(Duration(seconds: 1));
    logInfo("Will redirect to homescreen");
    if(mounted) {
      Navigator.of(context).popAndPushNamed("/homescreen");
    }
  }

  // @override
  // void didChangeDependencies() {
  //   logInfo("CALLING DID CHANGE DEPENDENCIES");
  //   super.didChangeDependencies();
  //   _loadData();
  //   if(_paginator != null) {

      
  //     Provider.of<DataProvider>(context, listen: false).setAllVerbsPaginator(_paginator!);

  //     logInfo("PAGINATOR HAS BEEN SET");
  //   }
    
    

  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 40,),
          Image.asset('assets/splash_2.png'),
          LoadingWidget(message: "Loading...",),
        ]
      ),
    );
  }
}