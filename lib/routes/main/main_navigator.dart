import '../../core/util/route/route_util.dart';
import 'main_routes.dart';

/// 主页模块导航器
class MainNavigator {
  MainNavigator._();

  /// 跳转到主页
  static Future<T?>? toMain<T>() {
    return toPage<T>(MainRoutes.main);
  }
}