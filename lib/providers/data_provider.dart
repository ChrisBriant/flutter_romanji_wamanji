import 'package:flutter/material.dart';
import '../data/verb.dart';

class DataProvider extends ChangeNotifier {
  List<Verb> _allVerbs = [];

  setAllVerbs(List<Map<String,dynamic>> verbs) {
    for ( Map<String,dynamic> verb in verbs) {
      _allVerbs.add(Verb.fromJson(verb));
    }
    //_allVerbs = verbs;  
    notifyListeners();
  }

  List<Verb> get allVerbs => _allVerbs;

}