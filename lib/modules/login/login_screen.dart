import 'package:e_commerce/components/custom_textfield.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/LoginScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          CustomTextField(
            icon: Icons.mail,
            labelText: "Email",
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          CustomTextField(icon: Icons.lock, labelText: "Password"),
        ],
      ),
    );
  }
}
