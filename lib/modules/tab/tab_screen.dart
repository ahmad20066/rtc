// ignore_for_file: prefer_const_constructors

import 'package:e_commerce/modules/tab/tabs_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabsScreen extends StatelessWidget {
  static const routeName = '/TabScreen';
  TabsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: controller.tabs.length,
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 160,
              ),
              TabBar(
                labelColor: Color.fromRGBO(81, 92, 111, 1),
                labelStyle:
                    TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                unselectedLabelColor: Color.fromRGBO(81, 92, 111, 0.5),
                unselectedLabelStyle:
                    TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                indicatorColor: Colors.transparent,
                tabs: controller.tabs,
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(child: TabBarView(children: controller.pages)),
            ],
          ),
        ));
  }
}
