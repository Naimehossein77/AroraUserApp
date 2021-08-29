import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:user/Address/addAddress.dart';
import 'package:user/Address/address.dart';
import 'package:user/Config/config.dart';
import 'package:user/Counters/changeAddresss.dart';
import 'package:user/Orders/placeOrderPayment.dart';
import 'package:user/model/address.dart';
import 'package:user/model/item.dart';
import 'package:user/widgets/customAddTextField.dart';
import 'package:user/widgets/customAppBar.dart';
import 'package:user/widgets/customTextWidget.dart';
import 'package:user/widgets/loadingWidget.dart';
import 'package:user/widgets/mydrawer.dart';
import 'package:user/widgets/wideButton.dart';

class ProfilePage extends StatefulWidget {
  //const ProfilePage({ Key? key }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _txtNameController = TextEditingController();
  TextEditingController _txtPhnController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _txtNameController.text =
        EcommerceApp.sharedPreferences.getString(EcommerceApp.userName);
    _txtPhnController.text =
        EcommerceApp.sharedPreferences.getString(EcommerceApp.userPhone);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            "User Profile",
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.white,
              //fontFamily: "NotoSerifBold",
            ),
          ),
          centerTitle: true,
        ),
        drawer: MyDrawer(),
        body: Container(
          padding: EdgeInsets.all(25.0),
          child: ListView(
            children: [
              Text(
                'User Details',
                style: TextStyle(fontSize: 20.0),
              ),
              CustomAddProduct(
                hintname: 'Name',
                txtcontroller: _txtNameController,
              ),
              CustomAddProduct(
                hintname: 'Phone Number',
                txtcontroller: _txtPhnController,
              ),
              SizedBox(
                height: 30.0,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      "Apply Changes",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.deepOrange,
                    onPressed: () {
                      if (_txtNameController.text.isEmpty ||
                          _txtPhnController.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Please Fill all Fields",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else
                        editProfile();
                    },
                  ),
                ),
              ),
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////ADRESS USER/////////////////////////////////////////////////////////////////////////////////////////////////////////////

              SizedBox(
                height: 30,
              ),
              CustomText(
                text: 'Currently Saved Addresses:',
                fontWeight: FontWeight.bold,
                size: 16,
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot>(
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
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return AddressCard(
                                  model: AddressModel.fromJson(
                                      snapshot.data.docs[index].data()),
                                );
                              },
                            );
                },
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text("Add New Address"),
          backgroundColor: Colors.deepOrange,
          icon: Icon(Icons.add_location_alt_outlined),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AddAddress());
            Navigator.push(context, route);
          },
        ),
      ),
    );
  }

  void editProfile() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .update({
      "name": _txtNameController.text,
      "phone": _txtPhnController.text,
    }).then((value) {
      EcommerceApp.sharedPreferences
          .setString(EcommerceApp.userName, _txtNameController.text);
      EcommerceApp.sharedPreferences
          .setString(EcommerceApp.userPhone, _txtPhnController.text);
      Fluttertoast.showToast(
          msg: "changes Applied successfully", gravity: ToastGravity.BOTTOM);
    }).catchError((error) => print("Failed to update user: $error"));
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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///

class AddressCard extends StatefulWidget {
  AddressCard({Key key, this.model}) : super(key: key);
  final AddressModel model;
  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Card(
        //color: Colors.deepOrange.withOpacity(0.2),
        elevation: 5,
        child: Column(
          children: [
            Row(
              children: [
                // Radio(
                //   groupValue: widget.currentIndex,
                //   value: widget.value,
                //   activeColor: Colors.deepOrange,
                //   onChanged: (val) {
                //     Provider.of<AddressChanger>(context, listen: false)
                //         .displayResult(val);
                //   },
                // ),
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
            // widget.value == Provider.of<AddressChanger>(context).count
            //     ? WideButton(
            //         message: "Proceed",
            //         onPressed: () {
            //           Route route = MaterialPageRoute(
            //               builder: (c) => PaymentPage(
            //                     addressId: widget.addressId,
            //                     totalAmount: widget.totalAmount,
            //                     value: widget.value,
            //                     cartTotal: widget.cartTotal,
            //                     //gst: widget.gst,
            //                     shipping: widget.shipping,
            //                   ));
            //           Navigator.push(context, route);
            //         },
            //       )
            //     :
            Container(
              child: WideButton(
                message: "Edit Adress",
                onPressed: () {
                  Route route = MaterialPageRoute(
                      builder: (c) => AddAddress(
                            model: widget.model,
                          ));
                  Navigator.push(context, route);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
