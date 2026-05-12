import 'package:flutter/material.dart';
import '../data/verb.dart';

class DataProvider extends ChangeNotifier {
  Paginator<Verb>? _allVerbsPaginator;
  Paginator<VerbExample>? _allVerbsExamplePaginator;
  Verb? _selectedVerb;
  VerbExample? _selectedVerbExample;
  List<VerbExample>? _examplesForVerb;

  void setAllVerbsPaginator(Paginator<Verb> p) {
    _allVerbsPaginator = p;
  
    notifyListeners();
  }

  void setAllVerbExamplesPaginator(Paginator<VerbExample> p) {
    _allVerbsExamplePaginator = p;
  
    notifyListeners();
  }

  void setExamplesForVerb(List<Map<String,dynamic>> examplesRaw) {
    _examplesForVerb = examplesRaw.map((ve) => VerbExample.fromJson(ve)).toList();

    notifyListeners();
  }

  void setSelectedVerbExample(VerbExample ve) {
    _selectedVerbExample = ve;

    notifyListeners();
  }

  void setSelectedVerb(Verb v) {
    _selectedVerb = v;

    notifyListeners();
  }

  Paginator<Verb>? get allVerbsPaginator => _allVerbsPaginator;
  Verb? get selectedVerb => _selectedVerb;
  Paginator<VerbExample>? get allVerbsExamplePaginator => _allVerbsExamplePaginator;
  VerbExample? get selectedVerbExample => _selectedVerbExample;
  List<VerbExample>? get examplesForVerb => _examplesForVerb;
}