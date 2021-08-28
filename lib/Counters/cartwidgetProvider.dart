import 'package:flutter/material.dart';
import 'package:user/Config/config.dart';

class CartWidget extends ChangeNotifier {
  Widget widget = Container(
    child: CircularProgressIndicator(),
  );
  Widget get count => widget;

  Future<void> display(Widget widget) async {
    widget = widget;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }

  Future<void> notify() async {
    widget = widget;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
