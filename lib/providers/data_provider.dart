import 'package:flutter/material.dart';
import '../data/verb.dart';

class DataProvider extends ChangeNotifier {
  Paginator<Verb>? _allVerbsPaginator;
  Verb? _selectedVerb;

  void setAllVerbsPaginator(Paginator<Verb> p) {
    _allVerbsPaginator = p;
  
    notifyListeners();
  }

  void setSelectedVerb(Verb v) {
    _selectedVerb = v;
  }

  Paginator<Verb>? get allVerbsPaginator => _allVerbsPaginator;
  Verb? get selectedVerb => _selectedVerb;

}