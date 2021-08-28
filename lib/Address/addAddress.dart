import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user/Config/config.dart';
import 'package:user/Widgets/customAppBar.dart';
import 'package:user/model/address.dart';
import 'package:user/screens/home.dart';

class AddAddress extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cFlatHomeNumber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (formKey.currentState.validate()) {
              final model = AddressModel(
                name: cName.text.trim(),
                state: cState.text.trim(),
                pincode: cPinCode.text,
                phoneNumber: cPhoneNumber.text,
                flatNumber: cFlatHomeNumber.text,
                city: cCity.text.trim(),
              ).toJson();

              //ADD TO FIRESTORE
              EcommerceApp.firestore
                  .collection(EcommerceApp.collectionUser)
                  .doc(EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userUID))
                  .collection(EcommerceApp.subCollectionAddress)
                  .doc(DateTime.now().millisecondsSinceEpoch.toString())
                  .set(model)
                  .then((value) {
                final snack =
                    SnackBar(content: Text("New Address Added Successfully"));
                scaffoldKey.currentState.showSnackBar(snack);
                FocusScope.of(context).requestFocus(FocusNode());
                formKey.currentState.reset();
              });

              Route route = MaterialPageRoute(builder: (c) => StoreHome());
              Navigator.pushReplacement(context, route);
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
