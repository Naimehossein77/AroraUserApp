import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  CustomText({
    Key key,
    @required this.text,
    this.size,
    this.color,
    this.fontWeight,
    this.fontFamily,
    this.overflow,
  }) : super(key: key);
  final String text;
  final double size;
  final FontWeight fontWeight;
  final String fontFamily;
  final Color color;
  TextOverflow overflow = TextOverflow.ellipsis;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      style: TextStyle(
          color: color ?? Colors.black,
          fontSize: size ?? 16,
          fontWeight: fontWeight ?? FontWeight.normal,
          fontFamily: fontFamily ?? 'Roboto'),
    );
  }
}
