import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/Config/config.dart';

List getUserCartList() {
  return EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);

}
List getUserQuantityList() {
  return EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartListQuantity);
}
