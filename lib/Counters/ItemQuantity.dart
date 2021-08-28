import 'package:flutter/foundation.dart';

class ItemQuantity with ChangeNotifier {
  int _numerOfItems = 0;

  int get numerOfItems => _numerOfItems;

  display(int no) {
    _numerOfItems = no;
    notifyListeners();
  }
}
