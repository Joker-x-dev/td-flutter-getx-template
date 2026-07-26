import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:flutter_kit/application.dart';
import 'package:flutter_kit/core/data/repository/goods_repository.dart';
import 'package:flutter_kit/core/design_system/theme/theme_color_preset.dart';
import 'package:flutter_kit/core/model/entity/goods/goods.dart';
import 'package:flutter_kit/core/model/response/base/base_response.dart';
import 'package:flutter_kit/feature/demo/logics/network_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/network_list_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/network_request_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/screen_adapt_demo_logic.dart';
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

import '../../support/demo_feature_fakes.dart';
import '../../support/test_environment.dart';

/// Demo Feature 网络、主题、响应式与 Preview 页面测试。
void main() {
  setUp(() async {
    await initializeCoreTestEnvironment();
    _resetApplicationState();
  });
  tearDown(() async {
    _resetApplicationState();
    await resetCoreTestEnvironment();
  });

  testWidgets('网络详情页面成功时展示完整商品摘要', (tester) async {
    final logic = NetworkDemoLogic();
    logic.networkDemoState.goods.value = const Goods(
      id: 1,
      title: '网络商品',
      subTitle: '网络副标题',
      price: 29,
      sold: 4,
    );
    logic.setStatusSuccess();

    await tester.pumpWidget(
      buildCoreTestApp(home: NetworkDemoView(logic: logic)),
    );

    expect(find.text('网络商品'), findsOneWidget);
    expect(find.text('网络副标题'), findsOneWidget);
    expect(find.text('¥29.00'), findsOneWidget);
    expect(find.text('已售 4 件'), findsOneWidget);
  });

  testWidgets('网络列表页面按顺序展示商品卡片', (tester) async {
    final logic = NetworkListDemoLogic();
    logic.listState.dataList.assignAll(const <Goods>[
      Goods(id: 1, title: '列表商品一', price: 10),
      Goods(id: 2, title: '列表商品二', price: 20),
    ]);
    logic.setStatusSuccess();

    await tester.pumpWidget(
      buildCoreTestApp(home: NetworkListDemoView(logic: logic)),
    );

    expect(find.text('列表商品一'), findsOneWidget);
    expect(find.text('列表商品二'), findsOneWidget);
    expect(find.text('¥10.00'), findsOneWidget);
    expect(find.text('¥20.00'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('独立网络页面展示初始、加载、错误和成功状态', (tester) async {
    final logic = NetworkRequestDemoLogic();
    await tester.pumpWidget(
      buildCoreTestApp(home: NetworkRequestDemoView(logic: logic)),
    );

    expect(find.text('请求结果'), findsOneWidget);

    logic.isLoading.value = true;
    await tester.pump();
    expect(find.text('发起请求...'), findsOneWidget);
    expect(tester.widget<TDButton>(find.byType(TDButton)).disabled, isTrue);

    logic.isLoading.value = false;
    logic.errorMessage.value = '页面请求失败';
    await tester.pump();
    expect(find.text('页面请求失败'), findsOneWidget);

    logic.errorMessage.value = null;
    logic.goods.value = const Goods(
      id: 9,
      title: '手动请求商品',
      subTitle: '请求副标题',
      price: 66,
      sold: 5,
    );
    await tester.pump();
    expect(find.text('手动请求商品'), findsOneWidget);
    expect(find.text('请求副标题'), findsOneWidget);
    expect(find.text('¥66.00'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('独立网络页面按钮触发请求并刷新商品', (tester) async {
    final dataSource = DemoFeatureGoodsDataSource(
      detailHandler: (_) async =>
          BaseResponse<Goods>(data: const Goods(id: 12, title: '按钮请求商品')),
    );
    final logic = NetworkRequestDemoLogic(
      goodsRepository: GoodsRepository(dataSource: dataSource),
    );
    await tester.pumpWidget(
      buildCoreTestApp(home: NetworkRequestDemoView(logic: logic)),
    );

    await tester.tap(find.text('发起请求'));
    await tester.pumpAndSettle();

    expect(dataSource.detailId, 1);
    expect(find.text('按钮请求商品'), findsOneWidget);
  });

  testWidgets('屏幕适配页面按 xs、md、lg 断点改变网格与示例尺寸', (tester) async {
    await _pumpAdaptivePage(tester, 300);
    await _expectAdaptiveLayout(tester, 'xs', <int>[2, 1], '示例尺寸：80 dp');

    await _pumpAdaptivePage(tester, 700);
    await _expectAdaptiveLayout(tester, 'md', <int>[3, 2], '示例尺寸：96 dp');

    await _pumpAdaptivePage(tester, 900);
    await _expectAdaptiveLayout(tester, 'lg', <int>[4, 2], '示例尺寸：120 dp');

    expect(tester.takeException(), isNull);
  });

  testWidgets('主题页面展示语言、有效模式和全部颜色预设', (tester) async {
    await tester.pumpWidget(
      buildCoreTestApp(home: ThemeDemoView(logic: ThemeDemoLogic())),
    );

    expect(find.text('语言设置'), findsOneWidget);
    expect(find.text('中文'), findsOneWidget);
    expect(find.text('深浅模式'), findsOneWidget);
    expect(find.text('浅色模式'), findsOneWidget);
    expect(find.text('深色模式'), findsOneWidget);
    expect(find.text('默认主题'), findsOneWidget);
    expect(find.text('绿色主题'), findsOneWidget);
    expect(find.text('红色主题'), findsOneWidget);
    expect(find.text('蓝色主题'), findsOneWidget);
    expect(find.byIcon(TDIcons.check), findsWidgets);
  });

  testWidgets('主题页面交互切换语言、跟随系统、模式和颜色', (tester) async {
    final logic = ThemeDemoLogic();
    await tester.pumpWidget(
      buildCoreTestApp(home: ThemeDemoView(logic: logic)),
    );

    await tester.tap(find.text('当前语言（点击切换）'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
    expect(Application.locale.value.languageCode, 'en');

    final themeSwitch = tester.widget<TDSwitch>(find.byType(TDSwitch));
    expect(themeSwitch.isOn, isTrue);
    expect(themeSwitch.onChanged?.call(false), isTrue);
    await tester.pumpAndSettle();
    expect(Application.themeMode.value, ThemeMode.light);

    await tester.tap(find.text('Light Mode'));
    await tester.pumpAndSettle();
    expect(Application.themeMode.value, ThemeMode.light);

    await tester.tap(find.text('Dark Mode'));
    await tester.pumpAndSettle();
    expect(Application.themeMode.value, ThemeMode.dark);

    final greenTheme = find.text('Green Theme');
    await tester.ensureVisible(greenTheme);
    await tester.pumpAndSettle();
    await tester.tap(greenTheme);
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
    expect(Application.themeColorName.value, 'green');
  });

  testWidgets('主题页面在系统深色模式标记深色选项', (tester) async {
    tester.view.platformDispatcher.platformBrightnessTestValue =
        Brightness.dark;
    addTearDown(
      tester.view.platformDispatcher.clearPlatformBrightnessTestValue,
    );
    Application.themeMode.value = ThemeMode.system;

    await tester.pumpWidget(
      buildCoreTestApp(
        home: ThemeDemoView(logic: ThemeDemoLogic()),
        brightness: Brightness.dark,
      ),
    );

    expect(find.text('深色模式'), findsOneWidget);
    expect(find.byIcon(TDIcons.check), findsWidgets);
  });

  testWidgets('所有 Demo 页面 Preview 返回注入状态的对应 View', (tester) async {
    expect(previewBaseDemoView(), isA<BaseDemoView>());
    expect(previewBaseRefreshDemoView(), isA<BaseRefreshDemoView>());
    final baseTabView = previewBaseTabDemoView() as BaseTabDemoView;
    expect(baseTabView, isA<BaseTabDemoView>());
    baseTabView.logic.onClose();
    expect(previewDatabaseDemoView(), isA<DatabaseDemoView>());
    expect(previewLocalStorageDemoView(), isA<LocalStorageDemoView>());
    expect(previewNavigationResultView(), isA<NavigationResultView>());
    expect(previewNavigationWithArgsView(), isA<NavigationWithArgsView>());
    expect(previewNetworkDemoView(), isA<NetworkDemoView>());
    expect(previewNetworkListDemoView(), isA<NetworkListDemoView>());
    expect(previewNetworkRequestDemoView(), isA<NetworkRequestDemoView>());
    expect(previewScreenAdaptDemoView(), isA<ScreenAdaptDemoView>());
    expect(previewStateManagementDemoView(), isA<StateManagementDemoView>());
    expect(previewThemeDemoView(), isA<ThemeDemoView>());
  });
}

/// 构建指定宽度的屏幕适配页面。
Future<void> _pumpAdaptivePage(WidgetTester tester, double width) async {
  tester.view.physicalSize = Size(width, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    buildCoreTestApp(home: ScreenAdaptDemoView(logic: ScreenAdaptDemoLogic())),
  );
  await tester.pump();
}

/// 验证屏幕适配页面当前断点布局。
Future<void> _expectAdaptiveLayout(
  WidgetTester tester,
  String breakpoint,
  List<int> columns,
  String sizeText,
) async {
  expect(find.text(breakpoint), findsOneWidget);
  final gridColumns = tester
      .widgetList<GridView>(find.byType(GridView))
      .map(
        (grid) =>
            (grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount)
                .crossAxisCount,
      )
      .toList();
  expect(gridColumns, containsAllInOrder(columns));
  await tester.scrollUntilVisible(
    find.text(sizeText),
    500,
    scrollable: find.byType(Scrollable).first,
  );
  expect(find.text(sizeText), findsOneWidget);
}

/// 重置应用级主题与语言状态。
void _resetApplicationState() {
  Application.locale.value = const Locale('zh', 'CN');
  Application.themeMode.value = ThemeMode.system;
  Application.themeColorName.value = ThemeColorPreset.defaultTheme.name;
  Application.themeData.value = TDThemeData.defaultData();
  Get.locale = const Locale('zh', 'CN');
}
