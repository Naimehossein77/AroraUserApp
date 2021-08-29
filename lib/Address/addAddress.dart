import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user/Config/config.dart';
import 'package:user/Widgets/customAppBar.dart';
import 'package:user/model/address.dart';
import 'package:user/screens/home.dart';

class AddAddress extends StatefulWidget {
  @override
  AddressModel model;
  AddAddress({this.model});

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final formKey = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final cName = TextEditingController();

  final cPhoneNumber = TextEditingController();

  final cFlatHomeNumber = TextEditingController();

  final cCity = TextEditingController();

  final cState = TextEditingController();

  final cPinCode = TextEditingController();

  void initState() {
    if (widget.model != null) {
      cName.text = widget.model.name;
      cPhoneNumber.text = widget.model.phoneNumber;
      cFlatHomeNumber.text = widget.model.flatNumber;
      cCity.text = widget.model.city;
      cState.text = widget.model.state;
      cPinCode.text = widget.model.pincode;
    }

    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final String docNameWithTime =
                DateTime.now().millisecondsSinceEpoch.toString();
            if (formKey.currentState.validate()) {
              final model = AddressModel(
                name: cName.text.trim(),
                state: cState.text.trim(),
                pincode: cPinCode.text,
                phoneNumber: cPhoneNumber.text.trim(),
                flatNumber: cFlatHomeNumber.text.trim(),
                city: cCity.text.trim(),
                addressDocID: (widget.model == null)
                    ? docNameWithTime.trim()
                    : widget.model.addressDocID.trim(),
              ).toJson();

              //ADD TO FIRESTORE
              if (widget.model == null) {
                EcommerceApp.firestore
                    .collection(EcommerceApp.collectionUser)
                    .doc(EcommerceApp.sharedPreferences
                        .getString(EcommerceApp.userUID))
                    .collection(EcommerceApp.subCollectionAddress)
                    .doc(docNameWithTime.trim())
                    .set(model)
                    .then((value) {
                  final snack =
                      SnackBar(content: Text("New Address Added Successfully"));
                  scaffoldKey.currentState.showSnackBar(snack);
                  FocusScope.of(context).requestFocus(FocusNode());
                  formKey.currentState.reset();
                });
              } else {
                log(widget.model.addressDocID);
                EcommerceApp.firestore
                    .collection(EcommerceApp.collectionUser)
                    .doc(EcommerceApp.sharedPreferences
                        .getString(EcommerceApp.userUID))
                    .collection(EcommerceApp.subCollectionAddress)
                    .doc(widget.model.addressDocID.trim())
                    .set(model)
                    .then((value) {
                  final snack =
                      SnackBar(content: Text("Address Updated Successfully"));
                  scaffoldKey.currentState.showSnackBar(snack);
                  FocusScope.of(context).requestFocus(FocusNode());
                  formKey.currentState.reset();
                });
              }

              Navigator.pop(context);
            }
          },
          label: Text("Done"),
          backgroundColor: Colors.deepOrange,
          icon: Icon(Icons.check_circle_outline),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 15.0, top: 15.0),
                  child: Text(
                    "Add New Address",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hint: "Your Name",
                      controller: cName,
                      keyboard: TextInputType.name,
                    ),
                    MyTextField(
                      hint: "Phone Number",
                      controller: cPhoneNumber,
                      keyboard: TextInputType.phone,
                      maxLines: 10,
                    ),
                    MyTextField(
                      hint: "Your Address",
                      controller: cFlatHomeNumber,
                      keyboard: TextInputType.streetAddress,
                    ),
                    MyTextField(
                      hint: "City",
                      controller: cCity,
                      maxLines: 10,
                    ),
                    MyTextField(
                      hint: "State/Country",
                      controller: cState,
                      maxLines: 15,
                    ),
                    MyTextField(
                      hint: "Pin Code",
                      controller: cPinCode,
                      keyboard: TextInputType.number,
                      maxLines: 6,
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
}

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboard;
  int maxLines;

  MyTextField(
      {Key key, this.hint, this.controller, this.keyboard, this.maxLines})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        maxLength: maxLines,
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          counterText: '',
          labelText: hint,
          alignLabelWithHint: true,
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        validator: (val) =>
            val.isEmpty ? "Please fill out the required field!" : null,
      ),
    );
  }
}
