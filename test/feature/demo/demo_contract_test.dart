import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:flutter_kit/feature/demo/bindings/base_demo_binding.dart';
import 'package:flutter_kit/feature/demo/bindings/base_refresh_demo_binding.dart';
import 'package:flutter_kit/feature/demo/bindings/base_tab_demo_binding.dart';
import 'package:flutter_kit/feature/demo/bindings/database_demo_binding.dart';
import 'package:flutter_kit/feature/demo/bindings/local_storage_demo_binding.dart';
import 'package:flutter_kit/feature/demo/bindings/navigation_result_binding.dart';
import 'package:flutter_kit/feature/demo/bindings/navigation_with_args_binding.dart';
import 'package:flutter_kit/feature/demo/bindings/network_demo_binding.dart';
import 'package:flutter_kit/feature/demo/bindings/network_list_demo_binding.dart';
import 'package:flutter_kit/feature/demo/bindings/network_request_demo_binding.dart';
import 'package:flutter_kit/feature/demo/bindings/screen_adapt_demo_binding.dart';
import 'package:flutter_kit/feature/demo/bindings/state_management_demo_binding.dart';
import 'package:flutter_kit/feature/demo/bindings/theme_demo_binding.dart';
import 'package:flutter_kit/feature/demo/localization/demo_en.dart';
import 'package:flutter_kit/feature/demo/localization/demo_zh.dart';
import 'package:flutter_kit/feature/demo/logics/base_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/base_refresh_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/base_tab_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/database_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/local_storage_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/navigation_result_logic.dart';
import 'package:flutter_kit/feature/demo/logics/navigation_with_args_logic.dart';
import 'package:flutter_kit/feature/demo/logics/network_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/network_list_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/network_request_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/screen_adapt_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/state_management_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/theme_demo_logic.dart';
import 'package:flutter_kit/feature/demo/views/base_demo_view.dart';
import 'package:flutter_kit/feature/demo/views/base_refresh_demo_view.dart';
import 'package:flutter_kit/feature/demo/views/base_tab_demo_view.dart';
import 'package:flutter_kit/feature/demo/views/database_demo_view.dart';
import 'package:flutter_kit/feature/demo/views/local_storage_demo_view.dart';
import 'package:flutter_kit/feature/demo/views/navigation_result_view.dart';
import 'package:flutter_kit/feature/demo/views/navigation_with_args_view.dart';
import 'package:flutter_kit/feature/demo/views/network_demo_view.dart';
import 'package:flutter_kit/feature/demo/views/network_list_demo_view.dart';
import 'package:flutter_kit/feature/demo/views/network_request_demo_view.dart';
import 'package:flutter_kit/feature/demo/views/screen_adapt_demo_view.dart';
import 'package:flutter_kit/feature/demo/views/state_management_demo_view.dart';
import 'package:flutter_kit/feature/demo/views/theme_demo_view.dart';
import 'package:flutter_kit/routes/demo/demo_navigator.dart';
import 'package:flutter_kit/routes/demo/demo_pages.dart';
import 'package:flutter_kit/routes/demo/demo_params.dart';
import 'package:flutter_kit/routes/demo/demo_result.dart';
import 'package:flutter_kit/routes/demo/demo_routes.dart';

import '../../support/test_environment.dart';

