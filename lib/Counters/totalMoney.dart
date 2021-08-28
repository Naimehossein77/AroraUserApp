import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:user/Config/config.dart';
import 'package:user/model/item.dart';

class TotalAmount extends ChangeNotifier {
  double _totalAmount = 0;
  List<String> _tempQuantity = EcommerceApp.sharedPreferences
      .getStringList(EcommerceApp.userCartListQuantity);

  List<String> _tempUserCartPrice = EcommerceApp.sharedPreferences
      .getStringList(EcommerceApp.userCartListPrice);

  List<String> get getQuantity => _tempQuantity;
  double get totalAmount => _totalAmount;

  void display(double no) {
    _totalAmount = no;
    notifyListeners();
  }

  void add(double no) {
    _totalAmount += no;
    notifyListeners();
  }

  void update() {
    _tempQuantity = EcommerceApp.sharedPreferences
        .getStringList(EcommerceApp.userCartListQuantity);
    _tempUserCartPrice = EcommerceApp.sharedPreferences
        .getStringList(EcommerceApp.userCartListPrice);
    notifyListeners();
  }

  void delete(double no) {
    _totalAmount = _totalAmount - no < 0 ? 0 : _totalAmount - no;
    notifyListeners();
  }

  void changeQuantity(int no, int index, ItemModel model) async {
    if (no + double.parse(_tempQuantity[index]) >= 0) {
      _totalAmount +=
          no * (double.parse(_tempUserCartPrice[index]));
      _tempQuantity[index] = (int.parse(_tempQuantity[index]) + no).toString();
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartListQuantity, _tempQuantity);

      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({
        EcommerceApp.userCartListQuantity: _tempQuantity,
      });
    } else {
      _totalAmount = _totalAmount;
    }

    notifyListeners();
  }
}
