import 'package:get/get.dart';

import '../logics/base_demo_logic.dart';
import '../logics/main_logic.dart';
import '../logics/network_demo_logic.dart';
import '../logics/theme_demo_logic.dart';
import '../logics/utils_demo_logic.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainLogic>(() => MainLogic());
    Get.lazyPut<BaseDemoLogic>(() => BaseDemoLogic());
    Get.lazyPut<NetworkDemoLogic>(() => NetworkDemoLogic());
    Get.lazyPut<UtilsDemoLogic>(() => UtilsDemoLogic());
    Get.lazyPut<ThemeDemoLogic>(() => ThemeDemoLogic());
  }
}
