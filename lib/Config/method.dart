import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:user/Config/config.dart';
import 'package:user/Counters/cartitemcounter.dart';
import 'package:user/Counters/totalMoney.dart';
import 'package:user/model/item.dart';
import 'package:user/screens/cart.dart';

final _user = FirebaseAuth.instance.currentUser;
final _firestore = FirebaseFirestore.instance;

void checkItemInCart(ItemModel model, String shortInfoAsId, String price,
    BuildContext context, bool move) async {
  dynamic result = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .get();
  print('result');
  print(result['userCart']);

  if (result == null) {
    addItemToCart(model, shortInfoAsId, price, context, move);
  } else {
    List resultent = result['userCart'];
    var found = resultent.where((element) => element == shortInfoAsId);
    if (found.isEmpty)
      addItemToCart(model, shortInfoAsId, price, context, move);
    else
      now(move, context);
  }
}

now(bool move, BuildContext context) {
  move
      ? Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage()))
      : Fluttertoast.showToast(msg: "Item already present in cart");
}

addItemToCart(ItemModel model, String shortInfoAsId, String price,
    BuildContext context, bool move) async {
  List<String> tempCartList = [], tempPricetList = [], tempCartQuantity = [];
  tempCartList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  print(
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList));
  tempPricetList = EcommerceApp.sharedPreferences
      .getStringList(EcommerceApp.userCartListPrice);
  tempCartQuantity = EcommerceApp.sharedPreferences
      .getStringList(EcommerceApp.userCartListQuantity);
  print('tempcartList in method');
  print(tempCartList);
  // if (tempCartList == null) tempCartList = [];
  // if (tempPricetList == null) tempPricetList = [];
  // if (tempCartQuantity == null) tempCartQuantity = [];
  tempCartList.add(shortInfoAsId);
  tempPricetList.add(price);
  tempCartQuantity.add('1');
  // print(shortInfoAsId);
  // print('templist' + tempCartList.toString());
  // print(tempPricetList);

  //FIREBASE CODE TO UPDATE
  // await EcommerceApp.firestore
  await FirebaseFirestore.instance
      .collection(EcommerceApp.collectionUser)
      .doc(FirebaseAuth.instance.currentUser.uid)
      .update({
    EcommerceApp.userCartList: tempCartList,
    EcommerceApp.userCartListPrice: tempPricetList,
    EcommerceApp.userCartListQuantity: tempCartQuantity,
  }).then((v) {
    //SetOptions(merge: true))
    Fluttertoast.showToast(msg: "Item added to cart");
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, tempCartList);
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartListPrice, tempPricetList);
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartListQuantity, tempCartQuantity);
    Provider.of<CartItemCounter>(context, listen: false).increament();
    Provider.of<TotalAmount>(context, listen: false).update();
  }).then((value) {
    // double totalAmount = 0;
    // tempPricetList.forEach((element) {
    //   totalAmount += double.parse(element);
    // });
    print('DISCOUNT');
    print(model.discount);
    // Provider.of<TotalAmount>(context, listen: false)
    //     .add(double.parse(model.mrp.toString()) - model.discount);
    Provider.of<TotalAmount>(context, listen: false)
        .add(double.parse(model.price.toString()));
    context.read<CartItemCounter>().displayResult();
  });
  if (move) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage()));
  }
}

Future getallList() async {
  List userCartPrice = [], userCart = [], userCartQuantity = [];
  List groupList = [];

  dynamic result = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .get();
  userCart = result['userCart'];
  userCartPrice = result['userCartPrice'];
  userCartQuantity = result['userCartQuantity'];
  groupList.add(userCart);
  groupList.add(userCartPrice);
  groupList.add(userCartQuantity);
  print('groupList in getallList');
  print(groupList);
  return groupList;
  // try {
  //   FirebaseFirestore.instance
  //       .collection(EcommerceApp.collectionUser)
  //       .doc(FirebaseAuth.instance.currentUser.uid)
  //       .get()
  //       .then((value) {
  //     print('value.data()');
  //     print(value.data);
  //     List.from(value.data()['userCart']).forEach((element) {
  //       userCart.add(element);
  //       print(element);
  //     });
  //     List.from(value.data()['userCartPrice']).forEach((element) {
  //       userCartPrice.add(element);
  //       print(element);
  //     });
  //     List.from(value.data()['userCartQuantity']).forEach((element) {
  //       userCartQuantity.add(element);
  //       print(element);
  //     });
  //     groupList.add(userCart);
  //     groupList.add(userCartPrice);
  //     groupList.add(userCartQuantity);
  //   });
  //   print(groupList);
  //   return groupList;
  // } catch (e) {
  //   print(e.toString());
  //   return null;
  // }
}

Future<List<ItemModel>> getSearchedElementInProductList(
    List shortInfoList) async {
  List<ItemModel> modelList = [];
  //shortInfoList.forEach((element) async{
  //if (element != 'garbage') {
  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('products')
      .where(EcommerceApp.shortInfo, whereIn: shortInfoList)
      .get();
  print(result.docs.length);
  ItemModel model = null;
  result.docs.forEach((element) {
    model = ItemModel.fromJson(element.data());
    print(model);
    modelList.add(model);
  });

  print('modelList: ' + modelList.length.toString());
  // }
  // });

  if (modelList.length == shortInfoList.length - 1) return modelList;
}

Future getBannerImageFromFirebase() async {
  List<String> boxList = [];
  dynamic result = await _firestore
      .collection('sliderImage')
      .doc('bannerImage')
      .get()
      .then((value) {
    print(value['bannerImage']);

    value['bannerImage'].forEach((value) {
      boxList.add(value.toString());
    });
  });
  print('in getbannerImageMethod');
  print(boxList);
  return boxList;
}
