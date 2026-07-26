import '../../core/util/route/route_util.dart';
import 'demo_params.dart';
import 'demo_result.dart';
import 'demo_routes.dart';

/// Demo 模块导航器
///
/// 提供所有 Demo 示例页的静态跳转方法。
abstract final class DemoNavigator {
  /// 跳转到网络请求示例页面
  static Future<T?>? toNetworkDemo<T>() {
    return toPage<T>(DemoRoutes.networkDemo);
  }

  /// 跳转到网络列表示例页面
  static Future<T?>? toNetworkListDemo<T>() {
    return toPage<T>(DemoRoutes.networkListDemo);
  }

  /// 跳转到数据库示例页面
  static Future<T?>? toDatabaseDemo<T>() {
    return toPage<T>(DemoRoutes.databaseDemo);
  }

  /// 跳转到本地存储示例页面
  static Future<T?>? toLocalStorageDemo<T>() {
    return toPage<T>(DemoRoutes.localStorageDemo);
  }

  /// 跳转到状态管理示例页面
  static Future<T?>? toStateManagementDemo<T>() {
    return toPage<T>(DemoRoutes.stateManagementDemo);
  }

  /// 跳转到网络请求（独立）示例页面
  static Future<T?>? toNetworkRequestDemo<T>() {
    return toPage<T>(DemoRoutes.networkRequestDemo);
  }

  /// 跳转到屏幕适配示例页面
  static Future<T?>? toScreenAdaptDemo<T>() {
    return toPage<T>(DemoRoutes.screenAdaptDemo);
  }

  /// 跳转到带参导航示例页面
  static Future<T?>? toNavigationWithArgs<T>(int goodsId) {
    return toPage<T>(
      DemoRoutes.navigationWithArgs,
      arguments: DemoParams(goodsId: goodsId),
    );
  }

  /// 跳转到返回结果导航示例页面
  static Future<DemoResult?>? toNavigationResult() {
    return toPage<DemoResult>(DemoRoutes.navigationResult);
  }

  /// 跳转到 Base 示例页面
  static Future<T?>? toBaseDemo<T>() {
    return toPage<T>(DemoRoutes.baseDemo);
  }

  /// 跳转到 BaseRefresh 示例页面
  static Future<T?>? toBaseRefreshDemo<T>() {
    return toPage<T>(DemoRoutes.baseRefreshDemo);
  }

  /// 跳转到 BaseTab 示例页面
  static Future<T?>? toBaseTabDemo<T>() {
    return toPage<T>(DemoRoutes.baseTabDemo);
  }

  /// 跳转到主题示例页面
  static Future<T?>? toThemeDemo<T>() {
    return toPage<T>(DemoRoutes.themeDemo);
  }
}
