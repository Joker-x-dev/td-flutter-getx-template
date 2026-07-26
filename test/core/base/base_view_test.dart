import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:flutter_kit/core/base/base/base_view.dart';
import 'package:flutter_kit/core/base/base_list/base_list_logic.dart';
import 'package:flutter_kit/core/base/base_list/base_list_view.dart';
import 'package:flutter_kit/core/base/base_network/base_network_logic.dart';
import 'package:flutter_kit/core/base/base_network/base_network_view.dart';
import 'package:flutter_kit/core/base/base_refresh/base_refresh_logic.dart';
import 'package:flutter_kit/core/base/base_refresh/base_refresh_view.dart';
import 'package:flutter_kit/core/model/response/base/base_list_response.dart';
import 'package:flutter_kit/core/model/response/base/base_response.dart';

import '../../support/test_environment.dart';

/// Base View 页面结构和网络状态语义测试。
void main() {
  setUp(initializeCoreTestEnvironment);
  tearDown(resetCoreTestEnvironment);

  testWidgets('BaseView 构建正文、底部区域和悬浮按钮', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildCoreTestApp(home: _BasicView(logic: Object())),
    );

    expect(find.byType(Scaffold), findsWidgets);
    expect(find.text('正文'), findsOneWidget);
    expect(find.text('底部'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('BaseView 默认导航栏展示主题返回按钮', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildCoreTestApp(home: const _DefaultHeadView(logic: Object())),
    );

    expect(find.byType(TDNavBar), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);
    expect(find.text('默认导航正文'), findsOneWidget);
  });

  testWidgets('BaseNetworkView 展示加载、空、错误和成功状态', (WidgetTester tester) async {
    final _NetworkViewLogic logic = _NetworkViewLogic();
    await tester.pumpWidget(buildCoreTestApp(home: _NetworkView(logic: logic)));

    expect(find.text('加载中…'), findsOneWidget);

    logic.setStatusEmpty();
    await tester.pumpAndSettle();
    expect(find.text('数据为空'), findsOneWidget);
    expect(find.text('重新加载'), findsOneWidget);

    logic.setStatusError();
    await tester.pumpAndSettle();
    expect(find.text('内容加载失败，请检查网络'), findsOneWidget);

    logic.setStatusSuccess();
    await tester.pumpAndSettle();
    expect(find.text('成功内容'), findsOneWidget);
  });

  testWidgets('空状态重新加载发起请求并恢复成功内容', (WidgetTester tester) async {
    final _NetworkViewLogic logic = _NetworkViewLogic()..setStatusEmpty();
    await tester.pumpWidget(buildCoreTestApp(home: _NetworkView(logic: logic)));

    await tester.tap(find.text('重新加载'));
    await tester.pump();

    expect(logic.requestCount, 1);
    expect(logic.networkState.uiState.value.name, 'dataSuccess');
    await tester.pump(const Duration(milliseconds: 200));
  });

  testWidgets('BaseListView 按顺序构建列表项并挂载刷新组件', (WidgetTester tester) async {
    final _ListViewLogic logic = _ListViewLogic();
    logic.listState.dataList.assignAll(<int>[3, 5]);
    logic.setStatusSuccess();
    await tester.pumpWidget(buildCoreTestApp(home: _ListView(logic: logic)));

    expect(find.byType(EasyRefresh), findsOneWidget);
    expect(find.text('项目 3-0'), findsOneWidget);
    expect(find.text('项目 5-1'), findsOneWidget);

    final EasyRefresh refresh = tester.widget(find.byType(EasyRefresh));
    await refresh.onRefresh?.call();
    await refresh.onLoad?.call();

    await tester.pumpWidget(const SizedBox());
    logic.listState.easyRefreshController.dispose();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('BaseRefreshView 构建刷新内容列表', (WidgetTester tester) async {
    final _RefreshViewLogic logic = _RefreshViewLogic()..setStatusSuccess();
    await tester.pumpWidget(buildCoreTestApp(home: _RefreshView(logic: logic)));

    expect(find.byType(EasyRefresh), findsOneWidget);
    expect(find.text('刷新内容一'), findsOneWidget);
    expect(find.text('刷新内容二'), findsOneWidget);

    final EasyRefresh refresh = tester.widget(find.byType(EasyRefresh));
    await refresh.onRefresh?.call();

    await tester.pumpWidget(const SizedBox());
    logic.refreshState.easyRefreshController.dispose();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
  });
}

/// 基础页面测试实现。
class _BasicView extends BaseView<Object> {
  /// 创建基础页面测试实现。
  const _BasicView({required super.logic});

  /// 隐藏测试导航栏。
  @override
  PreferredSizeWidget? head() => null;

  /// 构建正文。
  @override
  Widget body() => const Text('正文');

  /// 构建底部区域。
  @override
  Widget bottom() => const Text('底部');

  /// 构建悬浮按钮。
  @override
  Widget floatingAction() =>
      const FloatingActionButton(onPressed: null, child: Icon(Icons.add));
}

/// 使用默认导航栏的基础页面。
class _DefaultHeadView extends BaseView<Object> {
  /// 创建默认导航栏页面。
  const _DefaultHeadView({required super.logic});

  /// 构建默认导航页面正文。
  @override
  Widget body() => const Text('默认导航正文');
}

/// 网络页面测试 Logic。
class _NetworkViewLogic extends BaseNetworkLogic<int> {
  /// 请求次数。
  int requestCount = 0;

  /// 测试请求。
  @override
  Future<BaseResponse<int>> Function()? get apiRequest => () async {
    requestCount++;
    return BaseResponse<int>(data: 1);
  };

  /// 接收成功结果。
  @override
  void requestOk(int? data) {}
}

/// 网络页面测试实现。
class _NetworkView extends BaseNetworkView<_NetworkViewLogic> {
  /// 创建网络页面测试实现。
  _NetworkView({required super.logic});

  /// 隐藏测试导航栏。
  @override
  PreferredSizeWidget? head() => null;

  /// 构建成功内容。
  @override
  Widget bodyContent(_NetworkViewLogic logic) => const Text('成功内容');
}

/// 列表页面测试 Logic。
class _ListViewLogic extends BaseListLogic<int> {
  /// 测试分页请求。
  @override
  Future<BaseResponse<BaseListResponse<int>>> Function()? get apiRequest =>
      () async =>
          BaseResponse<BaseListResponse<int>>(data: BaseListResponse<int>());
}

/// 列表页面测试实现。
class _ListView extends BaseListView<_ListViewLogic, int> {
  /// 创建列表页面测试实现。
  _ListView({required super.logic});

  /// 隐藏测试导航栏。
  @override
  PreferredSizeWidget? head() => null;

  /// 构建列表项。
  @override
  Widget itemWidget(int item, int index) => Text('项目 $item-$index');
}

/// 刷新页面测试 Logic。
class _RefreshViewLogic extends BaseRefreshLogic<int> {
  /// 测试刷新请求。
  @override
  Future<BaseResponse<int>> Function()? get apiRequest =>
      () async => BaseResponse<int>(data: 1);

  /// 接收刷新结果。
  @override
  void requestOk(int? data) {}
}

/// 刷新页面测试实现。
class _RefreshView extends BaseRefreshView<_RefreshViewLogic> {
  /// 创建刷新页面测试实现。
  _RefreshView({required super.logic});

  /// 隐藏测试导航栏。
  @override
  PreferredSizeWidget? head() => null;

  /// 构建刷新内容。
  @override
  List<Widget> pageContent(_RefreshViewLogic logic) => const <Widget>[
    Text('刷新内容一'),
    Text('刷新内容二'),
  ];
}
