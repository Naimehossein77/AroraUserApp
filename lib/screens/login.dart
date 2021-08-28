// import 'package:admin_panel/DialogBox/errorDialog.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:e_shop/Admin/uploadItems.dart';
// import 'package:e_shop/Authentication/authenication.dart';
// import 'package:e_shop/Widgets/customTextField.dart';

// import 'package:admin_panel/screens/admin_panel.dart';
// import 'package:admin_panel/widgets/customButton.dart';
// import 'package:admin_panel/widgets/customTextField.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user/Config/config.dart';
import 'package:user/DialogBox/errorDialog.dart';
import 'package:user/DialogBox/loadingDialog.dart';
import 'package:user/screens/home.dart';
import 'package:user/screens/signUp.dart';
import 'package:user/widgets/customTextField.dart';
import 'package:user/widgets/customButton.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          // decoration: new BoxDecoration(
          //   gradient: new LinearGradient(
          //     colors: [Colors.deepOrangeAccent, Colors.deepOrange],
          //     begin: const FractionalOffset(0.0, 0.0),
          //     end: const FractionalOffset(1.0, 0.0),
          //     stops: [0.0, 1.0],
          //     tileMode: TileMode.clamp,
          //   ),
          // ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  "images/admin.png",
                  height: 240.0,
                  width: 240.0,
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(left: 10.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                  child: Text(
                    "Welcome,",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(left: 10.0, bottom: 20.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                  child: Text(
                    "Sign In to Continue!",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _emailTextEditingController,
                      data: Icons.person,
                      hintText: "Email ID",
                      isObsecure: false,
                    ),
                    CustomTextField(
                      controller: _passwordTextEditingController,
                      data: Icons.lock,
                      hintText: "Enter Password",
                      isObsecure: true,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              CustomButton(
                color: Theme.of(context).primaryColor,
                text: 'Login',
                textColor: Colors.white,
                click: () {
                  _emailTextEditingController.text.isNotEmpty &&
                          _passwordTextEditingController.text.isNotEmpty
                      ? loginUser()
                      : showDialog(
                          context: context,
                          builder: (c) {
                            return ErrorAlertDialog(
                              message: "Please fill all fields!",
                            );
                          });
                },
              ),
              Container(
                child: TextButton(
                  focusNode: FocusNode(
                    descendantsAreFocusable: false,
                  ),
                  onPressed: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => SignUpScreen());
                    Navigator.pushReplacement(context, route);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'I am New User.',
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Logging In. Please wait!",
          );
        });
    User firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((authUser) {
      firebaseUser = authUser.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if (firebaseUser != null) {
      readData(firebaseUser).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future readData(User fUser) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(fUser.uid)
        .get()
        .then((dataSnapshot) async {
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userUID, dataSnapshot.data()[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userEmail, dataSnapshot.data()[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userName, dataSnapshot.data()[EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userPhone, dataSnapshot.data()[EcommerceApp.userPhone]);

      List<String> cartList =
          dataSnapshot.data()[EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, cartList);
      List<String> cartListPrice =
          dataSnapshot.data()[EcommerceApp.userCartListPrice].cast<String>();
      await EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartListPrice, cartListPrice);
    });
  }
}
