import 'package:e_commerce/modules/home/home_controller.dart';
import 'package:get/get.dart';

class HomeBindiing implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
  }
}
