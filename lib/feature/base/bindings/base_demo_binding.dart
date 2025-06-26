import 'package:get/get.dart';

import '../logics/base_demo_logic.dart';

class BaseDemoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BaseDemoLogic>(() => BaseDemoLogic());
  }
} 