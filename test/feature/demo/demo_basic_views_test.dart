import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:flutter_kit/core/data/repository/demo_repository.dart';
import 'package:flutter_kit/core/data/repository/goods_repository.dart';
import 'package:flutter_kit/core/data/repository/user_info_store_repository.dart';
import 'package:flutter_kit/core/model/entity/goods/goods.dart';
import 'package:flutter_kit/core/model/response/base/base_response.dart';
import 'package:flutter_kit/core/service/demo_counter_service.dart';
import 'package:flutter_kit/feature/demo/logics/base_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/base_refresh_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/base_tab_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/database_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/local_storage_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/navigation_result_logic.dart';
import 'package:flutter_kit/feature/demo/logics/navigation_with_args_logic.dart';
import 'package:flutter_kit/feature/demo/logics/state_management_demo_logic.dart';
import 'package:flutter_kit/feature/demo/views/base_demo_view.dart';
import 'package:flutter_kit/feature/demo/views/base_refresh_demo_view.dart';
import 'package:flutter_kit/feature/demo/views/base_tab_demo_view.dart';
import 'package:flutter_kit/feature/demo/views/database_demo_view.dart';
import 'package:flutter_kit/feature/demo/views/local_storage_demo_view.dart';
import 'package:flutter_kit/feature/demo/views/navigation_result_view.dart';
import 'package:flutter_kit/feature/demo/views/navigation_with_args_view.dart';
import 'package:flutter_kit/feature/demo/views/state_management_demo_view.dart';
import 'package:flutter_kit/routes/demo/demo_params.dart';
import 'package:flutter_kit/routes/demo/demo_result.dart';

import '../../support/demo_feature_fakes.dart';
import '../../support/test_environment.dart';

