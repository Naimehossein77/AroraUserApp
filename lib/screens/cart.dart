import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:user/Address/address.dart';
import 'package:user/Config/config.dart';
import 'package:user/Config/method.dart';
import 'package:user/Config/setterandgetter.dart';
import 'package:user/Counters/cartitemcounter.dart';
import 'package:user/Counters/cartwidgetProvider.dart';
import 'package:user/Counters/totalMoney.dart';
import 'package:user/Widgets/customAppBar.dart';
import 'package:user/Widgets/mydrawer.dart';
import 'package:user/model/item.dart';
import 'package:user/screens/home.dart';
import 'package:user/screens/product_page.dart';
import 'package:user/widgets/bottom.dart';
import 'package:user/widgets/customTextWidget.dart';
import 'dart:async';

import 'category_products.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalAmount = 0;

  List<String> tempCart = [], tempCartPrice = [], tempCartQuantity = [];
  dynamic tempCart1 = [], tempCartPrice1 = [], tempCartQuantity1 = [];
  var _user = FirebaseAuth.instance.currentUser;
  List<ItemModel> modelList = [];
  List boxList = getUserCartList(), quantityBoxList = getUserQuantityList();

  @override
  void initState() {
    super.initState();
    print(boxList.length);
    //_getUserCart();
    //_getCartData();

    //_addToEcommerceSharedpreferance();
  }

  // void _getCartData() async {
  //   dynamic groupList = await getallList();
  //   if (groupList == null) {
  //     print('unable to get Data');
  //   } else {
  //     print(groupList);

  //     tempCart = groupList[0];
  //     tempCartPrice = groupList[1];
  //     tempCartQuantity = groupList[2];

  //     print('tempCart:');
  //     print(tempCart);
  //     dynamic resultant = await getSearchedElementInProductList(tempCart);
  //     modelList = await resultant;
  //     print('modelList in cart');
  //     print(modelList.length);
  //     if (modelList != null) {
  //       setState(() {});
  //     }
  //   }

  // Provider.of<TotalAmount>(context, listen: false).display(0);
  // }

  Future<bool> _onBackPressed() {
    Navigator.of(context).pop(true);
  }

  void _BottomModal(BuildContext ctx, List<String> value, double totalAmount) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: Consumer<TotalAmount>(
            builder: (_, totalAmount, c) {
              return BottomPage(
                cartTotal: totalAmount.totalAmount,
                value: value,
              );
            },
          ),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              if (tempCart.length == 1) {
                Fluttertoast.showToast(msg: "Cart is empty!");
              } else {
                _BottomModal(context, tempCartQuantity, totalAmount);
              }
            },
            label: Text("Checkout"),
            backgroundColor: Colors.deepOrange,
            icon: Icon(Icons.navigate_next),
          ),
          appBar: AppBar(
            toolbarHeight: 50,
            flexibleSpace: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [Colors.deepOrangeAccent, Colors.deepOrange],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
            ),
            title: Text(
              "User Cart",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                //fontFamily: "NotoSerifBold",
              ),
            ),
            centerTitle: true,
          ),
          //drawer: MyDrawer(),
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Consumer<TotalAmount>(
                    builder: (context, amountProvider, c) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child:
                              //cartProvider.count == 0
                              amountProvider.totalAmount == 0
                                  ? Container()
                                  : Text(
                                      "Total Price: ₹${amountProvider.totalAmount.toString()}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                    child: Container(
                  child: (boxList != null && boxList.length != 0)
                      ? StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('products')
                              .where(EcommerceApp.productID, whereIn: boxList)
                              .snapshots(),
                          builder: (context, snapshot) {
                            print('snapshot size');
                            // log(boxList.toString());
                            // log(EcommerceApp.productID);
                            // log(snapshot.data.docs.length.toString());
                            return !snapshot.hasData
                                ? Container(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : snapshot.data.docs.length == 0 &&
                                        snapshot.hasData
                                    ? beginBuildingCart()
                                    : Container(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: (snapshot.hasData)
                                              ? snapshot.data.docs.length
                                              : 0,
                                          itemBuilder: (context, index) {
                                            ItemModel model =
                                                ItemModel.fromJson(snapshot
                                                    .data.docs[index]
                                                    .data());
                                            int ii;
                                            for (int i = 0;
                                                i < boxList.length;
                                                i++) {
                                              if (boxList[i] == model.pid)
                                                ii = i;
                                            }
                                            print('iiiii' + ii.toString());
                                            if (ii == null) {
                                              return Container();
                                            }
                                            return sourceInfoCart(
                                              index,
                                              ii,
                                              model,
                                              context,
                                            );
                                          },
                                        ),
                                      );
                          },
                        )
                      : beginBuildingCart(),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  beginBuildingCart() {
    return Container(
      width: MediaQuery.of(context).size.width * .98,
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Container(
          height: 100.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.insert_emoticon_rounded,
                color: Colors.white,
              ),
              Text("Cart is empty!"),
              Text("Start shopping now..."),
            ],
          ),
        ),
      ),
    );
  }

  proceed() {}

  removeItemFromUserCart(
      ItemModel model, String shortInfoAsID, BuildContext context) {
    int index;

    print('removeItemCartList called');
    List tempCartList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);

    List tempPriceList = EcommerceApp.sharedPreferences
        .getStringList(EcommerceApp.userCartListPrice);

    List tempQuantity = EcommerceApp.sharedPreferences
        .getStringList(EcommerceApp.userCartListQuantity);
    for (int i = 0; i < tempCartList.length; i++) {
      if (tempCartList[i] == shortInfoAsID) index = i;
    }
    print('TEMPQUANTITY');
    print(tempQuantity[index]);
    print(model.discount);
    Provider.of<TotalAmount>(context, listen: false)
        .delete(double.parse(tempQuantity[index].toString()) * (model.price));
    tempCartList.removeAt(index);
    tempPriceList.removeAt(index);
    tempQuantity.removeAt(index);

    boxList = tempCartList;

    print(tempCartList);
    print(tempPriceList);
    print(tempQuantity);
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .update({
      EcommerceApp.userCartList: tempCartList,
      EcommerceApp.userCartListPrice: tempPriceList,
      EcommerceApp.userCartListQuantity: tempQuantity,
    }).then((v) {
      Fluttertoast.showToast(msg: "Item removed from cart");
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, tempCartList);
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartListPrice, tempPriceList);
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartListQuantity, tempQuantity);
      Provider.of<TotalAmount>(context, listen: false).update();

      // print(EcommerceApp.sharedPreferences
      //     .getStringList(EcommerceApp.userCartListQuantity));
    });
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Widget sourceInfoCart(
    int index,
    int ii,
    ItemModel model,
    BuildContext context, {
    Color background,
  }) {
    print(model.pid);

    print(ii);
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      elevation: 7.0,
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 180,
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8),
              child: Container(
                height: 170,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Route route = MaterialPageRoute(
                            builder: (_) => ProductPage(itemModel: model));
                        Navigator.push(context, route);
                      },
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              model.thumbnailUrl[0],
                              height: 120,
                              width: 120,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              height: 110,
                              //color: Colors.white,
                              padding: EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: model.title,
                                    size: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  Text(
                                    '${model.longDescription}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Icon(
                                  //       Icons.shopping_bag_outlined,
                                  //       size: 16,
                                  //       color: Colors.grey,
                                  //     ),
                                  //     CustomText(
                                  //       text: '999+ | ',
                                  //       size: 10,
                                  //       color: Colors.grey,
                                  //     ),
                                  //     Icon(
                                  //       Icons.favorite_outline_outlined,
                                  //       color: Colors.grey,
                                  //       size: 16,
                                  //     ),
                                  //     CustomText(
                                  //       text: '120',
                                  //       color: Colors.grey,
                                  //       size: 10,
                                  //     )
                                  //   ],
                                  // ),
                                  if (model.discount != 0)
                                    RichText(
                                      text: new TextSpan(
                                        children: <TextSpan>[
                                          new TextSpan(
                                            text: 'MRP: ₹${model.mrp}',
                                            style: new TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 11,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  RichText(
                                    text: new TextSpan(
                                      children: <TextSpan>[
                                        new TextSpan(
                                          text: 'Price: ',
                                          style: new TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        new TextSpan(
                                          text: '₹ ${model.price}',
                                          style: new TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // CustomText(
                                  //   text: 'Price: ₹${model.price}',
                                  //   size: 14,
                                  //   fontWeight: FontWeight.bold,
                                  //   color: Theme.of(context).primaryColor,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Container(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      child: IconButton(
                                          splashRadius: 15,
                                          padding: EdgeInsets.zero,
                                          icon: Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          onPressed: () {
                                            Provider.of<TotalAmount>(context,
                                                    listen: false)
                                                .update();
                                            Provider.of<TotalAmount>(context,
                                                    listen: false)
                                                .changeQuantity(-1, ii, model);
                                          })),
                                ),
                                Expanded(
                                  flex: 0,
                                  child: Consumer<TotalAmount>(
                                    builder: (_, snapshot, c) {
                                      print('CHANGED IN QUANTITY COUNTER');
                                      return CustomText(
                                        text:
                                            snapshot.getQuantity[ii].toString(),
                                        size: 13,
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      child: IconButton(
                                          splashRadius: 15,
                                          iconSize: 16,
                                          padding: EdgeInsets.zero,
                                          icon: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            Provider.of<TotalAmount>(context,
                                                    listen: false)
                                                .update();
                                            Provider.of<TotalAmount>(context,
                                                    listen: false)
                                                .changeQuantity(1, ii, model);
                                            print(ii);
                                          })),
                                ),
                                // Expanded(
                                //     flex: 4,
                                //     child: ElevatedButton(
                                //       style: ButtonStyle(
                                //           backgroundColor: MaterialStateProperty.all(
                                //               Theme.of(context).primaryColor),
                                //           shape: MaterialStateProperty.all<
                                //                   RoundedRectangleBorder>(
                                //               RoundedRectangleBorder(
                                //             borderRadius: BorderRadius.circular(10.0),
                                //           ))),
                                //       child: CustomText(
                                //         text: 'Add to Cart',
                                //         size: 13,
                                //         color: Colors.white,
                                //       ),
                                //       onPressed: () {},
                                //     ))
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          TextButton(
                            onPressed: () {
                              Provider.of<TotalAmount>(context, listen: false)
                                  .update();
                              // List quantity = Provider.of<TotalAmount>(context,
                              //         listen: false)
                              //     .getQuantity;
                              removeItemFromUserCart(model, model.pid, context);
                              Provider.of<CartItemCounter>(context,
                                      listen: false)
                                  .decreament();
                              // Provider.of<TotalAmount>(context, listen: false)
                              //     .delete(double.parse(model.price.toString()) *
                              //         double.parse(quantity[ii]));
                              setState(() {});
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomText(
                                  text: 'DELETE FROM CART',
                                  size: 13,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0, left: 8),
                                  child: Icon(
                                    Icons.shopping_cart,
                                    color: Colors.deepOrange,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // return InkWell(
    //   onTap: () {
    //     Route route =
    //         MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
    //     Navigator.push(context, route);
    //   },
    //   splashColor: Colors.deepOrange,
    //   child: Padding(
    //     padding: EdgeInsets.all(6.0),
    //     child: Container(
    //       height: 210.0,
    //       width: MediaQuery.of(context).size.width,
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           ClipRRect(
    //             borderRadius: BorderRadius.circular(10),
    //             child: Image.network(
    //               model.thumbnailUrl[0],
    //               width: 120.0,
    //               height: 120.0,
    //               fit: BoxFit.fill,
    //             ),
    //           ),
    //           SizedBox(
    //             width: 4.0,
    //           ),
    //           Expanded(
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 SizedBox(
    //                   height: 15.0,
    //                 ),
    //                 Container(
    //                   child: Row(
    //                     mainAxisSize: MainAxisSize.max,
    //                     children: [
    //                       Expanded(
    //                         child: Text(
    //                           model.title,
    //                           style: TextStyle(
    //                             color: Colors.black,
    //                             fontWeight: FontWeight.bold,
    //                             fontSize: 14.0,
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   height: 5.0,
    //                 ),
    //                 Container(
    //                   child: Row(
    //                     mainAxisSize: MainAxisSize.max,
    //                     children: [
    //                       Expanded(
    //                         child: Text(
    //                           model.shortInfo,
    //                           style: TextStyle(
    //                             color: Colors.black54,
    //                             fontSize: 11.0,
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   height: 5.0,
    //                 ),

    //                 Container(
    //                   height: 27.0,
    //                   child: TextField(onChanged: (text) async {
    //                     setState(() {});
    //                     //   FirebaseFirestore.instance
    //                     //       .collection("users")
    //                     //       .doc(EcommerceApp.sharedPreferences
    //                     //           .getString(EcommerceApp.userUID))
    //                     //       .update({
    //                     //     EcommerceApp.userCartListQuantity: value
    //                     //   }).then((value) {});
    //                     //   EcommerceApp.sharedPreferences.setStringList(
    //                     //       EcommerceApp.userCartListQuantity, value);
    //                     //   print(EcommerceApp.sharedPreferences.getStringList(
    //                     //       EcommerceApp.userCartListQuantity));
    //                     // },
    //                     // keyboardType: TextInputType.number,
    //                     // decoration: InputDecoration(
    //                     //   border: InputBorder.none,
    //                     //   hintText: 'Enter a Quantity',
    //                     //   hintStyle: TextStyle(fontSize: 12.0),
    //                     //   filled: true,
    //                     //   fillColor: Colors.amberAccent,
    //                     // ),
    //                   }),
    //                 ),

    //                 SizedBox(
    //                   height: 5.0,
    //                 ),
    //                 Row(
    //                   children: [
    //                     Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Padding(
    //                           padding: EdgeInsets.only(top: 5.0),
    //                           child: Row(
    //                             children: [
    //                               Text(
    //                                 r"Price: ",
    //                                 style: TextStyle(
    //                                   fontSize: 12.0,
    //                                   color: Colors.blueGrey,
    //                                 ),
    //                               ),
    //                               Text(
    //                                 "₹ ",
    //                                 style: TextStyle(
    //                                   color: Colors.deepOrange,
    //                                   fontSize: 12.0,
    //                                 ),
    //                               ),
    //                               Text(
    //                                 (model.price * int.parse(quantity))
    //                                     .toString(),
    //                                 style: TextStyle(
    //                                   fontSize: 12.0,
    //                                   color: Colors.deepOrange,
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //                 Flexible(
    //                   child: Container(),
    //                 ),
    //                 //to implement cart item remove feature
    //                 Align(
    //                   alignment: Alignment.centerRight,
    //                   child: IconButton(
    //                     icon: Icon(
    //                       Icons.remove_shopping_cart,
    //                       color: Colors.deepOrange,
    //                     ),
    //                     onPressed: () {
    //                       removeItemFromUserCart(model.shortInfo,
    //                           model.price.toString(), quantity, context);
    //                       Provider.of<CartItemCounter>(context, listen: false)
    //                           .decreament();
    //                       Provider.of<TotalAmount>(context, listen: false)
    //                           .delete(double.parse(model.price.toString()) *
    //                               double.parse(quantity));
    //                       setState(() {});
    //                     },
    //                   ),
    //                 ),
    //                 Divider(
    //                   height: 5.0,
    //                   color: Colors.grey,
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
