import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user/Config/config.dart';
import 'package:user/Counters/changeAddresss.dart';
import 'package:user/Widgets/customAppBar.dart';
import 'package:user/Widgets/loadingWidget.dart';
import 'package:user/model/address.dart';
import 'package:user/orders/placeOrderPayment.dart';
import 'package:user/widgets/wideButton.dart';

import 'addAddress.dart';

class Address extends StatefulWidget {
  final double totalAmount;
  final double cartTotal;
  //final int gst;
  final int shipping;
  var value;
  Address(
      {Key key,
      this.totalAmount,
      this.value,
      this.cartTotal,
      // this.gst,
      this.shipping})
      : super(key: key);
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  void initState() {
    // TODO: implement initState
    print("address received" +
        widget.cartTotal.toString() +
        " " +
        widget.shipping.toString() +
        " " +
        //widget.gst.toString() +
        " " +
        widget.totalAmount.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Select Address",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Consumer<AddressChanger>(builder: (context, address, c) {
              return Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: EcommerceApp.firestore
                      .collection(EcommerceApp.collectionUser)
                      .doc(EcommerceApp.sharedPreferences
                          .getString(EcommerceApp.userUID))
                      .collection(EcommerceApp.subCollectionAddress)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Center(
                            child: circularProgress(),
                          )
                        : snapshot.data.docs.length == 0
                            ? noAddressCard()
                            : ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return AddressCard(
                                    currentIndex: address.count,
                                    value: index,
                                    addressId: snapshot
                                        .data.docs[index].id,
                                    totalAmount: widget.totalAmount,
                                    shipping: widget.shipping,
                                    //gst: widget.gst,
                                    cartTotal: widget.cartTotal,
                                    model: AddressModel.fromJson(
                                        snapshot.data.docs[index].data()),
                                  );
                                },
                              );
                  },
                ),
              );
            }),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text("Add New Address"),
          backgroundColor: Colors.deepOrange,
          icon: Icon(Icons.add_location_alt_outlined),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AddAddress());
            Navigator.pushReplacement(context, route);
          },
        ),
      ),
    );
  }

  noAddressCard() {
    return Card(
      color: Colors.deepOrange.withOpacity(0.5),
      child: Container(
        height: 100.0,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_location_alt_outlined,
              color: Colors.white,
            ),
            Text("No saved shipment address!"),
            Text("Please add an address"),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model;
  final String addressId;
  final double totalAmount;
  final int currentIndex;
  final int value;
  final double cartTotal;
  //final int gst;
  final int shipping;

  AddressCard(
      {Key key,
      this.model,
      this.currentIndex,
      this.addressId,
      this.totalAmount,
      this.value,
      this.cartTotal,
      //this.gst,
      this.shipping})
      : super(key: key);
  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  void initState() {
    // TODO: implement initState
    print("address card received" +
        widget.cartTotal.toString() +
        " " +
        widget.shipping.toString() +
        " " +
        // widget.gst.toString() +
        " " +
        widget.totalAmount.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Provider.of<AddressChanger>(context, listen: false)
            .displayResult(widget.value);
      },
      child: Card(
        //color: Colors.deepOrange.withOpacity(0.2),
        elevation: 5,
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  groupValue: widget.currentIndex,
                  value: widget.value,
                  activeColor: Colors.deepOrange,
                  onChanged: (val) {
                    Provider.of<AddressChanger>(context, listen: false)
                        .displayResult(val);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: screenWidth * 0.8,
                      child: Table(
                        children: [
                          TableRow(children: [
                            KeyText(
                              msg: "Name",
                            ),
                            Text(widget.model.name),
                          ]),
                          TableRow(children: [
                            KeyText(
                              msg: "Phone Number",
                            ),
                            Text(widget.model.phoneNumber),
                          ]),
                          TableRow(children: [
                            KeyText(
                              msg: "Address",
                            ),
                            Text(widget.model.flatNumber),
                          ]),
                          TableRow(children: [
                            KeyText(
                              msg: "City",
                            ),
                            Text(widget.model.city),
                          ]),
                          TableRow(children: [
                            KeyText(
                              msg: "State",
                            ),
                            Text(widget.model.state),
                          ]),
                          TableRow(children: [
                            KeyText(
                              msg: "Pin Code",
                            ),
                            Text(widget.model.pincode),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            widget.value == Provider.of<AddressChanger>(context).count
                ? WideButton(
                    message: "Proceed",
                    onPressed: () {
                      Route route = MaterialPageRoute(
                          builder: (c) => PaymentPage(
                                addressId: widget.addressId,
                                totalAmount: widget.totalAmount,
                                value: widget.value,
                                cartTotal: widget.cartTotal,
                                //gst: widget.gst,
                                shipping: widget.shipping,
                              ));
                      Navigator.push(context, route);
                    },
                  )
                : Container(),
          ],
        ),
      ),
    
    );
  }
}

class KeyText extends StatelessWidget {
  final String msg;

  KeyText({Key key, this.msg}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      msg,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
