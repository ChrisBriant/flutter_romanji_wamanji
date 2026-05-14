import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import './listpair_widget.dart';

class ListPairWithAction extends StatelessWidget {
  final String textA;
  final String textB;
  final VoidCallback formClickAction;
  final bool loading;

  const ListPairWithAction({
    required this.textA,
    required this.textB,
    required this.formClickAction,
    required this.loading,
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
          icon: loading ? CircularProgressIndicator() : Icon(Icons.lightbulb_circle_outlined)
        )
      ],
    );
  }
}