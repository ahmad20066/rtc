import 'package:e_commerce/modules/tab/tabs_controller.dart';
import 'package:get/get.dart';

class TabsBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<TabsController>(TabsController());
  }
}
