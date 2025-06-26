import 'package:get/get.dart';

import '../feature/main/bindings/main_binding.dart';
import '../feature/main/views/main_view.dart';
import '../feature/base/bindings/base_demo_binding.dart';
import '../feature/base/bindings/base_list_demo_binding.dart';
import '../feature/base/bindings/base_network_demo_binding.dart';
import '../feature/base/bindings/base_refresh_demo_binding.dart';
import '../feature/base/bindings/base_tab_demo_binding.dart';
import '../feature/base/bindings/base_dialog_demo_binding.dart';
import '../feature/base/views/base_demo_view.dart';
import '../feature/base/views/base_list_demo_view.dart';
import '../feature/base/views/base_network_demo_view.dart';
import '../feature/base/views/base_refresh_demo_view.dart';
import '../feature/base/views/base_tab_demo_view.dart';
import '../feature/base/views/base_dialog_demo_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.BASE_DEMO,
      page: () => const BaseDemoView(),
      binding: BaseDemoBinding(),
    ),
    GetPage(
      name: _Paths.BASE_LIST_DEMO,
      page: () => const BaseListDemoView(),
      binding: BaseListDemoBinding(),
    ),
    GetPage(
      name: _Paths.BASE_NETWORK_DEMO,
      page: () => const BaseNetworkDemoView(),
      binding: BaseNetworkDemoBinding(),
    ),
    GetPage(
      name: _Paths.BASE_REFRESH_DEMO,
      page: () => const BaseRefreshDemoView(),
      binding: BaseRefreshDemoBinding(),
    ),
    GetPage(
      name: _Paths.BASE_TAB_DEMO,
      page: () => const BaseTabDemoView(),
      binding: BaseTabDemoBinding(),
    ),
    GetPage(
      name: _Paths.BASE_DIALOG_DEMO,
      page: () => const BaseDialogDemoView(),
      binding: BaseDialogDemoBinding(),
    ),
  ];
}
