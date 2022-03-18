// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final BorderRadiusGeometry? borderRadius;

  const CustomTextField(
      {required this.icon, required this.labelText, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 59,
      width: 325,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).shadowColor,
                blurRadius: 25,
                offset: Offset(0, 10))
          ]),
      child: TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
            labelText: labelText,
            labelStyle: TextStyle(color: Color.fromRGBO(81, 92, 111, 0.5)),
            prefixIcon: Icon(icon)),
      ),
    );
  }
}
