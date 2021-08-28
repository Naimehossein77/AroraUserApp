import 'package:flutter/material.dart';

class Customer {
  final String name;
  final String address1;
  final String address2;

  final String phone;

  const Customer(
      {@required this.name,
      @required this.address1,
      @required this.address2,
      @required this.phone});
}
