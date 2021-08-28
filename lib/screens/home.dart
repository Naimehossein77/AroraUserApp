// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:e_shop/Store/cart.dart';
// import 'package:e_shop/Store/product_page.dart';
// import 'package:e_shop/Counters/cartitemcounter.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user/Config/config.dart';
import 'package:user/Config/method.dart';
import 'package:user/Counters/ImageBannerProvider.dart';
import 'package:user/Counters/cartitemcounter.dart';
import 'package:user/Widgets/myDrawer.dart';
import 'package:user/model/imageBannerModel.dart';
import 'package:user/model/item.dart';
import 'package:user/screens/cart.dart';
import 'package:user/widgets/bannerImage.dart';
import 'package:user/widgets/categoryHorizontalList.dart';
import 'package:user/widgets/categoryProductCard.dart';
import 'package:user/widgets/customTextWidget.dart';
import 'package:user/widgets/productCard.dart';
import 'package:user/screens/Search.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  static List<String> bannerImage;
  List<Widget> imageSliders = [];
  bool isShimmerOnImageBanner = true;
  List<Image> images;
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void initState() {
    super.initState();
    EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, []);
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartListPrice, []);
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartListQuantity, []);
    _deleteUserCart();

    _getBannerImageFromFirebase();
  }

//TO PRELOADE THE IMAGE/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  _getBannerImageFromFirebase() async {
    bannerImage = await getBannerImageFromFirebase();
    if (bannerImage == null) {
      isShimmerOnImageBanner = true;
      Provider.of<ImageBannerProvider>(context, listen: false).notify(true);
    } else {
      isShimmerOnImageBanner = false;
      images = bannerImage
          .map((e) => Image.network(
                e,
                fit: BoxFit.fill,
              ))
          .toList();

      Timer(Duration(milliseconds: 000), () {
        Provider.of<ImageBannerProvider>(context, listen: false)
            .notify(isShimmerOnImageBanner);
      });
    }

    //bannerImage = result;
    print('in Home getting bannerImage');
    // bannerImage = bannerImage;
    print(bannerImage);
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void _deleteUserCart() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({
      EcommerceApp.userCartList: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList),
      EcommerceApp.userCartListPrice: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartListPrice),
      EcommerceApp.userCartListQuantity: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartListQuantity),
    });
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 3,
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
          "Arora Brush",
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.white,
            //fontFamily: "NotoSerifBold",
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4, top: 4),
            child: Stack(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Route route =
                          MaterialPageRoute(builder: (c) => CartPage());
                      Navigator.push(context, route);
                    }),
                Positioned(
                  child: Stack(
                    children: [
                      Icon(
                        Icons.brightness_1_outlined,
                        size: 20.0,
                        color: Colors.white,
                      ),
                      Positioned(
                        top: 3.0,
                        bottom: 4.0,
                        left: 6.0,
                        child: Consumer<CartItemCounter>(
                          builder: (context, counter, _) {
                            return Text(
                              counter.count.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            //SearchBox
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: GestureDetector(
                onTap: () {
                  Route route =
                      MaterialPageRoute(builder: (c) => SearchProduct());
                  Navigator.push(context, route);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(
                        color: Colors.grey[200],
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  width: double.infinity,
                  height: 37,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.grey[500],
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Search Here',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 14.0),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 19,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // SearchBox(),
            Consumer<ImageBannerProvider>(builder: (_, snapshot, c) {
              return snapshot.isShimmer || bannerImage == null
                  ? ImageBannerShimmer()
                  : BannerImage(
                      imgList: bannerImage,
                      images: images,
                    );
            }),

            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
              child: CustomText(
                text: 'Category',
                size: 18,
                color: Colors.blueGrey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            CategoryHorizontalList(),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 20, bottom: 10),
              child: CustomText(
                text: 'Featured Products',
                size: 18,
                color: Colors.blueGrey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            ProductsList(),
          ],
        ),
      ),
    );
  }
}

class ProductsList extends StatefulWidget {
  //const ProductsList({ Key? key }) : super(key: key);

  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  void initState() {
    super.initState();
    _collectProduct();
  }

  void _collectProduct() async {}
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("products")
          .where('isFeatured', isEqualTo: true)
          .snapshots(),
      builder: (context, dataSnapshot) {
        return dataSnapshot == null || !dataSnapshot.hasData
            ? Center(
                child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal),
              ))
            : GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 1,
                    childAspectRatio: .69),
                itemBuilder: (context, index) {
                  ItemModel model;
                  if (dataSnapshot.hasData)
                    model = ItemModel.fromJson(
                        dataSnapshot.data.docs[index].data());
                  //debugPrint(dataSnapshot.data.documents.length.toString());
                  if (dataSnapshot.hasData)
                    return CategoryProductCard(
                      model: model,
                    );
                  else
                    return Text('No more products');
                },
                itemCount:
                    dataSnapshot != null ? dataSnapshot.data.docs.length : 0,
              );
      },
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      // Route route =
      //     MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
      // Navigator.push(context, route);
    },
    splashColor: Colors.deepOrange,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        height: 250.0,
        width: width,
        child: Row(
          children: [
            Image.network(
              model.thumbnailUrl[0],
              width: 140.0,
              height: 140.0,
            ),
            SizedBox(
              width: 4.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            model.title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            model.shortInfo,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 11.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            model.category,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 10.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10.0,
                  ),

                  Row(
                    children: [
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0.0),
                            child: Row(
                              children: [
                                Text(
                                  "MRP: ₹ ",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.blueGrey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                Text(
                                  model.mrp.toString(),
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.blueGrey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  "Price: ",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                Text(
                                  "₹ ",
                                  style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  (model.price).toString(),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  "Discount:  ",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.blueGrey,
                                    // decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                Text(
                                  model.discount.toString() + "% OFF",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.green,
                                    // decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Flexible(
                    child: Container(),
                  ),
                  //to implement cart item remove feature
                  Align(
                    alignment: Alignment.centerRight,
                    child: removeCartFunction == null
                        ? IconButton(
                            icon: Icon(
                              Icons.add_shopping_cart,
                              color: Colors.deepOrange,
                            ),
                            onPressed: () {
                              // checkItemInCart(model.shortInfo, context);
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.remove_shopping_cart,
                              color: Colors.deepOrange,
                            ),
                            onPressed: () {
                              removeCartFunction();
                              Route route = MaterialPageRoute(
                                  builder: (c) => StoreHome());
                              Navigator.pushReplacement(context, route);
                            },
                          ),
                  ),
                  Divider(
                    height: 5.0,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height: 150.0,
    width: width * .34,
    margin: EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10,
    ),
    decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: Offset(0.5, 5),
            blurRadius: 10.0,
            color: Colors.grey,
          ),
        ]),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Image.network(
        imgPath,
        height: 150.0,
        width: width * .34,
        fit: BoxFit.fill,
      ),
    ),
  );
}

// void checkItemInCart(String shortInfoAsId, BuildContext context) {
//   EcommerceApp.sharedPreferences
//           .getStringList(EcommerceApp.userCartList)
//           .contains(shortInfoAsId)
//       ? Fluttertoast.showToast(msg: "Item already present in cart")
//       : addItemToCart(shortInfoAsId, context);
// }

// addItemToCart(String shortInfoAsId, BuildContext context) {
//   List tempCartList =
//       EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
//   tempCartList.add(shortInfoAsId);

//   EcommerceApp.firestore
//       .collection(EcommerceApp.collectionUser)
//       .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
//       .updateData({
//     EcommerceApp.userCartList: tempCartList,
//   }).then((v) {
//     Fluttertoast.showToast(msg: "Item added to cart");
//     EcommerceApp.sharedPreferences
//         .setStringList(EcommerceApp.userCartList, tempCartList);
//     Provider.of<CartItemCounter>(context, listen: false).displayResult();
//   });
// }