import '../../core/util/route/route_util.dart';
import 'base_routes.dart';

/// Base 模块导航器
class BaseNavigator {
  BaseNavigator._();

  /// 跳转到 Base 示例页面
  static Future<T?>? toDemo<T>() {
    return toPage<T>(BaseRoutes.baseDemo);
  }

  /// 跳转到 BaseList 示例页面
  static Future<T?>? toListDemo<T>() {
    return toPage<T>(BaseRoutes.baseListDemo);
  }

  /// 跳转到 BaseNetwork 示例页面
  static Future<T?>? toNetworkDemo<T>() {
    return toPage<T>(BaseRoutes.baseNetworkDemo);
  }

  /// 跳转到 BaseRefresh 示例页面
  static Future<T?>? toRefreshDemo<T>() {
    return toPage<T>(BaseRoutes.baseRefreshDemo);
  }

  /// 跳转到 BaseTab 示例页面
  static Future<T?>? toTabDemo<T>() {
    return toPage<T>(BaseRoutes.baseTabDemo);
  }

  /// 跳转到 BaseDialog 示例页面
  static Future<T?>? toDialogDemo<T>() {
    return toPage<T>(BaseRoutes.baseDialogDemo);
  }
}