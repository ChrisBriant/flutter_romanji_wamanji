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
    // AppDatabase db = AppDatabase();
    // //Make the call to the backend
    //   final url = Uri.parse('$baseUrl/translate/getverbssince'); 
    //   try {
    //     http.get(url,
    //     ).then((res) async {
    //       logInfo("RESPONSE ${res.statusCode}");
    //       if (res.statusCode == 200) {
    //         //1. GET DATA FROM BACKEND INTO MAP
    //         final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(jsonDecode(res.body));
    //         //logInfo("This is the response ${data[0]}");
    //         //2. ADD TO THE DATABASE
            
    //         try {
    //           await db.createTables();
    //           logInfo("Poo poo");
    //           await db.insertVerbsBatch(data);
              
    //         } catch(err) {
    //           logError("Error adding items to the database ${err}");
    //           logInfo("Error adding items to the database ${err}");
    //         }
    //         //RETRIEVE ALL THE ITEMS FROM THE DATABASE
    //         List<Map<String,dynamic>> allVerbs = await db.getAllVerbsRaw();
    //         logInfo("This is from the database $allVerbs");
    //       } else {
    //         logError('Request failed with status: ${res.statusCode}');
    //         //setState(() => registrationError = true);
    //       }
    //     } );

    // } catch(err) {
    //   logInfo("FAILED");
    //   logError("Error $err");
    //   setState(() {
    //     //registrationError = true;
    //   });
    // }
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

    // 3. Access your data
    logInfo("Total Pages: ${verbPaginator.totalPages}");

    if (verbPaginator.pages.isNotEmpty) {
      List<Verb> firstPage = verbPaginator.getPage(0);
      logInfo("First verb on page 1: ${firstPage[0].english}");
    }

  


    // //Set int he provider
    // if(context.mounted) {
    //   DataProvider dp = Provider.of(context, listen: false);
    //   dp.setAllVerbsPaginator(verbPaginator);
    // }
    // Future.microtask(() async {
    //   Provider.of<DataProvider>(context, listen: false).setAllVerbsPaginator(verbPaginator);
    // });
    dataProvider.setAllVerbsPaginator(verbPaginator);
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