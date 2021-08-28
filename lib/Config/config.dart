import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:shared_preferences/shared_preferences.dart';

class EcommerceApp {
  static const String appName = 'Arora-Brush';

  static SharedPreferences sharedPreferences;
  static User user = FirebaseAuth.instance.currentUser;
  static FirebaseAuth auth;
  static FirebaseFirestore firestore;

  static String collectionUser = "users";
  static String collectionOrders = "orders";
  static String userCartList = 'userCart';
  static String userCartListQuantity = 'userCartQuantity';
  static String userCartListPrice = 'userCartPrice';

  static String subCollectionAddress = 'userAddress';

  static final String userName = 'name';
  static final String userPhone = 'phone';
  static final String userEmail = 'email';
  static final String userUID = 'uid';

  static final String addressID = 'addressID';
  static final String shortInfo = 'shortInfo';
  static final String totalAmount = 'totalAmount';
  static final String productID = 'pid';
  static final String paymentDetails = 'paymentDetails';
  static final String orderTime = 'orderTime';
  static final String isSuccess = 'isSuccess';
  static final String isCompleted = 'isCompleted';
  static List<String> category = [
    'All',
    'Round',
    'Flat',
    'Mop',
    'Butterfly',
    'Comb',
    'Wash',
    'Dagger',
    'Angular',
    'Deerfoot',
    'Rigger',
    'Fan',
    'Notch',
    'Filbert',
    "Cat's tongue",
    'Mix',
    'Special',
    'Brush Handle',
    'Brush Head',
    'Brush Ferrule',
    'Brush Hair'
  ];
}
