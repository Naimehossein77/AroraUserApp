import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:user/Config/config.dart';
import 'package:user/Orders/OrderDetailsPage.dart';
import 'package:user/model/item.dart';

int counter = 0;

class OrderCard extends StatefulWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderId;

  OrderCard({Key key, this.data, this.itemCount, this.orderId})
      : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  String url = "";
  @override
  void initState() {
    // TODO: implement initState

    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .doc(widget.orderId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        url = documentSnapshot['invoiceUrl'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Route route = MaterialPageRoute(
            builder: (c) => OrderDetails(orderId: widget.orderId, url: url));
        Navigator.push(context, route);
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        elevation: 7.0,
        margin:
            EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.all(10.0),
          height: widget.itemCount * 190.0,
          child: ListView.builder(
            itemCount: widget.itemCount,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (c, index) {
              ItemModel model = ItemModel.fromJson(widget.data[index].data());
              return sourceOrderInfo(model, context);
            },
          ),
        ),
      ),
    );
  }
}

Widget sourceOrderInfo(ItemModel model, BuildContext context,
    {Color background}) {
  return Container(
    color: Colors.white,
    height: 170.0,
    width: MediaQuery.of(context).size.width,
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Image.network(
            model.thumbnailUrl[0],
            width: 180.0,
          ),
        ),
        SizedBox(
          width: 10.0,
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
                        ),
                      ),
                    ),
                    PopupMenuButton(
                      offset: Offset.zero,
                      initialValue: 0,
                      iconSize: 20.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          height: 40.0,
                          child: Text("Download Invoice"),
                          value: 1,
                        ),
                      ],
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
                height: 20.0,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            Text(
                              "Total Price: ",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.blueGrey,
                              ),
                            ),
                            Text(
                              "₹ ",
                              style: TextStyle(
                                color: Colors.deepOrange,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              (model.price).toString(),
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.deepOrange,
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
              Divider(
                height: 5.0,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
