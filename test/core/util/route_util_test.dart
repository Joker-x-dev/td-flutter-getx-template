import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:flutter_kit/core/util/route/route_util.dart';

import '../../support/test_environment.dart';

/// RouteUtil 本地路由参数、结果与导航栈测试。
void main() {
  setUp(initializeCoreTestEnvironment);
  tearDown(resetCoreTestEnvironment);

  testWidgets('命名路由传递参数并返回类型安全结果', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildCoreTestApp(
        home: const _RouteHome(),
        routes: <GetPage<dynamic>>[
          GetPage<dynamic>(name: '/detail', page: () => const _RouteDetail()),
        ],
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    expect(getCurrentRoute(), '/detail');
    expect(isCurrentRoute('/detail'), isTrue);
    expect(getRawArguments(), <String, dynamic>{'id': 7});
    expect(getCurrentArguments(), <String, dynamic>{'id': 7});
    expect(getArgument<int>('id'), 7);
    expect(getTypedArguments<Map<String, dynamic>>()!['id'], 7);

    await tester.tap(find.text('返回'));
    await tester.pumpAndSettle();
    expect(find.text('结果:完成'), findsOneWidget);
  });

  testWidgets('错误的页面返回类型转换为 StateError', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildCoreTestApp(
        home: const _WrongResultHome(),
        routes: <GetPage<dynamic>>[
          GetPage<dynamic>(
            name: '/wrong',
            page: () => const _WrongResultPage(),
          ),
        ],
      ),
    );

    await tester.tap(find.text('错误结果'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('返回数字'));
    await tester.pumpAndSettle();

    expect(find.text('捕获类型错误'), findsOneWidget);
  });

  testWidgets('非 Map 参数仅能通过原始和类型化接口读取', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildCoreTestApp(
        home: const _RouteHome(),
        routes: <GetPage<dynamic>>[
          GetPage<dynamic>(name: '/detail', page: () => const _RouteDetail()),
        ],
      ),
    );
    unawaited(toPage<void>('/detail', arguments: 'value'));
    await tester.pumpAndSettle();

    expect(getRawArguments(), 'value');
    expect(getTypedArguments<String>(), 'value');
    expect(getTypedArguments<int>(), isNull);
    expect(getCurrentArguments(), isNull);
    expect(getArgument<int>('missing'), isNull);
  });

  testWidgets('栈底安全返回跳转到本地备用路由', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildCoreTestApp(
        home: const _RouteHome(),
        routes: <GetPage<dynamic>>[
          GetPage<dynamic>(
            name: '/fallback',
            page: () => const Scaffold(body: Text('备用页面')),
          ),
        ],
      ),
    );
    expect(canPop(), isFalse);

    safeBack(fallbackRoute: '/fallback');
    await tester.pumpAndSettle();

    expect(find.text('备用页面'), findsOneWidget);
    expect(isCurrentRoute('/fallback'), isTrue);
  });

  testWidgets('可返回时安全返回关闭当前页面', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildCoreTestApp(
        home: const _RouteHome(),
        routes: <GetPage<dynamic>>[
          GetPage<dynamic>(name: '/detail', page: () => const _RouteDetail()),
        ],
      ),
    );
    unawaited(toPage<void>('/detail'));
    await tester.pumpAndSettle();
    expect(canPop(), isTrue);

    safeBack();
    await tester.pumpAndSettle();

    expect(find.text('打开'), findsOneWidget);
  });

  testWidgets('返回指定路由会移除其后的页面', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildCoreTestApp(
        home: const _RouteHome(),
        routes: <GetPage<dynamic>>[
          GetPage<dynamic>(
            name: '/middle',
            page: () => const Scaffold(body: Text('中间页面')),
          ),
          GetPage<dynamic>(
            name: '/last',
            page: () => const Scaffold(body: Text('末级页面')),
          ),
        ],
      ),
    );
    unawaited(toPage<void>('/middle'));
    await tester.pumpAndSettle();
    unawaited(toPage<void>('/last'));
    await tester.pumpAndSettle();

    backTo('/middle');
    await tester.pumpAndSettle();

    expect(find.text('中间页面'), findsOneWidget);
    expect(find.text('末级页面'), findsNothing);
  });

  testWidgets('统一关闭当前对话框', (WidgetTester tester) async {
    await tester.pumpWidget(buildCoreTestApp(home: const _RouteHome()));
    unawaited(Get.dialog<void>(const AlertDialog(content: Text('待关闭对话框'))));
    await tester.pumpAndSettle();
    expect(find.text('待关闭对话框'), findsOneWidget);

    closeAllDialogsAndBottomSheets();
    await tester.pumpAndSettle();

    expect(find.text('待关闭对话框'), findsNothing);
  });

  testWidgets('统一关闭叠加的底部弹窗和对话框且保留页面栈', (WidgetTester tester) async {
    await tester.pumpWidget(buildCoreTestApp(home: const _RouteHome()));
    unawaited(
      Get.bottomSheet<void>(
        const Material(child: Text('待关闭底部弹窗')),
        isScrollControlled: true,
      ),
    );
    await tester.pumpAndSettle();
    unawaited(Get.dialog<void>(const AlertDialog(content: Text('待关闭对话框'))));
    await tester.pumpAndSettle();

    closeAllDialogsAndBottomSheets();
    await tester.pumpAndSettle();

    expect(find.text('待关闭对话框'), findsNothing);
    expect(find.text('待关闭底部弹窗'), findsNothing);
    expect(find.text('打开'), findsOneWidget);
    expect(canPop(), isFalse);
  });

  testWidgets('没有弹层时统一关闭操作不改变当前页面', (WidgetTester tester) async {
    await tester.pumpWidget(buildCoreTestApp(home: const _RouteHome()));

    closeAllDialogsAndBottomSheets();
    await tester.pumpAndSettle();

    expect(find.text('打开'), findsOneWidget);
    expect(canPop(), isFalse);
  });
}

