import 'package:flutter/material.dart';

class ListPair extends StatelessWidget {
  final String textA;
  final String textB;
  final MainAxisAlignment? alignment;

  const ListPair({
    required this.textA,
    required this.textB,
    this.alignment,
    super.key
  
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: alignment != null ? alignment! : MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10,),
          Container(
            decoration: BoxDecoration(
              color: Colors.white24
            ),
            padding: EdgeInsets.all(4),
            alignment: Alignment.centerLeft,
            //height: 40,
            width: MediaQuery.of(context).size.width * .35,
            child: Text(
              textA,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
          ),
          const SizedBox(width: 10,),
          const Text(":", style: TextStyle(fontSize: 18, color: Colors.white),),
          const SizedBox(width: 10,),
          Container(
            decoration: BoxDecoration(
              color: Colors.white24
            ),
            padding: EdgeInsets.all(4),
            alignment: Alignment.centerLeft,
            //height: 40,
            width: MediaQuery.of(context).size.width * .35,
            child: Text(
              textB,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
          ),
        ]
      
      ),
    );
  }
}