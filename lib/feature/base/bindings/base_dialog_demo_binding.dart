import 'package:get/get.dart';

import '../logics/base_dialog_demo_logic.dart';

class BaseDialogDemoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BaseDialogDemoLogic>(() => BaseDialogDemoLogic());
  }
} 