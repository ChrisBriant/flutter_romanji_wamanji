import 'package:flutter/material.dart';
import '../data/verb.dart';

class DataProvider extends ChangeNotifier {
  Paginator<Verb>? _allVerbsPaginator;

  void setAllVerbsPaginator(Paginator<Verb> p) {
    _allVerbsPaginator = p;
  
    notifyListeners();
  }

  Paginator<Verb>? get allVerbsPaginator => _allVerbsPaginator;

}