import 'package:get/get.dart';

import '../logics/base_network_demo_logic.dart';

class BaseNetworkDemoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BaseNetworkDemoLogic>(() => BaseNetworkDemoLogic());
  }
} 