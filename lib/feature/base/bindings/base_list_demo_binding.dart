import 'package:get/get.dart';

import '../logics/base_list_demo_logic.dart';

class BaseListDemoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BaseListDemoLogic>(() => BaseListDemoLogic());
  }
} 