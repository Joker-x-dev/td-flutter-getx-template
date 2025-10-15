import 'package:get/get.dart';

import '../../feature/base/bindings/base_demo_binding.dart';
import '../../feature/base/bindings/base_list_demo_binding.dart';
import '../../feature/base/bindings/base_network_demo_binding.dart';
import '../../feature/base/bindings/base_refresh_demo_binding.dart';
import '../../feature/base/bindings/base_tab_demo_binding.dart';
import '../../feature/base/bindings/base_dialog_demo_binding.dart';
import '../../feature/base/views/base_demo_view.dart';
import '../../feature/base/views/base_list_demo_view.dart';
import '../../feature/base/views/base_network_demo_view.dart';
import '../../feature/base/views/base_refresh_demo_view.dart';
import '../../feature/base/views/base_tab_demo_view.dart';
import '../../feature/base/views/base_dialog_demo_view.dart';
import 'base_routes.dart';

/// Base 模块页面配置
class BasePages {
  BasePages._();

  static final routes = [
    GetPage(
      name: BaseRoutes.baseDemo,
      page: () => const BaseDemoView(),
      binding: BaseDemoBinding(),
    ),
    GetPage(
      name: BaseRoutes.baseListDemo,
      page: () => const BaseListDemoView(),
      binding: BaseListDemoBinding(),
    ),
    GetPage(
      name: BaseRoutes.baseNetworkDemo,
      page: () => const BaseNetworkDemoView(),
      binding: BaseNetworkDemoBinding(),
    ),
    GetPage(
      name: BaseRoutes.baseRefreshDemo,
      page: () => const BaseRefreshDemoView(),
      binding: BaseRefreshDemoBinding(),
    ),
    GetPage(
      name: BaseRoutes.baseTabDemo,
      page: () => const BaseTabDemoView(),
      binding: BaseTabDemoBinding(),
    ),
    GetPage(
      name: BaseRoutes.baseDialogDemo,
      page: () => const BaseDialogDemoView(),
      binding: BaseDialogDemoBinding(),
    ),
  ];
}