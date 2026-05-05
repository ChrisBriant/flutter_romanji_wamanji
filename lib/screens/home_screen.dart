import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import "../data/verb.dart";

class HomeScreen extends StatefulWidget {
  static const String routeName = "/homescreen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPage = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Home", style: TextStyle(color: Colors.white),),
      //   backgroundColor: Colors.black,
      //   actions: [],
      // ),
      backgroundColor: const Color.fromARGB(255, 5, 6, 4),
      body: Column(
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
                title: Text(
                  item.english,
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                subtitle: Text(item.japanese),     
              )              
              ,
              // listItem: (context,idx) => ListTile(
              //   title: Text(
              //     dp.allVerbsPaginator!.pages[_currentPage][idx].english,
              //     style: TextStyle(
              //       color: Colors.white
              //     ),
              //   ),
              //   subtitle: Text(dp.allVerbsPaginator!.pages[_currentPage][idx].japanese),
              // ),
              // maxPages: dp.allVerbsPaginator!.pages.length,
              // currentPage: _currentPage,
              // onPageForward: () => onPageForward(dp),
              // onPageBack: () {
              //   if(_currentPage > 0) {
              //     //Advance the page
              //     setState(() {
              //       _currentPage--;
              //     });
              //   }
              // },
            )
          )
        ]
        
      ),
    );
  }
}

class RomajiListBox extends StatefulWidget {
  final Paginator paginator;
  //final int itemCount;
  final Widget Function(BuildContext, dynamic item) itemContentBuilder;
  //final NullableIndexedWidgetBuilder listItem;
  // final int maxPages;
  // final int currentPage;
  // final VoidCallback onPageForward;
  // final Function onPageBack;

  const RomajiListBox({
    required this.paginator,
    //required this.itemCount,
    required this.itemContentBuilder,
    //required this.listItem,
    // required this.maxPages,
    // required this.currentPage,
    // required this.onPageForward,
    // required this.onPageBack,
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
          // child: ListView.builder(
          //   shrinkWrap: true,
          //   itemCount: widget.itemCount,
          //   itemBuilder: widget.listItem
          // ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.paginator.pages[_currentPage].length,
            // itemBuilder: (context,idx) => ListTile(
            //     title: Text(
            //       widget.paginator.pages[_currentPage][idx].english,
            //       style: TextStyle(
            //         color: Colors.white
            //       ),
            //     ),
            //     subtitle: Text(widget.paginator.pages[_currentPage][idx].japanese),     
            // )
            itemBuilder: (context, index) {
              // Pass the specific item to the parent's builder
              return widget.itemContentBuilder(context, currentList[index]);
            },
          ),
        ),
        Row(
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