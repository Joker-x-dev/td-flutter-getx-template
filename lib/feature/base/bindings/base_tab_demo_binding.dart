import 'package:get/get.dart';

import '../logics/base_tab_demo_logic.dart';

class BaseTabDemoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BaseTabDemoLogic>(() => BaseTabDemoLogic());
  }
} 