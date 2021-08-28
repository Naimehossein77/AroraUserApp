import 'package:flutter/material.dart';
import 'package:user/Config/config.dart';

class CartItemCounter extends ChangeNotifier {
  int _counter = 0;
  int get count => _counter;

  void increament() {
    _counter++;
    notifyListeners();
  }

  void decreament() {
    _counter--;
    notifyListeners();
  }
  void displayResult(){
    notifyListeners();
  }

  // Future<void> displayResult() async {
  //   print('displayResult called');
  //   _counter = EcommerceApp.sharedPreferences
  //       .getStringList(EcommerceApp.userCartList)
  //       .length;
  //   await Future.delayed(const Duration(milliseconds: 100), () {
  //     notifyListeners();
  //   });
  // }
}
