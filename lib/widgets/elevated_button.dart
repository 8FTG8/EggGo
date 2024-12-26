// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String labelText;
  final double fontSize;
  final FontWeight fontWeight;

  const CustomElevatedButton({
    Key? key,
    required this.labelText,
    required this.fontSize,
    required this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff000C39),
          foregroundColor: Color(0xffFDB014)),
        onPressed: () {}, 
        child: Text(
          labelText, 
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