/// Demo Feature 基础、存储、导航与状态页面测试。
void main() {
  setUp(initializeCoreTestEnvironment);
  tearDown(resetCoreTestEnvironment);

  testWidgets('Base 页面展示导航、下拉菜单、悬浮按钮和底部入口', (tester) async {
    final view = BaseDemoView(logic: BaseDemoLogic());
    await tester.pumpWidget(buildCoreTestApp(home: view));

    expect(find.text('基础页面示例'), findsOneWidget);
    expect(find.text('全部产品'), findsOneWidget);
    expect(find.text('页面主视图内容\n对 Scaffold 做了封装，减少样板代码'), findsOneWidget);
    expect(find.text('悬浮按钮'), findsOneWidget);
    expect(find.byType(TDDropdownMenu), findsOneWidget);
    expect(find.byType(TDBottomTabBar), findsOneWidget);
    expect(find.text('消息'), findsOneWidget);
    expect(find.text('我的'), findsOneWidget);

    final tabBar = tester.widget<TDBottomTabBar>(find.byType(TDBottomTabBar));
    expect(tabBar.navigationTabs, hasLength(5));
    for (final tab in tabBar.navigationTabs) {
      expect(tab.onTap, returnsNormally);
    }
  });

  testWidgets('BaseTab 页面展示三个标签和页面内容', (tester) async {
    final logic = BaseTabDemoLogic()..onInit();
    addTearDown(logic.onClose);

    await tester.pumpWidget(
      buildCoreTestApp(home: BaseTabDemoView(logic: logic)),
    );
    await tester.pump();

    expect(find.text('标签页 1'), findsOneWidget);
    expect(find.text('标签页 2'), findsOneWidget);
    expect(find.text('标签页 3'), findsOneWidget);
    expect(find.text('页面 1'), findsOneWidget);
    expect(find.byType(PageView), findsOneWidget);
  });

  testWidgets('BaseRefresh 页面成功时展示商品详情', (tester) async {
    final dataSource = DemoFeatureGoodsDataSource(
      detailHandler: (_) async => BaseResponse<Goods>(
        data: const Goods(id: 3, title: '刷新商品', price: 12),
      ),
    );
    final logic = BaseRefreshDemoLogic(
      goodsRepository: GoodsRepository(dataSource: dataSource),
    );
    logic.baseRefreshDemoState.goods.value = const Goods(
      id: 3,
      title: '刷新商品',
      price: 12,
    );
    logic.setStatusSuccess();

    await tester.pumpWidget(
      buildCoreTestApp(home: BaseRefreshDemoView(logic: logic)),
    );

    expect(find.text('下拉刷新示例'), findsOneWidget);
    expect(find.text('刷新商品'), findsOneWidget);
    expect(find.text('¥12.00'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('数据库页面支持空状态、新增、删除和清空', (tester) async {
    final dataSource = DemoFeatureLocalDataSource();
    final logic = DatabaseDemoLogic(
      demoRepository: DemoRepository(dataSource: dataSource),
    );
    await tester.pumpWidget(
      buildCoreTestApp(home: DatabaseDemoView(logic: logic)),
    );

    expect(find.text('暂无记录'), findsOneWidget);
    await tester.tap(find.text('新增记录'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('新增记录'));
    await tester.pumpAndSettle();
    expect(find.text('示例记录 1'), findsOneWidget);
    expect(find.text('示例记录 2'), findsOneWidget);

    await tester.tap(find.text('删除').first);
    await tester.pumpAndSettle();
    expect(find.text('示例记录 1'), findsNothing);

    await tester.tap(find.text('清空全部'));
    await tester.pumpAndSettle();
    expect(find.text('暂无记录'), findsOneWidget);
  });

  testWidgets('本地存储页面在宽屏支持保存、读取和清除用户', (tester) async {
    tester.view.physicalSize = const Size(600, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final dataSource = DemoFeatureUserStoreDataSource();
    final logic = LocalStorageDemoLogic(
      userInfoStoreRepository: UserInfoStoreRepository(dataSource: dataSource),
    );

    await tester.pumpWidget(
      buildCoreTestApp(home: LocalStorageDemoView(logic: logic)),
    );
    expect(find.text('未读取到用户信息'), findsOneWidget);

    await tester.tap(find.text('保存用户信息'));
    await tester.pumpAndSettle();
    expect(find.text('10086'), findsOneWidget);
    expect(find.text('演示用户'), findsOneWidget);
    expect(find.text('18800000000'), findsOneWidget);

    logic.user.value = null;
    await tester.pump();
    await tester.tap(find.text('读取用户信息'));
    await tester.pumpAndSettle();
    expect(find.text('演示用户'), findsOneWidget);

    await tester.tap(find.text('清除用户信息'));
    await tester.pumpAndSettle();
    expect(find.text('未读取到用户信息'), findsOneWidget);
  });

  testWidgets('本地存储页面在窄屏自动换行且无溢出', (tester) async {
    tester.view.physicalSize = const Size(360, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      buildCoreTestApp(
        home: LocalStorageDemoView(
          logic: LocalStorageDemoLogic(
            userInfoStoreRepository: UserInfoStoreRepository(
              dataSource: DemoFeatureUserStoreDataSource(),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(Wrap), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('带参页面展示注入的商品 ID', (tester) async {
    final logic = NavigationWithArgsLogic(
      initialParams: const DemoParams(goodsId: 9527),
    )..onInit();
    await tester.pumpWidget(
      buildCoreTestApp(home: NavigationWithArgsView(logic: logic)),
    );

    expect(find.text('接收到的商品ID:'), findsOneWidget);
    expect(find.text('9527'), findsOneWidget);
  });

  testWidgets('结果页面按钮向上一页返回 DemoResult', (tester) async {
    await tester.pumpWidget(
      buildCoreTestApp(home: const _NavigationResultHome()),
    );

    await tester.tap(find.text('打开结果页'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('返回结果'));
    await tester.pumpAndSettle();

    expect(find.text('结果:9527-回传结果'), findsOneWidget);
  });

  testWidgets('状态管理页面响应增加、减少和重置操作', (tester) async {
    final service = DemoCounterService();
    final logic = StateManagementDemoLogic(counterService: service);
    await tester.pumpWidget(
      buildCoreTestApp(home: StateManagementDemoView(logic: logic)),
    );

    expect(find.text('0'), findsOneWidget);
    await tester.tap(find.text('加 1'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('1'), findsOneWidget);
    await tester.tap(find.text('减 1'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('0'), findsOneWidget);
    await tester.tap(find.text('重置'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(service.count.value, 0);
  });
}

/// 结果回传测试首页。
class _NavigationResultHome extends StatefulWidget {
  /// 创建结果回传测试首页。
  const _NavigationResultHome();

  /// 创建页面状态。
  @override
  State<_NavigationResultHome> createState() => _NavigationResultHomeState();
}

/// 结果回传测试首页状态。
class _NavigationResultHomeState extends State<_NavigationResultHome> {
  /// 最近一次页面结果。
  DemoResult? result;

  /// 打开结果页面并保存结果。
  Future<void> _openResult() async {
    result = await Get.to<DemoResult>(
      () => NavigationResultView(logic: NavigationResultLogic()),
    );
    setState(() {});
  }

  /// 构建结果回传测试首页。
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextButton(onPressed: _openResult, child: const Text('打开结果页')),
          Text('结果:${result?.id ?? ''}-${result?.message ?? ''}'),
        ],
      ),
    );
  }
}
