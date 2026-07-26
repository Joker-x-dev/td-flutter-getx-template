import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/base/base_tab/base_tab_logic.dart';

/// BaseTabLogic 控制器创建、同步与释放测试。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('空 Tab 不创建控制器', (WidgetTester tester) async {
    final _TabLogic logic = _TabLogic(const <String>[]);

    logic.onInit();

    expect(logic.tabState.tabController, isNull);
    expect(logic.tabState.pageController, isNull);
    logic.onClose();
  });

  testWidgets('关闭 PageView 时只创建 TabController', (WidgetTester tester) async {
    final _TabLogic logic = _TabLogic(const <String>['一', '二']);
    logic.tabState.usePageView = false;

    logic.onInit();

    expect(logic.tabState.tabController, isNotNull);
    expect(logic.tabState.pageController, isNull);
    logic.onClose();
  });

  testWidgets('点击 Tab 同步索引并启动 PageView 动画', (WidgetTester tester) async {
    final _TabLogic logic = _TabLogic(const <String>['一', '二', '三']);
    logic.onInit();
    await tester.pumpWidget(
      MaterialApp(
        home: PageView(
          controller: logic.tabState.pageController,
          children: const <Widget>[SizedBox(), SizedBox(), SizedBox()],
        ),
      ),
    );

    logic.tabChange(2);
    await tester.pumpAndSettle();

    expect(logic.tabState.tabController?.index, 2);
    expect(logic.tabState.isAnimating.value, isTrue);
    expect(logic.tabState.pageController?.page, 2);
    logic.pageViewChange(2);
    expect(logic.tabState.isAnimating.value, isFalse);
    logic.onClose();
  });

  testWidgets('手动滑动 PageView 直接同步 Tab 索引', (WidgetTester tester) async {
    final _TabLogic logic = _TabLogic(const <String>['一', '二']);
    logic.onInit();

    logic.pageViewChange(1);

    expect(logic.tabState.tabController?.index, 1);
    expect(logic.tabState.isAnimating.value, isFalse);
    logic.onClose();
  });

  testWidgets('onClose 同时释放 TabController 与 PageController', (
    WidgetTester tester,
  ) async {
    final _TabLogic logic = _TabLogic(const <String>['一', '二']);
    logic.onInit();
    logic.onClose();

    expect(logic.tabState.tabController, isNull);
    expect(logic.tabState.pageController, isNull);
  });
}

/// Tab 状态机测试 Logic。
class _TabLogic extends BaseTabLogic {
  /// 创建 Tab 状态机测试 Logic。
  _TabLogic(this.tabs);

  /// Tab 标题。
  final List<String> tabs;

  /// 返回 Tab 标题。
  @override
  List<String> get tabList => tabs;
}
