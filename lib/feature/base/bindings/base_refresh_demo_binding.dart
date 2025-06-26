import 'package:get/get.dart';

import '../logics/base_refresh_demo_logic.dart';

class BaseRefreshDemoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BaseRefreshDemoLogic>(() => BaseRefreshDemoLogic());
  }
} 