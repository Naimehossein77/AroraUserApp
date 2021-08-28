import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user/Config/config.dart';
import 'package:user/widgets/customAddTextField.dart';
import 'package:user/widgets/customAppBar.dart';
import 'package:user/widgets/mydrawer.dart';

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
          padding: EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void editProfile() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
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
}
