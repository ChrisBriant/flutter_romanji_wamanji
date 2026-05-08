import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import "../data/verb.dart";

class HomeScreen extends StatelessWidget {
  static const String routeName = "/homescreen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 5, 6, 4),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //const SizedBox(height: 40,),
            Image.asset("assets/romaji_wamaji.png"),
            const Text("Verbs",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            Consumer<DataProvider>(
        
              builder: (ctx,dp,_) => RomajiListBox(
                //itemCount : dp.allVerbsPaginator!.pages[_currentPage].length,
                paginator: dp.allVerbsPaginator!,
                itemContentBuilder: (context,item) => ListTile(
                  key: ValueKey(item.id),
                  title: Text(
                    item.english,
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  subtitle: Text(item.japanese),
                  onTap: () {
                    dp.setSelectedVerb(item);
                    Navigator.of(context).pushNamed("/verbdisplayscreen");
                  },   
                )              
              )
            ),
            const Text(
              "Verb not listed?",
              style: TextStyle(
                color: Colors.white
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed("/addverbscreen"), 
              child: Text("Add Verb")
            )
          ]
          
        ),
      ),
    );
  }
}

class RomajiListBox extends StatefulWidget {
  final Paginator paginator;
  final Widget Function(BuildContext, dynamic item) itemContentBuilder;


  const RomajiListBox({
    required this.paginator,
    required this.itemContentBuilder,
    super.key,
  });

  @override
  State<RomajiListBox> createState() => _RomajiListBoxState();
}

class _RomajiListBoxState extends State<RomajiListBox> {
  int _currentPage = 0;

  void onPageForward() {
    int maxPages = widget.paginator.pages.length;
    
    if (_currentPage < maxPages - 1) {
      setState(() {
        _currentPage++; 
      });
    }
  }

  void onPageBack() {  
    if (_currentPage > 0) {
      setState(() {
        _currentPage--; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentList = widget.paginator.pages[_currentPage];
    
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white
            ),
            borderRadius: BorderRadius.circular(10)
          ),
          margin: EdgeInsets.symmetric(vertical: 20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .4,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.paginator.pages[_currentPage].length,
            itemBuilder: (context, index) {
              // Pass the specific item to the parent's builder
              return widget.itemContentBuilder(context, currentList[index]);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _currentPage != 0 ? () => onPageBack() : null, // widget.onPageBack, 
              icon: Icon(
                Icons.arrow_circle_left_outlined,
                color: _currentPage != 0 ? Colors.white : Colors.white54,
                size: 30,
              )
            ),
            const Text(
              "Page",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 10,),
            Text(
              (_currentPage + 1).toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 10,),
            Text(
              "Of",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 10,),
            Text(
              widget.paginator.pages.length.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            IconButton(
              onPressed: _currentPage < (widget.paginator.pages.length -1) ? () => onPageForward() : null, 
              icon: Icon(
                Icons.arrow_circle_right_outlined,
                color:_currentPage < (widget.paginator.pages.length -1) ? Colors.white : Colors.white54,
                size: 30,
              )
            ),
          ],
        )
      ],
    );
  }
}