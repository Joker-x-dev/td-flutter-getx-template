import 'package:get/get.dart';

import 'app_pages.dart';

/// 统一路由跳转管理
/// 使用 to[页面名]Page 的方式进行页面跳转
/// 可以添加参数验证和业务逻辑限制

/// 跳转到主页
Future<T?>? toMainPage<T>() {
  return Get.toNamed<T>(Routes.MAIN);
}

/// 跳转到 Base 示例页面
Future<T?>? toBaseDemoPage<T>() {
  return Get.toNamed<T>(Routes.BASE_DEMO);
}

/// 跳转到 BaseList 示例页面
Future<T?>? toBaseListDemoPage<T>() {
  return Get.toNamed<T>(Routes.BASE_LIST_DEMO);
}

/// 跳转到 BaseNetwork 示例页面
Future<T?>? toBaseNetworkDemoPage<T>() {
  return Get.toNamed<T>(Routes.BASE_NETWORK_DEMO);
}

/// 跳转到 BaseRefresh 示例页面
Future<T?>? toBaseRefreshDemoPage<T>() {
  return Get.toNamed<T>(Routes.BASE_REFRESH_DEMO);
}

/// 跳转到 BaseTab 示例页面
Future<T?>? toBaseTabDemoPage<T>() {
  return Get.toNamed<T>(Routes.BASE_TAB_DEMO);
}

/// 跳转到 BaseDialog 示例页面
Future<T?>? toBaseDialogDemoPage<T>() {
  return Get.toNamed<T>(Routes.BASE_DIALOG_DEMO);
}
