import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:user/Config/config.dart';
import 'package:user/Config/method.dart';
import 'package:user/Counters/cartitemcounter.dart';
import 'package:user/Widgets/customAppBar.dart';
import 'package:user/Widgets/myDrawer.dart';

import 'package:user/model/item.dart';
import 'package:user/screens/cart.dart';
import 'package:user/screens/category_products.dart';
import 'package:user/widgets/customButton.dart';
import 'package:user/widgets/customTextWidget.dart';
import 'package:user/widgets/productPageSlider.dart';

class ProductPage extends StatefulWidget {
  final ItemModel itemModel;
  ProductPage({this.itemModel});
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantityOfItems = 1;
  List<String> images;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      //appBar: MyAppBar(),
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                padding: EdgeInsets.only(),
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: MyImageSlideshow(
                        width: double.infinity,

                        height: 300,

                        initialPage: 0,

                        indicatorColor: Colors.deepOrange,

                        indicatorBackgroundColor: Colors.grey,
                        children: widget.itemModel.thumbnailUrl
                            .map(
                              (e) => InkWell(
                                onTap: () {
                                  print('pressed');
                                },
                                child: Image.network(
                                  e,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                            .toList(),

                        isLoop: true,

                        /// Called whenever the page in the center of the viewport changes.
                        onPageChanged: (value) {
                          //print('Page changed: $value');
                        },

                        /// Auto scroll interval.
                        /// Do not auto scroll with null or 0.
                        autoPlayInterval: 6000,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(0),
                        child: Text(
                          widget.itemModel.title,
                          style: boldTextStyle,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Mrp : ₹" + widget.itemModel.mrp.toString(),
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("₹" + widget.itemModel.price.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 22)),
                                  Text(
                                    widget.itemModel.discount.toString() +
                                        "% OFF",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19),
                                  ),
                                ]),
                            SizedBox(
                              height: 15.0,
                            ),
                            // CustomText(
                            //   text: widget.itemModel.shortInfo,
                            //   size: 12,
                            //   color: Colors.grey[500],
                            // ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              'Details: ',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 8.0),
                              child: Text(
                                widget.itemModel.details,
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'Description: ',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 8.0),
                              child: Text(
                                widget.itemModel.longDescription,
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 120,
                    )
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              // padding: EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        checkItemInCart(widget.itemModel, widget.itemModel.pid,
                            widget.itemModel.price.toString(), context, true);
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (_) => CartPage()));
                      },
                      child: Container(
                        decoration: new BoxDecoration(color: Colors.grey[100]),

                        // width: MediaQuery.of(context).size.width - 40.0,
                        height: 60.0,
                        child: Center(
                          child: Text(
                            "Buy Now",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => checkItemInCart(
                          widget.itemModel,
                          widget.itemModel.pid,
                          widget.itemModel.price.toString(),
                          context,
                          false),
                      child: Container(
                        decoration: new BoxDecoration(
                          gradient: new LinearGradient(
                            colors: [
                              Colors.deepOrangeAccent,
                              Colors.deepOrange
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp,
                          ),
                        ),

                        // width: MediaQuery.of(context).size.width - 40.0,
                        height: 60.0,
                        child: Center(
                          child: Text(
                            "Add to Cart",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  final boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  final largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
}
