import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/Counters/ImageBannerProvider.dart';
import 'package:user/Counters/ItemQuantity.dart';
import 'package:user/Counters/cartitemcounter.dart';
import 'package:user/Counters/cartwidgetProvider.dart';
import 'package:user/Counters/changeAddresss.dart';
import 'package:user/Counters/totalMoney.dart';
import 'package:user/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:user/screens/login.dart';

import 'Config/config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = FirebaseFirestore.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => CartItemCounter()),
        ChangeNotifierProvider(create: (c) => ItemQuantity()),
        ChangeNotifierProvider(create: (c) => AddressChanger()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),
        ChangeNotifierProvider(create: (c) => CartWidget()),
        ChangeNotifierProvider(create: (c) => ImageBannerProvider()),
      ],
      child: MaterialApp(
        title: 'user',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'Roboto',
            primaryColor: Colors.deepOrange,
            primarySwatch: Colors.deepOrange),
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    displaySplash();
  }

  displaySplash() {
    Timer(Duration(seconds: 2), () async {
      if (await EcommerceApp.auth.currentUser != null) {
        Route route = MaterialPageRoute(builder: (_) => StoreHome());
        Navigator.pushReplacement(context, route);
      } else {
        Route route = MaterialPageRoute(builder: (_) => SignInScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.white, Colors.white70],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/splashscreen.png",
                fit: BoxFit.cover,
              ),
              // SizedBox(
              //   height: 20.0,
              // ),
              // Text(
              //   "Painting Beauties With World Class Brushes",
              //   style: TextStyle(color: Colors.white, fontSize: 15.0),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
