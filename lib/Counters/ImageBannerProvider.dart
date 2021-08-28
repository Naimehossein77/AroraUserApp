import 'package:flutter/cupertino.dart';

class ImageBannerProvider extends ChangeNotifier {
  bool isShimmer = true;
  void notify(bool no) {
    isShimmer = no;
    notifyListeners();
  }
}
