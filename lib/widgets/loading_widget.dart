import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String message;
  
  const LoadingWidget({
    required this.message,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(child: Text(
              message,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),

            )),
            const SizedBox(width: 10,),
            const CircularProgressIndicator(
              
            ),
          ],
        ),
      ),
    );
  }
}