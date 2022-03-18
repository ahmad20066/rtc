// ignore_for_file: prefer_const_constructors

import 'package:e_commerce/modules/login/login_screen.dart';
import 'package:e_commerce/modules/signup/singup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabsController extends GetxController {
  final pages = [
    SignUpScreen(),
    LoginScreen(),
  ];
  final tabs = [
    Tab(
      child: Text(
        "Sign Up",
      ),
    ),
    Tab(
      child: Text(
        "Log In",
      ),
    ),
  ];
}