/// 路由测试首页。
class _RouteHome extends StatefulWidget {
  /// 创建路由测试首页。
  const _RouteHome();

  /// 创建首页状态。
  @override
  State<_RouteHome> createState() => _RouteHomeState();
}

/// 路由测试首页状态。
class _RouteHomeState extends State<_RouteHome> {
  /// 页面返回结果。
  String? result;

  /// 打开详情页并保存返回结果。
  Future<void> _open() async {
    result = await toPage<String>(
      '/detail',
      arguments: <String, dynamic>{'id': 7},
    );
    setState(() {});
  }

  /// 构建测试首页。
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextButton(onPressed: _open, child: const Text('打开')),
          Text('结果:${result ?? ''}'),
        ],
      ),
    );
  }
}

/// 路由测试详情页。
class _RouteDetail extends StatelessWidget {
  /// 创建路由测试详情页。
  const _RouteDetail();

  /// 构建详情页。
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(
        onPressed: () => back<String>('完成'),
        child: const Text('返回'),
      ),
    );
  }
}

/// 错误结果测试首页。
class _WrongResultHome extends StatefulWidget {
  /// 创建错误结果测试首页。
  const _WrongResultHome();

  /// 创建首页状态。
  @override
  State<_WrongResultHome> createState() => _WrongResultHomeState();
}

/// 错误结果测试首页状态。
class _WrongResultHomeState extends State<_WrongResultHome> {
  /// 是否捕获类型错误。
  bool caught = false;

  /// 打开页面并捕获返回类型错误。
  Future<void> _open() async {
    try {
      await toPage<String>('/wrong');
    } on StateError {
      caught = true;
      setState(() {});
    }
  }

  /// 构建测试首页。
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextButton(onPressed: _open, child: const Text('错误结果')),
          if (caught) const Text('捕获类型错误'),
        ],
      ),
    );
  }
}

/// 返回错误类型的测试页。
class _WrongResultPage extends StatelessWidget {
  /// 创建错误类型测试页。
  const _WrongResultPage();

  /// 构建错误类型测试页。
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(
        onPressed: () => back<int>(1),
        child: const Text('返回数字'),
      ),
    );
  }
}
