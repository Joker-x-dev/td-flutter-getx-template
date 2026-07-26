import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:flutter_kit/application.dart';
import 'package:flutter_kit/core/base/base_network/base_network_state.dart';
import 'package:flutter_kit/core/data/repository/demo_repository.dart';
import 'package:flutter_kit/core/data/repository/goods_repository.dart';
import 'package:flutter_kit/core/data/repository/user_info_store_repository.dart';
import 'package:flutter_kit/core/model/entity/goods/goods.dart';
import 'package:flutter_kit/core/model/response/base/base_list_response.dart';
import 'package:flutter_kit/core/model/response/base/base_response.dart';
import 'package:flutter_kit/core/service/demo_counter_service.dart';
import 'package:flutter_kit/core/design_system/theme/theme_color_preset.dart';
import 'package:flutter_kit/feature/demo/logics/base_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/base_refresh_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/base_tab_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/database_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/local_storage_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/navigation_with_args_logic.dart';
import 'package:flutter_kit/feature/demo/logics/network_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/network_list_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/network_request_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/screen_adapt_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/state_management_demo_logic.dart';
import 'package:flutter_kit/feature/demo/logics/theme_demo_logic.dart';
import 'package:flutter_kit/routes/demo/demo_params.dart';

import '../../support/demo_feature_fakes.dart';
import '../../support/test_environment.dart';

