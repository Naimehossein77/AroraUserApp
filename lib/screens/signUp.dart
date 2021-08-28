import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user/Config/config.dart';
import 'package:user/DialogBox/errorDialog.dart';
import 'package:user/DialogBox/loadingDialog.dart';
import 'package:user/screens/home.dart';
import 'package:user/screens/login.dart';
import 'package:user/widgets/customTextField.dart';
import 'package:user/widgets/customButton.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _cPasswordTextEditingController =
      TextEditingController();
  final TextEditingController _phoneTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  margin: EdgeInsets.only(left: 10.0),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                    child: Text(
                      "Sign Up to Continue!",
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
                        controller: _nameTextEditingController,
                        data: Icons.person,
                        textInputType: TextInputType.name,
                        hintText: "Name",
                        isObsecure: false,
                      ),
                      CustomTextField(
                        controller: _phoneTextEditingController,
                        data: Icons.phone,
                        textInputType: TextInputType.phone,
                        hintText: "Phone No.",
                        maxLength: 10,
                        isObsecure: false,
                      ),
                      CustomTextField(
                        controller: _emailTextEditingController,
                        data: Icons.mail,
                        textInputType: TextInputType.emailAddress,
                        hintText: "E-mail",
                        isObsecure: false,
                      ),
                      CustomTextField(
                        controller: _passwordTextEditingController,
                        data: Icons.lock,
                        hintText: "Enter Password",
                        isObsecure: true,
                      ),
                      CustomTextField(
                        controller: _cPasswordTextEditingController,
                        data: Icons.lock_outlined,
                        hintText: "Confirm Password",
                        isObsecure: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 18.0,
                ),
                CustomButton(
                  color: Theme.of(context).primaryColor,
                  text: 'Sign Up',
                  textColor: Colors.white,
                  click: () {
                    _passwordTextEditingController.text ==
                            _cPasswordTextEditingController.text
                        ? _emailTextEditingController.text.isNotEmpty &&
                                _passwordTextEditingController
                                    .text.isNotEmpty &&
                                _cPasswordTextEditingController
                                    .text.isNotEmpty &&
                                _nameTextEditingController.text.isNotEmpty &&
                                _phoneTextEditingController.text.isNotEmpty
                            ? uploadToStorage()
                            : displayDialog("Please fill all fields!")
                        : displayDialog("Your password does not match!");
                  },
                ),
                TextButton(
                  onPressed: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => SignInScreen());
                    Navigator.pushReplacement(context, route);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already Have Account. ',
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        'Login',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Registering. Please Wait!",
          );
        });
    _registerUser();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    User firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((auth) {
      firebaseUser = auth.user;
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
      saveUserInfoToFireStore(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUserInfoToFireStore(User fUser) async {
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).set({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": _nameTextEditingController.text.trim(),
      "phone": _phoneTextEditingController.text,
      EcommerceApp.userCartList: [],
      EcommerceApp.userCartListPrice: [],
      EcommerceApp.userCartListQuantity:[],
    });

    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userUID, fUser.uid);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userEmail, fUser.email);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userName, _nameTextEditingController.text);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userPhone, _phoneTextEditingController.text);
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, []);
  }
  
}
