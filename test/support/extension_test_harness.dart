import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_environment.dart';

/// 链式扩展测试公共环境。

/// 构建包含主题、国际化和指定文字方向的扩展测试页面。
///
/// [tester] Widget 测试控制器。
/// [child] 被测链式扩展 Widget。
/// [textDirection] 页面文字方向。
/// [surfaceSize] 测试视口尺寸。
Future<void> pumpExtensionTestApp(
  WidgetTester tester,
  Widget child, {
  TextDirection textDirection = TextDirection.ltr,
  Size surfaceSize = const Size(800, 600),
}) async {
  tester.view.physicalSize = surfaceSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    buildCoreTestApp(
      home: Directionality(
        textDirection: textDirection,
        child: Scaffold(body: Center(child: child)),
      ),
    ),
  );
}

/// 获取 Finder 对应的首个 Widget。
///
/// [tester] Widget 测试控制器。
/// [finder] Widget 查找器。
T firstWidget<T extends Widget>(WidgetTester tester, Finder finder) {
  return tester.widget<T>(finder.first);
}

/// 获取 Finder 对应 RenderBox 的实际尺寸。
///
/// [tester] Widget 测试控制器。
/// [finder] Widget 查找器。
Size renderSize(WidgetTester tester, Finder finder) {
  return tester.getSize(finder);
}

/// 释放页面并验证无残留异步异常。
///
/// [tester] Widget 测试控制器。
Future<void> disposeExtensionTestApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
  expect(tester.takeException(), isNull);
}
