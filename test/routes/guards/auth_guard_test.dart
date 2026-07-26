import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:flutter_kit/core/service/user_service.dart';
import 'package:flutter_kit/routes/auth/auth_routes.dart';
import 'package:flutter_kit/routes/guards/auth_guard.dart';
import 'package:flutter_kit/routes/user/user_pages.dart';
import 'package:flutter_kit/routes/user/user_routes.dart';

import '../../support/test_environment.dart';

/// 登录态路由守卫和受保护路由配置测试。
void main() {
  late UserService userService;

  setUp(() async {
    await initializeCoreTestEnvironment();
    userService = UserService();
    Get.put<UserService>(userService);
  });

  tearDown(resetCoreTestEnvironment);

  test('未登录访问受保护路由时重定向登录页', () {
    final RouteSettings? result = AuthGuard().redirect(UserRoutes.userInfo);

    expect(result?.name, AuthRoutes.login);
  });

  test('已登录访问受保护路由时继续导航', () {
    userService.isLoggedIn.value = true;

    final RouteSettings? result = AuthGuard().redirect(UserRoutes.userInfo);

    expect(result, isNull);
  });

  test('用户信息路由声明认证守卫', () {
    final GetPage<dynamic> userInfoPage = UserPages.routes.singleWhere(
      (GetPage<dynamic> page) => page.name == UserRoutes.userInfo,
    );

    expect(userInfoPage.middlewares, contains(isA<AuthGuard>()));
  });
}
