import 'package:flutter/material.dart';

class CustomAddProduct extends StatelessWidget {
  final String hintname;
  final Color colors;
  final TextEditingController txtcontroller;
  final TextInputType keyboard;

  CustomAddProduct({
    this.hintname,
    this.colors,
    this.txtcontroller,
    this.keyboard,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        controller: txtcontroller,
        keyboardType: keyboard,
        cursorColor: colors,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: hintname,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
