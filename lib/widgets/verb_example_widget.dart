import 'package:flutter/material.dart';

class VerbExampleWidget extends StatelessWidget {
  final String form;
  final String english;
  final String romaji;

  const VerbExampleWidget({
    required this.form,
    required this.english,
    required this.romaji,
    super.key  
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        border: BoxBorder.all(),
        borderRadius: BorderRadius.circular(10)
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                color: Colors.white12
              ),
              padding: EdgeInsets.all(4),
              alignment: Alignment.centerLeft,
              height: 40,
              width: MediaQuery.of(context).size.width * .7,
              child: Text(
                "Form",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
            ),
            const SizedBox(height:10),
          Container(
              decoration: BoxDecoration(
                color: Colors.white24
              ),
              padding: EdgeInsets.all(4),
              alignment: Alignment.centerLeft,
              height: 40,
              width: MediaQuery.of(context).size.width * .7,
              child: Text(
                form,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
            ),
            const SizedBox(height:10),
          Container(
              decoration: BoxDecoration(
                color: Colors.white12
              ),
              padding: EdgeInsets.all(4),
              alignment: Alignment.centerLeft,
              height: 40,
              width: MediaQuery.of(context).size.width * .7,
              child: Text(
                "English",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
            ),
            const SizedBox(height:10),
          Container(
              decoration: BoxDecoration(
                color: Colors.white24
              ),
              padding: EdgeInsets.all(4),
              alignment: Alignment.centerLeft,
              height: 40,
              width: MediaQuery.of(context).size.width * .7,
              child: Text(
                english,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
            ),
            const SizedBox(height:10),
          Container(
              decoration: BoxDecoration(
                color: Colors.white12
              ),
              padding: EdgeInsets.all(4),
              alignment: Alignment.centerLeft,
              height: 40,
              width: MediaQuery.of(context).size.width * .7,
              child: Text(
                "Romaji",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
            ),
            const SizedBox(height:10),
          Container(
              decoration: BoxDecoration(
                color: Colors.white24
              ),
              padding: EdgeInsets.all(4),
              alignment: Alignment.centerLeft,
              height: 40,
              width: MediaQuery.of(context).size.width * .7,
              child: Text(
                romaji,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
            ),
            const SizedBox(height:10),
        ],
      ),
    );
  }
}