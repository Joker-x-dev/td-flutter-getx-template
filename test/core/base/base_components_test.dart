import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/base/base_dialog/base_dialog.dart';
import 'package:flutter_kit/core/base/base_tab/base_tab_logic.dart';
import 'package:flutter_kit/core/base/base_tab/base_tab_state.dart';
import 'package:flutter_kit/core/base/base_tab/base_tab_view.dart';
import 'package:flutter_kit/core/ui/preview/app_preview.dart';

import '../../support/test_environment.dart';

/// BaseTabView、BaseTabState 与 BaseDialog 组件契约测试。
void main() {
  setUp(initializeCoreTestEnvironment);
  tearDown(resetCoreTestEnvironment);

  test('BaseTabState 默认启用 PageView 且处于非动画状态', () {
    final BaseTabState state = BaseTabState();

    expect(state.usePageView, isTrue);
    expect(state.tabController, isNull);
    expect(state.pageController, isNull);
    expect(state.isAnimating.value, isFalse);
  });

  testWidgets('BaseTabView 构建标签和对应 PageView 页面', (WidgetTester tester) async {
    final _TabViewLogic logic = _TabViewLogic()..onInit();
    await tester.pumpWidget(buildCoreTestApp(home: _TabView(logic: logic)));

    expect(find.text('标签一'), findsOneWidget);
    expect(find.text('标签二'), findsOneWidget);
    expect(find.text('页面一'), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('页面二'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    logic.onClose();
  });

  test('BaseTabView 默认页面列表为空', () {
    final _TabViewLogic logic = _TabViewLogic();
    final _EmptyTabView view = _EmptyTabView(logic: logic);

    expect(view.pageViewChildren(), isEmpty);
  });

  testWidgets('BaseDialog 构建标题、正文、底部和物理返回策略', (WidgetTester tester) async {
    _TestDialog.initCount = 0;
    _TestDialog.headCount = 0;
    _TestDialog.bodyCount = 0;
    _TestDialog.bottomCount = 0;
    final _TestDialog dialog = _TestDialog();
    await tester.pumpWidget(
      buildCoreTestApp(
        home: AppPreviewScope(child: Scaffold(body: dialog)),
      ),
    );
    await tester.pumpAndSettle();

    expect(_TestDialog.initCount, 1);
    expect(_TestDialog.headCount, 1);
    expect(_TestDialog.bodyCount, 1);
    expect(_TestDialog.bottomCount, 1);
    expect(find.text('测试弹窗'), findsOneWidget);
    expect(find.text('弹窗正文'), findsOneWidget);
    expect(find.text('弹窗底部'), findsOneWidget);
    expect(
      tester.widget<PopScope<dynamic>>(find.byType(PopScope)).canPop,
      isFalse,
    );
  });

  testWidgets('BaseDialog 默认配置通过底部弹窗展示并允许关闭', (WidgetTester tester) async {
    final _DefaultDialog dialog = _DefaultDialog();
    await tester.pumpWidget(
      buildCoreTestApp(
        home: Scaffold(
          body: TextButton(onPressed: dialog.show, child: const Text('打开弹窗')),
        ),
      ),
    );

    expect(dialog.isDismissible, isTrue);
    expect(dialog.enableDrag, isTrue);
    expect(dialog.enablePhysicalBack, isTrue);
    expect(dialog.bottom(tester.element(find.text('打开弹窗'))), isNull);

    await tester.tap(find.text('打开弹窗'));
    await tester.pumpAndSettle();
    expect(find.text('默认弹窗正文'), findsOneWidget);
    expect(
      tester.widget<PopScope<dynamic>>(find.byType(PopScope)).canPop,
      isTrue,
    );

    Navigator.of(tester.element(find.text('默认弹窗正文'))).pop();
    await tester.pumpAndSettle();
  });
}

/// Tab 页面测试 Logic。
class _TabViewLogic extends BaseTabLogic {
  /// 返回测试标签。
  @override
  List<String> get tabList => const <String>['标签一', '标签二'];
}

/// Tab 页面测试实现。
class _TabView extends BaseTabView<_TabViewLogic> {
  /// 创建 Tab 页面测试实现。
  _TabView({required super.logic});

  /// 测试页面不显示返回按钮。
  @override
  bool get navBackBtn => false;

  /// 返回 PageView 测试页面。
  @override
  List<Widget> pageViewChildren() => const <Widget>[
    Center(child: Text('页面一')),
    Center(child: Text('页面二')),
  ];
}

/// 使用默认空页面列表的 Tab 页面。
class _EmptyTabView extends BaseTabView<_TabViewLogic> {
  /// 创建空 Tab 页面测试实现。
  _EmptyTabView({required super.logic});
}

/// 底部弹窗测试实现。
class _TestDialog extends BaseDialog {
  /// 初始化调用次数。
  static int initCount = 0;

  /// 顶部区域构建次数。
  static int headCount = 0;

  /// 正文区域构建次数。
  static int bodyCount = 0;

  /// 底部区域构建次数。
  static int bottomCount = 0;

  /// 弹窗标题。
  @override
  String get title => '测试弹窗';

  /// 禁止物理返回。
  @override
  bool get enablePhysicalBack => false;

  /// 构建弹窗顶部区域。
  @override
  Widget? head() {
    headCount++;
    return super.head();
  }

  /// 记录弹窗初始化。
  @override
  void init() {
    initCount++;
  }

  /// 构建弹窗正文。
  @override
  List<Widget> body(BuildContext context) {
    bodyCount++;
    return const <Widget>[Text('弹窗正文')];
  }

  /// 构建弹窗底部。
  @override
  Widget bottom(BuildContext context) {
    bottomCount++;
    return const Text('弹窗底部');
  }
}

/// 使用全部默认配置的底部弹窗。
class _DefaultDialog extends BaseDialog {
  /// 构建默认弹窗正文。
  @override
  List<Widget> body(BuildContext context) => const <Widget>[Text('默认弹窗正文')];
}
