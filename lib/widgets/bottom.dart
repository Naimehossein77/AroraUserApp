import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user/Address/address.dart';
import 'package:user/widgets/customButton.dart';

class BottomPage extends StatefulWidget {
  //const BottomPage({ Key? key }) : super(key: key);
  final double cartTotal;
  List<String> value;
  BottomPage({this.cartTotal, this.value});
  @override
  _BottomPageState createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int gst = 0;
  int shipping = 0;
  double cartTotal = 0.0;
  double gstprice = 0.0;
  double totalAmount = 0;

  @override
  void initState() {
    // TODO: implement initState
    charges();
    cartTotal = widget.cartTotal;

    super.initState();
  }

  charges() async {
    await FirebaseFirestore.instance
        .collection('charges')
        .doc("charges")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        gst = documentSnapshot['gst'];
        shipping = documentSnapshot['shipping'];
        print(gst.toString() + " " + shipping.toString());
        //gstprice = cartTotal * (gst / 100);
        totalAmount = cartTotal + shipping;
      });
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.all(18.0),
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cart : ₹' + cartTotal.toString()),
              // Text('+ GST(' +
              //     gst.toString() +
              //     '%):-' +
              //     gstprice.toStringAsFixed(2)),
              cartTotal != 0
                  ? Text('Shipping : ₹$shipping')
                  : Text('Shipping : ₹0'),
              cartTotal != 0
                  ? Text(
                      'Total : ₹${totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      'Total : ₹0',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
            ],
          ),
          InkWell(
            onTap: () {
              Route route = MaterialPageRoute(
                  builder: (c) => Address(
                        totalAmount: totalAmount,
                        cartTotal: cartTotal,
                        //gst: gst,
                        shipping: shipping,
                        value: widget.value,
                      ));
              Navigator.push(context, route);
            },
            child: Container(
              width: 150.0,
              decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 4,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                gradient: new LinearGradient(
                  colors: [Colors.deepOrangeAccent, Colors.deepOrange],
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
                  "Pay now",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