/// Demo Feature Binding、国际化、页面映射与导航契约测试。
void main() {
  setUp(initializeCoreTestEnvironment);
  tearDown(resetCoreTestEnvironment);

  test('所有 Binding 懒注册对应 Logic', () {
    final bindings = <Bindings>[
      BaseDemoBinding(),
      BaseRefreshDemoBinding(),
      BaseTabDemoBinding(),
      DatabaseDemoBinding(),
      LocalStorageDemoBinding(),
      NavigationResultBinding(),
      NavigationWithArgsBinding(),
      NetworkDemoBinding(),
      NetworkListDemoBinding(),
      NetworkRequestDemoBinding(),
      ScreenAdaptDemoBinding(),
      StateManagementDemoBinding(),
      ThemeDemoBinding(),
    ];

    for (final binding in bindings) {
      binding.dependencies();
    }

    expect(Get.isRegistered<BaseDemoLogic>(), isTrue);
    expect(Get.isRegistered<BaseRefreshDemoLogic>(), isTrue);
    expect(Get.isRegistered<BaseTabDemoLogic>(), isTrue);
    expect(Get.isRegistered<DatabaseDemoLogic>(), isTrue);
    expect(Get.isRegistered<LocalStorageDemoLogic>(), isTrue);
    expect(Get.isRegistered<NavigationResultLogic>(), isTrue);
    expect(Get.isRegistered<NavigationWithArgsLogic>(), isTrue);
    expect(Get.isRegistered<NetworkDemoLogic>(), isTrue);
    expect(Get.isRegistered<NetworkListDemoLogic>(), isTrue);
    expect(Get.isRegistered<NetworkRequestDemoLogic>(), isTrue);
    expect(Get.isRegistered<ScreenAdaptDemoLogic>(), isTrue);
    expect(Get.isRegistered<StateManagementDemoLogic>(), isTrue);
    expect(Get.isRegistered<ThemeDemoLogic>(), isTrue);

    expect(Get.find<BaseDemoLogic>(), isA<BaseDemoLogic>());
    final baseRefreshLogic = Get.find<BaseRefreshDemoLogic>();
    baseRefreshLogic.setStatusSuccess();
    expect(baseRefreshLogic, isA<BaseRefreshDemoLogic>());
    expect(Get.find<BaseTabDemoLogic>(), isA<BaseTabDemoLogic>());
    expect(Get.find<LocalStorageDemoLogic>(), isA<LocalStorageDemoLogic>());
    expect(Get.find<NavigationResultLogic>(), isA<NavigationResultLogic>());
    expect(Get.find<NavigationWithArgsLogic>(), isA<NavigationWithArgsLogic>());
    final networkLogic = Get.find<NetworkDemoLogic>();
    networkLogic.setStatusSuccess();
    expect(networkLogic, isA<NetworkDemoLogic>());
    final networkListLogic = Get.find<NetworkListDemoLogic>();
    networkListLogic.setStatusSuccess();
    expect(networkListLogic, isA<NetworkListDemoLogic>());
    expect(Get.find<NetworkRequestDemoLogic>(), isA<NetworkRequestDemoLogic>());
    expect(Get.find<ScreenAdaptDemoLogic>(), isA<ScreenAdaptDemoLogic>());
    expect(
      Get.find<StateManagementDemoLogic>(),
      isA<StateManagementDemoLogic>(),
    );
    expect(Get.find<ThemeDemoLogic>(), isA<ThemeDemoLogic>());
  });

  test('中英文文案键和占位符完全一致', () {
    expect(demoZh.keys.toSet(), demoEn.keys.toSet());
    expect(demoZh, isNotEmpty);

    for (final key in demoZh.keys) {
      expect(
        _placeholders(demoZh[key]!),
        _placeholders(demoEn[key]!),
        reason: '$key 的中英文占位符必须一致',
      );
    }
  });

  test('DemoPages 路由与 View、Binding 一一对应', () {
    final expected = <String, (Type, Type)>{
      DemoRoutes.networkDemo: (NetworkDemoView, NetworkDemoBinding),
      DemoRoutes.networkListDemo: (NetworkListDemoView, NetworkListDemoBinding),
      DemoRoutes.databaseDemo: (DatabaseDemoView, DatabaseDemoBinding),
      DemoRoutes.localStorageDemo: (
        LocalStorageDemoView,
        LocalStorageDemoBinding,
      ),
      DemoRoutes.stateManagementDemo: (
        StateManagementDemoView,
        StateManagementDemoBinding,
      ),
      DemoRoutes.networkRequestDemo: (
        NetworkRequestDemoView,
        NetworkRequestDemoBinding,
      ),
      DemoRoutes.screenAdaptDemo: (ScreenAdaptDemoView, ScreenAdaptDemoBinding),
      DemoRoutes.navigationWithArgs: (
        NavigationWithArgsView,
        NavigationWithArgsBinding,
      ),
      DemoRoutes.navigationResult: (
        NavigationResultView,
        NavigationResultBinding,
      ),
      DemoRoutes.baseDemo: (BaseDemoView, BaseDemoBinding),
      DemoRoutes.baseRefreshDemo: (BaseRefreshDemoView, BaseRefreshDemoBinding),
      DemoRoutes.baseTabDemo: (BaseTabDemoView, BaseTabDemoBinding),
      DemoRoutes.themeDemo: (ThemeDemoView, ThemeDemoBinding),
    };

    expect(DemoPages.routes, hasLength(expected.length));
    for (final route in DemoPages.routes) {
      final contract = expected[route.name];
      expect(contract, isNotNull, reason: '${route.name} 必须声明契约');
      expect(route.page().runtimeType, contract!.$1);
      expect(route.binding.runtimeType, contract.$2);
    }
  });

  testWidgets('所有无参 Navigator 进入声明的 Demo 路由', (tester) async {
    await tester.pumpWidget(
      buildCoreTestApp(
        home: const Scaffold(body: Text('Demo 首页')),
        routes: _localDemoRoutes,
      ),
    );

    final navigators = <(String, Future<void>? Function())>[
      (DemoRoutes.networkDemo, DemoNavigator.toNetworkDemo<void>),
      (DemoRoutes.networkListDemo, DemoNavigator.toNetworkListDemo<void>),
      (DemoRoutes.databaseDemo, DemoNavigator.toDatabaseDemo<void>),
      (DemoRoutes.localStorageDemo, DemoNavigator.toLocalStorageDemo<void>),
      (
        DemoRoutes.stateManagementDemo,
        DemoNavigator.toStateManagementDemo<void>,
      ),
      (DemoRoutes.networkRequestDemo, DemoNavigator.toNetworkRequestDemo<void>),
      (DemoRoutes.screenAdaptDemo, DemoNavigator.toScreenAdaptDemo<void>),
      (DemoRoutes.baseDemo, DemoNavigator.toBaseDemo<void>),
      (DemoRoutes.baseRefreshDemo, DemoNavigator.toBaseRefreshDemo<void>),
      (DemoRoutes.baseTabDemo, DemoNavigator.toBaseTabDemo<void>),
      (DemoRoutes.themeDemo, DemoNavigator.toThemeDemo<void>),
    ];

    for (final (routeName, navigate) in navigators) {
      final navigationFuture = navigate();
      await tester.pumpAndSettle();
      expect(Get.currentRoute, routeName);
      Get.back<void>();
      await tester.pumpAndSettle();
      await navigationFuture;
    }
  });

  testWidgets('带参 Navigator 传递类型安全参数', (tester) async {
    await tester.pumpWidget(
      buildCoreTestApp(
        home: const Scaffold(body: Text('Demo 首页')),
        routes: _localDemoRoutes,
      ),
    );

    unawaited(DemoNavigator.toNavigationWithArgs<void>(123));
    await tester.pumpAndSettle();

    expect(Get.currentRoute, DemoRoutes.navigationWithArgs);
    expect(Get.arguments, isA<DemoParams>());
    expect((Get.arguments as DemoParams).goodsId, 123);
    final logic = NavigationWithArgsLogic()..onInit();
    expect(logic.params.goodsId, 123);
  });

  testWidgets('结果 Navigator 返回类型安全结果', (tester) async {
    await tester.pumpWidget(
      buildCoreTestApp(
        home: const Scaffold(body: Text('Demo 首页')),
        routes: _localDemoRoutes,
      ),
    );

    final resultFuture = DemoNavigator.toNavigationResult()!;
    await tester.pumpAndSettle();
    expect(Get.currentRoute, DemoRoutes.navigationResult);

    Get.back<DemoResult>(result: const DemoResult(id: 7, message: '完成'));
    await tester.pumpAndSettle();

    final result = await resultFuture;
    expect(result?.id, 7);
    expect(result?.message, '完成');
  });
}

/// 提取文案中的 GetX 占位符。
Set<String> _placeholders(String text) {
  return RegExp(
    r'@[A-Za-z0-9_]+',
  ).allMatches(text).map((match) => match.group(0)!).toSet();
}

/// Demo Navigator 测试使用的本地路由表。
final List<GetPage<dynamic>> _localDemoRoutes = _demoRouteNames
    .map(
      (routeName) => GetPage<dynamic>(
        name: routeName,
        page: () => Scaffold(body: Text(routeName)),
      ),
    )
    .toList(growable: false);

/// Demo 模块全部路由名称。
const List<String> _demoRouteNames = <String>[
  DemoRoutes.networkDemo,
  DemoRoutes.networkListDemo,
  DemoRoutes.databaseDemo,
  DemoRoutes.localStorageDemo,
  DemoRoutes.stateManagementDemo,
  DemoRoutes.networkRequestDemo,
  DemoRoutes.screenAdaptDemo,
  DemoRoutes.navigationWithArgs,
  DemoRoutes.navigationResult,
  DemoRoutes.baseDemo,
  DemoRoutes.baseRefreshDemo,
  DemoRoutes.baseTabDemo,
  DemoRoutes.themeDemo,
];
