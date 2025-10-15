import 'main/main_pages.dart';
import 'base/base_pages.dart';

/// 应用页面配置
class AppPages {
  AppPages._();

  /// 所有页面路由配置
  static final routes = [
    // 主页模块
    ...MainPages.routes,

    // Base 模块
    ...BasePages.routes,
  ];
}
