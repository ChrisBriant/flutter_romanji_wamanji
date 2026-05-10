import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import './listpair_widget.dart';

class ListPairWithAction extends StatelessWidget {
  final String textA;
  final String textB;
  final VoidCallback formClickAction;

  const ListPairWithAction({
    required this.textA,
    required this.textB,
    required this.formClickAction,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListPair(textA: textA, textB: textB),
        IconButton(
          onPressed: formClickAction, 
          icon: Icon(Icons.lightbulb_circle_outlined)
        )
      ],
    );
  }
}