/// Demo Feature Logic、State 与数据交互测试。
void main() {
  setUp(() async {
    await initializeCoreTestEnvironment();
    _resetApplicationState();
  });
  tearDown(() async {
    _resetApplicationState();
    await resetCoreTestEnvironment();
  });

  test('普通与屏幕适配 Logic 可独立创建', () {
    expect(BaseDemoLogic(), isA<BaseDemoLogic>());
    expect(ScreenAdaptDemoLogic(), isA<ScreenAdaptDemoLogic>());
  });

  test('BaseTab Logic 提供本地化标签并释放控制器', () {
    final logic = BaseTabDemoLogic()..onInit();

    expect(logic.tabList, <String>['标签页 1', '标签页 2', '标签页 3']);
    expect(logic.tabState.tabController?.length, 3);
    expect(logic.tabState.pageController, isNotNull);

    logic.onClose();
    expect(logic.tabState.tabController, isNull);
    expect(logic.tabState.pageController, isNull);
  });

  test('网络详情与刷新 Logic 保存商品并复用页面 State', () async {
    final dataSource = DemoFeatureGoodsDataSource();
    final repository = GoodsRepository(dataSource: dataSource);
    final networkLogic = NetworkDemoLogic(goodsRepository: repository);
    final refreshLogic = BaseRefreshDemoLogic(goodsRepository: repository);

    await networkLogic.loadData();
    await refreshLogic.loadData();

    expect(dataSource.detailId, 1);
    expect(networkLogic.networkState, same(networkLogic.networkDemoState));
    expect(networkLogic.networkDemoState.goods.value.title, '商品1');
    expect(networkLogic.networkDemoState.uiState.value, NetState.dataSuccess);
    expect(refreshLogic.refreshState, same(refreshLogic.baseRefreshDemoState));
    expect(refreshLogic.baseRefreshDemoState.goods.value.id, 1);
    expect(
      refreshLogic.baseRefreshDemoState.uiState.value,
      NetState.dataSuccess,
    );
  });

  test('网络列表 Logic 使用 15 条分页参数并保存结果', () async {
    final dataSource = DemoFeatureGoodsDataSource(
      pageHandler: (request) async => BaseResponse<BaseListResponse<Goods>>(
        data: BaseListResponse<Goods>(
          list: const <Goods>[Goods(id: 8, title: '列表商品')],
          pagination: PageMeta(
            total: 30,
            size: request.size,
            page: request.page,
          ),
        ),
      ),
    );
    final logic = NetworkListDemoLogic(
      goodsRepository: GoodsRepository(dataSource: dataSource),
    )..onInit();

    await logic.loadData();

    expect(logic.networkState, same(logic.networkListDemoState));
    expect(dataSource.pageRequest?.page, 1);
    expect(dataSource.pageRequest?.size, 15);
    expect(logic.listState.pageSize, 15);
    expect(logic.listState.dataList.single.title, '列表商品');
    expect(logic.listState.noMoreData, isFalse);
  });

  test('独立网络请求在等待期间禁用操作并保存成功结果', () async {
    final completer = Completer<BaseResponse<Goods>>();
    final dataSource = DemoFeatureGoodsDataSource(
      detailHandler: (_) => completer.future,
    );
    final logic = NetworkRequestDemoLogic(
      goodsRepository: GoodsRepository(dataSource: dataSource),
    );

    final requestFuture = logic.request();
    expect(logic.isLoading.value, isTrue);
    expect(logic.goods.value, isNull);
    expect(logic.errorMessage.value, isNull);

    completer.complete(
      BaseResponse<Goods>(data: const Goods(id: 7, title: '请求商品')),
    );
    await requestFuture;

    expect(dataSource.detailId, 1);
    expect(logic.isLoading.value, isFalse);
    expect(logic.goods.value?.id, 7);
    expect(logic.errorMessage.value, isNull);
  });

  test('独立网络请求业务失败保存错误且不向页面传播异常', () async {
    final dataSource = DemoFeatureGoodsDataSource(
      detailHandler: (_) async =>
          BaseResponse<Goods>(code: 500, message: '商品请求失败'),
    );
    final logic = NetworkRequestDemoLogic(
      goodsRepository: GoodsRepository(dataSource: dataSource),
    );

    await expectLater(logic.request(), completes);

    expect(logic.isLoading.value, isFalse);
    expect(logic.goods.value, isNull);
    expect(logic.errorMessage.value, '商品请求失败');
  });

  test('数据库 Logic 初始化、新增、删除和清空后同步列表', () async {
    final dataSource = DemoFeatureLocalDataSource();
    final logic = DatabaseDemoLogic(
      demoRepository: DemoRepository(dataSource: dataSource),
    );

    logic.onInit();
    await Future<void>.delayed(Duration.zero);
    expect(logic.items, isEmpty);

    await logic.addItem();
    await logic.addItem();
    expect(logic.items.map((item) => item.title), <String>['示例记录 1', '示例记录 2']);

    await logic.deleteItem(1);
    expect(logic.items.single.id, 2);

    await logic.clearAll();
    expect(logic.items, isEmpty);
  });

  test('本地存储 Logic 保存、读取和清除演示用户', () async {
    final dataSource = DemoFeatureUserStoreDataSource();
    final logic = LocalStorageDemoLogic(
      userInfoStoreRepository: UserInfoStoreRepository(dataSource: dataSource),
    );

    await logic.readUser();
    expect(logic.user.value, isNull);

    await logic.saveUser();
    expect(logic.user.value?.id, 10086);
    expect(logic.user.value?.nickName, '演示用户');
    expect(dataSource.user?.phone, '18800000000');

    await logic.clearUser();
    expect(logic.user.value, isNull);
    expect(dataSource.user, isNull);
  });

  test('带参 Logic 优先使用注入参数并对缺失参数安全回退', () {
    final injected = NavigationWithArgsLogic(
      initialParams: const DemoParams(goodsId: 9527),
    )..onInit();
    final fallback = NavigationWithArgsLogic()..onInit();

    expect(injected.params.goodsId, 9527);
    expect(fallback.params.goodsId, 0);
  });

  test('状态管理 Logic 支持注入服务和 GetX 服务', () {
    final injectedService = DemoCounterService();
    final injectedLogic = StateManagementDemoLogic(
      counterService: injectedService,
    );
    injectedLogic.increment();
    injectedLogic.increment();
    injectedLogic.decrement();
    expect(injectedLogic.count.value, 1);
    injectedLogic.reset();
    expect(injectedLogic.count.value, 0);

    final registeredService = Get.put(DemoCounterService());
    final registeredLogic = StateManagementDemoLogic();
    registeredLogic.increment();
    expect(registeredLogic.count, same(registeredService.count));
    expect(registeredLogic.count.value, 1);
  });

  testWidgets('主题 Logic 切换语言、系统跟随、明暗模式和主题颜色', (tester) async {
    await tester.pumpWidget(
      buildCoreTestApp(home: const Scaffold(body: SizedBox())),
    );
    final logic = ThemeDemoLogic();
    expect(logic.themeDemoState.themeColors, ThemeColorPreset.values);

    await logic.toggleLocale();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
    expect(Application.locale.value, const Locale('en', 'US'));
    await logic.toggleLocale();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
    expect(Application.locale.value, const Locale('zh', 'CN'));

    await logic.updateFollowSystem(true, Brightness.dark);
    expect(Application.themeMode.value, ThemeMode.system);
    await logic.updateFollowSystem(false, Brightness.dark);
    expect(Application.themeMode.value, ThemeMode.dark);
    await logic.updateFollowSystem(false, Brightness.light);
    expect(Application.themeMode.value, ThemeMode.light);
    await logic.updateThemeMode(ThemeMode.dark);
    expect(Application.themeMode.value, ThemeMode.dark);

    await logic.updateThemeColor(ThemeColorPreset.green);
    expect(Application.themeColorName.value, 'green');
  });

  test('主题 Logic 忽略空配置与加载异常并保留原主题', () async {
    Application.themeColorName.value = 'theme';
    final emptyLogic = ThemeDemoLogic(themeDataLoader: (_) async => null);
    await emptyLogic.updateThemeColor(ThemeColorPreset.green);
    expect(Application.themeColorName.value, 'theme');

    final errorLogic = ThemeDemoLogic(
      themeDataLoader: (_) async => throw StateError('主题资源损坏'),
    );
    await expectLater(
      errorLogic.updateThemeColor(ThemeColorPreset.red),
      completes,
    );
    expect(Application.themeColorName.value, 'theme');
  });
}

/// 重置应用级响应式状态。
void _resetApplicationState() {
  Application.locale.value = const Locale('zh', 'CN');
  Application.themeMode.value = ThemeMode.system;
  Application.themeColorName.value = 'theme';
  Application.themeData.value = TDThemeData.defaultData();
  Get.locale = const Locale('zh', 'CN');
}
