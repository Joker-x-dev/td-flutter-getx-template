import 'package:get/get.dart';

import 'app_pages.dart';

/// 统一路由跳转管理
/// 使用 to[页面名]Page 的方式进行页面跳转
/// 可以添加参数验证和业务逻辑限制

/// 跳转到主页
Future<T?>? toMainPage<T>() {
  return Get.toNamed<T>(Routes.MAIN);
}
