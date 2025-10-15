import 'package:get/get.dart';

import '../../feature/main/bindings/main_binding.dart';
import '../../feature/main/views/main_view.dart';
import 'main_routes.dart';

/// 主页模块页面配置
class MainPages {
  MainPages._();

  static final routes = [
    GetPage(
      name: MainRoutes.main,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
  ];
}