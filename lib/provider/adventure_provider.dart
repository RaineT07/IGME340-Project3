// provider/movie_provider.dart
import 'package:flutter/material.dart';
import 'dart:math';
import '../models/adventure.dart';

final List<Adventure> initialData = List.generate(
  5,
  (index) =>Adventure(fullAdventure: '${String.fromCharCodes(List.generate(20, (index) => Random().nextInt(20) + 89))}')
);

class AdventureProvider with ChangeNotifier{

  final List<Adventure> _adventures = initialData;
  List<Adventure> get adventures => _adventures;


  final List<Adventure> _myList = [];
  List<Adventure> get myList => _myList;

  void addToList(Adventure adventure){
    _myList.add(adventure);
    notifyListeners();
  }

  void removeFromList(Adventure adventure){
    _myList.remove(adventure);
    notifyListeners();
  }
  void removeAllFromList(){
    _myList.clear();
    notifyListeners();
  }
}
