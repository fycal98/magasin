import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'objects/cardobject.dart';

class Cards with ChangeNotifier {
  List<CardObject> cards = [];
  void addtocard(String id, double price, String title) {
    if (cards.where((element) => element.id == id).toList().isEmpty) {
      cards.add(CardObject(id: id, price: price, title: title, count: 1));
    } else {
      cards.where((element) => element.id == id).toList()[0].count++;
    }
    notifyListeners();
  }

  void removecard(int i) {
    cards.removeAt(i);
    notifyListeners();
  }

  void clearcard() {
    cards.clear();
    notifyListeners();
  }
}
