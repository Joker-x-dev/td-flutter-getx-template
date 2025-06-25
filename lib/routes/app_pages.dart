import 'package:get/get.dart';

import '../feature/main/bindings/main_binding.dart';
import '../feature/main/views/main_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
  ];
}
