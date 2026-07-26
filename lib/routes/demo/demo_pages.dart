import 'package:get/get.dart';

import '../../feature/demo/bindings/network_demo_binding.dart';
import '../../feature/demo/bindings/network_list_demo_binding.dart';
import '../../feature/demo/bindings/database_demo_binding.dart';
import '../../feature/demo/bindings/local_storage_demo_binding.dart';
import '../../feature/demo/bindings/state_management_demo_binding.dart';
import '../../feature/demo/bindings/network_request_demo_binding.dart';
import '../../feature/demo/bindings/screen_adapt_demo_binding.dart';
import '../../feature/demo/bindings/navigation_with_args_binding.dart';
import '../../feature/demo/bindings/navigation_result_binding.dart';
import '../../feature/demo/bindings/base_demo_binding.dart';
import '../../feature/demo/bindings/base_refresh_demo_binding.dart';
import '../../feature/demo/bindings/base_tab_demo_binding.dart';
import '../../feature/demo/bindings/theme_demo_binding.dart';
import '../../feature/demo/views/network_demo_view.dart';
import '../../feature/demo/views/network_list_demo_view.dart';
import '../../feature/demo/views/database_demo_view.dart';
import '../../feature/demo/views/local_storage_demo_view.dart';
import '../../feature/demo/views/state_management_demo_view.dart';
import '../../feature/demo/views/network_request_demo_view.dart';
import '../../feature/demo/views/screen_adapt_demo_view.dart';
import '../../feature/demo/views/navigation_with_args_view.dart';
import '../../feature/demo/views/navigation_result_view.dart';
import '../../feature/demo/views/base_demo_view.dart';
import '../../feature/demo/views/base_refresh_demo_view.dart';
import '../../feature/demo/views/base_tab_demo_view.dart';
import '../../feature/demo/views/theme_demo_view.dart';
import 'demo_routes.dart';

/// Demo 模块页面配置
abstract final class DemoPages {
  static final List<GetPage<void>> routes = [
    GetPage(
      name: DemoRoutes.networkDemo,
      page: () => NetworkDemoView(),
      binding: NetworkDemoBinding(),
    ),
    GetPage(
      name: DemoRoutes.networkListDemo,
      page: () => NetworkListDemoView(),
      binding: NetworkListDemoBinding(),
    ),
    GetPage(
      name: DemoRoutes.databaseDemo,
      page: () => DatabaseDemoView(),
      binding: DatabaseDemoBinding(),
    ),
    GetPage(
      name: DemoRoutes.localStorageDemo,
      page: () => LocalStorageDemoView(),
      binding: LocalStorageDemoBinding(),
    ),
    GetPage(
      name: DemoRoutes.stateManagementDemo,
      page: () => StateManagementDemoView(),
      binding: StateManagementDemoBinding(),
    ),
    GetPage(
      name: DemoRoutes.networkRequestDemo,
      page: () => NetworkRequestDemoView(),
      binding: NetworkRequestDemoBinding(),
    ),
    GetPage(
      name: DemoRoutes.screenAdaptDemo,
      page: () => ScreenAdaptDemoView(),
      binding: ScreenAdaptDemoBinding(),
    ),
    GetPage(
      name: DemoRoutes.navigationWithArgs,
      page: () => NavigationWithArgsView(),
      binding: NavigationWithArgsBinding(),
    ),
    GetPage(
      name: DemoRoutes.navigationResult,
      page: () => NavigationResultView(),
      binding: NavigationResultBinding(),
    ),
    GetPage(
      name: DemoRoutes.baseDemo,
      page: () => BaseDemoView(),
      binding: BaseDemoBinding(),
    ),
    GetPage(
      name: DemoRoutes.baseRefreshDemo,
      page: () => BaseRefreshDemoView(),
      binding: BaseRefreshDemoBinding(),
    ),
    GetPage(
      name: DemoRoutes.baseTabDemo,
      page: () => BaseTabDemoView(),
      binding: BaseTabDemoBinding(),
    ),
    GetPage(
      name: DemoRoutes.themeDemo,
      page: () => ThemeDemoView(),
      binding: ThemeDemoBinding(),
    ),
  ];
}
