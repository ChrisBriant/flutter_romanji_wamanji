import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import "../data/verb.dart";

class HomeScreen extends StatelessWidget {
  static const String routeName = "/homescreen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        actions: [],
      ),
      backgroundColor: const Color.fromARGB(255, 5, 6, 4),
      body: Column(
        children: [
          //const SizedBox(height: 40,),
          Image.asset("assets/romaji_wamaji.png"),
          const Text("Verbs",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Consumer<DataProvider>(

            builder: (ctx,dp,_) => RomajiListBox(paginator: dp.allVerbsPaginator!,)
          )
        ]
        
      ),
    );
  }
}

class RomajiListBox extends StatelessWidget {
  final Paginator paginator;

  const RomajiListBox({
    required this.paginator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .4,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: paginator.pages[0].length,
        itemBuilder: (context,idx) => ListTile(
          title: Text(paginator.pages[0][idx].english),
        )
      ),
    );
  }
}