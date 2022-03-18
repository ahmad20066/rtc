// ignore_for_file: prefer_const_constructors

import 'package:e_commerce/bindings/home_binding.dart';
import 'package:e_commerce/bindings/tab_binding.dart';
import 'package:e_commerce/modules/home/home_screen.dart';
import 'package:e_commerce/modules/login/login_screen.dart';
import 'package:e_commerce/modules/signup/singup_screen.dart';
import 'package:e_commerce/modules/tab/tab_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(
            shadowColor: Color.fromRGBO(231, 234, 240, 1),
            scaffoldBackgroundColor: Color.fromRGBO(245, 246, 248, 1),
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(primary: Color.fromRGBO(255, 105, 105, 1))),
        builder: (context, child) => SafeArea(child: child!),
        initialRoute: HomeScreen.routeName,
        getPages: [
          GetPage(name: LoginScreen.routeName, page: () => LoginScreen()),
          GetPage(
              name: TabsScreen.routeName,
              page: () => TabsScreen(),
              binding: TabsBinding()),
          GetPage(
            name: SignUpScreen.routeName,
            page: () => SignUpScreen(),
          ),
          GetPage(
            name: HomeScreen.routeName,
            page: () => HomeScreen(),
            binding: HomeBindiing(),
          ),
        ]);
  }
}
