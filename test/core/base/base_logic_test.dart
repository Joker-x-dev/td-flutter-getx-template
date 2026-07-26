import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:flutter_kit/core/base/base/base_logic.dart';
import 'package:flutter_kit/core/base/base_list/base_list_logic.dart';
import 'package:flutter_kit/core/base/base_list/base_list_state.dart';
import 'package:flutter_kit/core/base/base_network/base_network_logic.dart';
import 'package:flutter_kit/core/base/base_network/base_network_state.dart';
import 'package:flutter_kit/core/base/base_refresh/base_refresh_logic.dart';
import 'package:flutter_kit/core/base/base_refresh/base_refresh_state.dart';
import 'package:flutter_kit/core/model/response/base/base_list_response.dart';
import 'package:flutter_kit/core/model/response/base/base_response.dart';

import '../../support/test_environment.dart';

/// Base Logic 生命周期和网络状态机测试。
void main() {
  setUp(initializeCoreTestEnvironment);
  tearDown(resetCoreTestEnvironment);

  group('BaseLogic', () {
    test('onReady 调用一次 initData', () {
      final _LifecycleLogic logic = _LifecycleLogic();

      logic.onReady();

      expect(logic.initCount, 1);
    });

    test('默认生命周期方法可安全调用', () {
      final _LifecycleLogic logic = _LifecycleLogic();

      logic.onInit();
      logic.onDetached();
      logic.onInactive();
      logic.onPaused();
      logic.onResumed();
      logic.onHidden();

      expect(logic.initCount, 0);
    });
  });

  group('BaseNetworkLogic', () {
    test('默认网络 State 和成功回调可直接使用', () async {
      final _DefaultNetworkLogic logic = _DefaultNetworkLogic();

      expect(logic.networkState.firstLoad, isTrue);
      expect(logic.networkState.requestSetStatus, isTrue);
      expect(logic.networkState.requestErrorToast, isTrue);

      await logic.loadData();
      expect(logic.networkState.uiState.value, NetState.dataSuccess);
    });

    test('默认 State 使用加载状态和标准请求配置', () {
      final _NetworkLogic logic = _NetworkLogic();

      expect(logic.networkState.uiState.value, NetState.loading);
      expect(logic.networkState.firstLoad, isTrue);
      expect(logic.networkState.requestSetStatus, isTrue);
      expect(logic.networkState.requestErrorToast, isFalse);
    });

    test('无 apiRequest 时 loadData 不执行回调', () async {
      final _NetworkLogic logic = _NetworkLogic();

      await logic.loadData();

      expect(logic.beforeCount, 0);
      expect(logic.successData, isNull);
    });

    test('请求成功依次执行 beforeRequest、requestOk 并进入成功状态', () async {
      final _NetworkLogic logic = _NetworkLogic(
        request: () async => BaseResponse<int>(data: 7),
      );

      await logic.loadData();

      expect(logic.beforeCount, 1);
      expect(logic.successData, 7);
      expect(logic.networkState.uiState.value, NetState.dataSuccess);
    });

    test('requestOk 主动设置空状态时父类不覆盖', () async {
      final _NetworkLogic logic = _NetworkLogic(
        request: () async => BaseResponse<int>(data: 0),
        emptyOnSuccess: true,
      );

      await logic.loadData();

      expect(logic.networkState.uiState.value, NetState.emptyData);
    });

    test('业务成功但响应数据为空时直接进入空状态', () async {
      final _NetworkLogic logic = _NetworkLogic(
        request: () async => BaseResponse<int>(data: null),
      );

      await logic.loadData();

      expect(logic.successData, isNull);
      expect(logic.errorMessage, isNull);
      expect(logic.networkState.uiState.value, NetState.emptyData);
    });

    test('业务失败设置错误状态并回调格式化信息', () async {
      final _NetworkLogic logic = _NetworkLogic(
        request: () async => BaseResponse<int>(code: 400, message: '业务失败'),
      );

      await logic.loadData();

      expect(logic.networkState.uiState.value, NetState.error);
      expect(logic.errorMessage, '业务失败');
      expect(logic.errorObject, isA<Error>());
    });

    test('请求异常设置错误状态并保留原始异常', () async {
      final Exception exception = Exception('network');
      final _NetworkLogic logic = _NetworkLogic(
        request: () => Future<BaseResponse<int>>.error(exception),
      );

      await logic.loadData();

      expect(logic.networkState.uiState.value, NetState.error);
      expect(logic.errorObject, same(exception));
    });

    test('请求函数同步抛错时同样格式化并回调原始错误', () async {
      final StateError error = StateError('同步请求失败');
      final _NetworkLogic logic = _NetworkLogic(request: () => throw error);

      await logic.loadData();

      expect(logic.networkState.uiState.value, NetState.error);
      expect(logic.errorMessage, contains('同步请求失败'));
      expect(logic.errorObject, same(error));
    });

    test('requestSetStatus 为 false 时请求前保留当前状态', () async {
      final _NetworkState state = _NetworkState(requestSetStatusValue: false);
      final _NetworkLogic logic = _NetworkLogic(
        state: state,
        request: () async => BaseResponse<int>(data: 1),
      );
      state.uiState.value = NetState.dataSuccess;

      await logic.loadData();

      expect(logic.stateSeenBeforeRequest, NetState.dataSuccess);
    });

    test('initData 仅在首次加载开启且状态为 loading 时请求', () async {
      final _NetworkLogic enabled = _NetworkLogic(
        request: () async => BaseResponse<int>(data: 1),
      );
      final _NetworkLogic disabled = _NetworkLogic(
        state: _NetworkState(firstLoadValue: false),
        request: () async => BaseResponse<int>(data: 1),
      );
      final _NetworkLogic completed = _NetworkLogic(
        request: () async => BaseResponse<int>(data: 1),
      )..setStatusSuccess();

      enabled.initData();
      disabled.initData();
      completed.initData();
      await Future<void>.delayed(Duration.zero);

      expect(enabled.beforeCount, 1);
      expect(disabled.beforeCount, 0);
      expect(completed.beforeCount, 0);
    });

    test('状态设置方法覆盖四种网络状态', () {
      final _NetworkLogic logic = _NetworkLogic();

      logic.setStatusError();
      expect(logic.networkState.uiState.value, NetState.error);
      logic.setStatusEmpty();
      expect(logic.networkState.uiState.value, NetState.emptyData);
      logic.setStatusSuccess();
      expect(logic.networkState.uiState.value, NetState.dataSuccess);
      logic.setStatusLoad();
      expect(logic.networkState.uiState.value, NetState.loading);
    });
  });

  group('BaseListLogic', () {
    test('默认分页状态使用每页二十条并允许默认数据处理', () {
      final _ListLogic logic = _ListLogic();
      final BaseListState<int> defaultState = BaseListState<int>();

      expect(defaultState.pageSize, 20);
      expect(() => logic.callDefaultProcess(<int>[1]), returnsNormally);
      logic.setRefreshStatusNone();
    });

    test('onInit 初始化分页参数', () {
      final _ListLogic logic = _ListLogic();

      logic.onInit();

      expect(logic.listState.pageParams, <String, dynamic>{
        'pageSize': 2,
        'pageNum': 1,
      });
      expect(logic.listState.requestSetStatus, isFalse);
    });

    test('首页成功替换旧数据并保留加载更多能力', () async {
      final _ListLogic logic = _ListLogic(
        pages: <int, Future<BaseResponse<BaseListResponse<int>>> Function()>{
          1: () async => _page(<int>[1, 2], total: 3, size: 2, page: 1),
        },
      );
      logic.listState.dataList.assignAll(<int>[99]);

      await logic.refresh();

      expect(logic.listState.dataList, <int>[1, 2]);
      expect(logic.listState.noMoreData, isFalse);
      expect(logic.processCount, 1);
    });

    test('加载下一页追加数据并标记无更多', () async {
      final _ListLogic logic = _ListLogic(
        pages: <int, Future<BaseResponse<BaseListResponse<int>>> Function()>{
          2: () async => _page(<int>[3], total: 3, size: 2, page: 2),
        },
      );
      logic.listState.dataList.assignAll(<int>[1, 2]);

      await logic.loadMore();

      expect(logic.listState.currentPage, 2);
      expect(logic.listState.dataList, <int>[1, 2, 3]);
      expect(logic.listState.noMoreData, isTrue);
    });

    test('首页空列表进入空状态', () async {
      final _ListLogic logic = _ListLogic(
        pages: <int, Future<BaseResponse<BaseListResponse<int>>> Function()>{
          1: () async => _page(<int>[], total: 0, size: 2, page: 1),
        },
      );

      await logic.refresh();

      expect(logic.networkState.uiState.value, NetState.emptyData);
    });

    test('下一页空列表保留已有数据并结束加载更多', () async {
      final _ListLogic logic = _ListLogic(
        pages: <int, Future<BaseResponse<BaseListResponse<int>>> Function()>{
          2: () async => _page(<int>[], total: 2, size: 2, page: 2),
        },
      );
      logic.listState.dataList.assignAll(<int>[1, 2]);
      logic.setStatusSuccess();

      await logic.loadMore();

      expect(logic.listState.dataList, <int>[1, 2]);
      expect(logic.listState.noMoreData, isTrue);
      expect(logic.networkState.uiState.value, NetState.dataSuccess);
    });

    test('分页信息缺失或页大小无效时安全结束加载更多', () async {
      final _ListLogic missingPagination = _ListLogic(
        pages: <int, Future<BaseResponse<BaseListResponse<int>>> Function()>{
          1: () async => BaseResponse<BaseListResponse<int>>(
            data: BaseListResponse<int>(list: <int>[1]),
          ),
        },
      );
      final _ListLogic invalidSize = _ListLogic(
        pages: <int, Future<BaseResponse<BaseListResponse<int>>> Function()>{
          1: () async => _page(<int>[2], total: 10, size: 0, page: 1),
        },
      );

      await missingPagination.refresh();
      await invalidSize.refresh();

      expect(missingPagination.listState.dataList, <int>[1]);
      expect(missingPagination.listState.noMoreData, isTrue);
      expect(
        missingPagination.networkState.uiState.value,
        NetState.dataSuccess,
      );
      expect(invalidSize.listState.dataList, <int>[2]);
      expect(invalidSize.listState.noMoreData, isTrue);
      expect(invalidSize.networkState.uiState.value, NetState.dataSuccess);
    });

    test('刷新会从任意分页状态恢复到第一页并重置无更多标记', () async {
      final _ListLogic logic = _ListLogic(
        pages: <int, Future<BaseResponse<BaseListResponse<int>>> Function()>{
          1: () async => _page(<int>[7, 8], total: 4, size: 2, page: 1),
        },
      );
      logic.listState.currentPage = 3;
      logic.listState.noMoreData = true;
      logic.listState.dataList.assignAll(<int>[1, 2, 3, 4]);

      await logic.refresh();

      expect(logic.listState.currentPage, 1);
      expect(logic.listState.pageParams, <String, dynamic>{
        'pageSize': 2,
        'pageNum': 1,
      });
      expect(logic.listState.dataList, <int>[7, 8]);
      expect(logic.listState.noMoreData, isFalse);
    });

    test('加载更多失败回退页码并保留已有成功内容', () async {
      final _ListLogic logic = _ListLogic(
        pages: <int, Future<BaseResponse<BaseListResponse<int>>> Function()>{
          2: () => Future<BaseResponse<BaseListResponse<int>>>.error(
            Exception('page failed'),
          ),
        },
      );
      logic.listState.dataList.assignAll(<int>[1, 2]);
      logic.setStatusSuccess();

      await logic.loadMore();

      expect(logic.listState.currentPage, 1);
      expect(logic.listState.dataList, <int>[1, 2]);
      expect(logic.networkState.uiState.value, NetState.dataSuccess);
    });

    test('首页请求失败进入整页错误状态', () async {
      final _ListLogic logic = _ListLogic(
        pages: <int, Future<BaseResponse<BaseListResponse<int>>> Function()>{
          1: () => Future<BaseResponse<BaseListResponse<int>>>.error(
            Exception('first page failed'),
          ),
        },
      );

      await logic.refresh();

      expect(logic.listState.currentPage, 1);
      expect(logic.listState.dataList, isEmpty);
      expect(logic.networkState.uiState.value, NetState.error);
    });

    test('无更多数据时 loadMore 不再请求', () async {
      final _ListLogic logic = _ListLogic();
      logic.listState.noMoreData = true;

      await logic.loadMore();

      expect(logic.requestCount, 0);
      expect(logic.listState.currentPage, 1);
    });

    test('setFakeData 写入数据并设置成功和无更多状态', () async {
      final _ListLogic logic = _ListLogic();

      await logic.setFakeData(<int>[5, 6], delay: 0);

      expect(logic.listState.dataList, <int>[5, 6]);
      expect(logic.listState.noMoreData, isTrue);
      expect(logic.networkState.uiState.value, NetState.dataSuccess);
    });
  });

  group('BaseRefreshLogic', () {
    test('刷新复用网络请求且请求前不切换整页状态', () async {
      final _RefreshLogic logic = _RefreshLogic();
      logic.setStatusSuccess();

      await logic.refresh();

      expect(logic.stateSeenBeforeRequest, NetState.dataSuccess);
      expect(logic.refreshedValue, 8);
      expect(logic.networkState.uiState.value, NetState.dataSuccess);
      expect(logic.refreshState.requestSetStatus, isFalse);
    });

    test('刷新失败保留已有成功内容并回调原始错误', () async {
      final StateError source = StateError('刷新失败');
      final _RefreshLogic logic = _RefreshLogic(error: source);
      logic.refreshedValue = 3;
      logic.setStatusSuccess();

      await logic.refresh();

      expect(logic.refreshedValue, 3);
      expect(logic.networkState.uiState.value, NetState.dataSuccess);
      expect(logic.errorObject, same(source));
      expect(logic.errorMessage, contains('刷新失败'));
    });
  });
}

/// 构造分页成功响应。
BaseResponse<BaseListResponse<int>> _page(
  List<int> values, {
  required int total,
  required int size,
  required int page,
}) {
  return BaseResponse<BaseListResponse<int>>(
    data: BaseListResponse<int>(
      list: values,
      pagination: PageMeta(total: total, size: size, page: page),
    ),
  );
}

/// 生命周期测试 Logic。
class _LifecycleLogic extends BaseLogic {
  /// initData 调用次数。
  int initCount = 0;

  /// 记录初始化调用。
  @override
  void initData() {
    initCount++;
  }
}

/// 使用默认网络 State 与成功回调的 Logic。
class _DefaultNetworkLogic extends BaseNetworkLogic<int> {
  /// 返回固定成功响应。
  @override
  Future<BaseResponse<int>> Function()? get apiRequest =>
      () async => BaseResponse<int>(data: 1);
}

/// 可配置网络 State。
class _NetworkState extends BaseNetworkState {
  /// 创建可配置网络 State。
  _NetworkState({
    this.firstLoadValue = true,
    this.requestSetStatusValue = true,
  });

  /// 首次加载配置。
  final bool firstLoadValue;

  /// 请求状态切换配置。
  final bool requestSetStatusValue;

  /// 测试不展示 Toast。
  @override
  bool get requestErrorToast => false;

  /// 返回首次加载配置。
  @override
  bool get firstLoad => firstLoadValue;

  /// 返回请求状态切换配置。
  @override
  bool get requestSetStatus => requestSetStatusValue;
}

/// 网络状态机测试 Logic。
class _NetworkLogic extends BaseNetworkLogic<int> {
  /// 创建网络状态机测试 Logic。
  _NetworkLogic({
    this.request,
    this.emptyOnSuccess = false,
    _NetworkState? state,
  }) : state = state ?? _NetworkState();

  /// 可选请求。
  final Future<BaseResponse<int>> Function()? request;

  /// 成功时是否设置空状态。
  final bool emptyOnSuccess;

  /// 网络 State。
  final _NetworkState state;

  /// 请求前回调次数。
  int beforeCount = 0;

  /// 成功数据。
  int? successData;

  /// 错误信息。
  String? errorMessage;

  /// 原始错误。
  dynamic errorObject;

  /// 请求前看到的状态。
  NetState? stateSeenBeforeRequest;

  /// 返回网络 State。
  @override
  BaseNetworkState get networkState => state;

  /// 返回配置请求。
  @override
  Future<BaseResponse<int>> Function()? get apiRequest => request;

  /// 记录请求前状态。
  @override
  void beforeRequest() {
    beforeCount++;
    stateSeenBeforeRequest = networkState.uiState.value;
  }

  /// 记录成功数据。
  @override
  void requestOk(int data) {
    successData = data;
    if (emptyOnSuccess) {
      setStatusEmpty();
    }
  }

  /// 记录错误信息和原始错误。
  @override
  void onRequestError(String message, dynamic error) {
    errorMessage = message;
    errorObject = error;
  }
}

/// 两条一页的列表 State。
class _ListState extends BaseListState<int> {
  /// 测试不展示 Toast。
  @override
  bool get requestErrorToast => false;

  /// 每页两条数据。
  @override
  int get pageSize => 2;
}

/// 分页状态机测试 Logic。
class _ListLogic extends BaseListLogic<int> {
  /// 创建分页状态机测试 Logic。
  _ListLogic({
    this.pages =
        const <int, Future<BaseResponse<BaseListResponse<int>>> Function()>{},
  });

  /// 按页码提供请求结果。
  final Map<int, Future<BaseResponse<BaseListResponse<int>>> Function()> pages;

  /// 列表 State。
  final _ListState state = _ListState();

  /// 请求次数。
  int requestCount = 0;

  /// 数据处理次数。
  int processCount = 0;

  /// 返回列表 State。
  @override
  BaseListState<int> get listState => state;

  /// 返回当前页请求。
  @override
  Future<BaseResponse<BaseListResponse<int>>> Function()? get apiRequest {
    return () {
      requestCount++;
      final request = pages[listState.currentPage];
      if (request == null) {
        return Future<BaseResponse<BaseListResponse<int>>>.value(
          _page(<int>[], total: 0, size: 2, page: listState.currentPage),
        );
      }
      return request();
    };
  }

  /// 记录数据处理调用。
  @override
  void processDataList(List<int> list) {
    processCount++;
  }

  /// 调用父类默认数据处理逻辑。
  ///
  /// [list] 待处理的测试列表。
  void callDefaultProcess(List<int> list) {
    super.processDataList(list);
  }
}

/// 刷新状态机测试 Logic。
class _RefreshLogic extends BaseRefreshLogic<int> {
  /// 创建刷新状态机测试 Logic。
  ///
  /// [error] 可选刷新异常。
  _RefreshLogic({this.error});

  /// 可选刷新异常。
  final Object? error;

  /// 刷新 State。
  final BaseRefreshState state = BaseRefreshState();

  /// 请求前看到的状态。
  NetState? stateSeenBeforeRequest;

  /// 成功值。
  int? refreshedValue;

  /// 格式化错误信息。
  String? errorMessage;

  /// 原始错误对象。
  dynamic errorObject;

  /// 返回刷新 State。
  @override
  BaseRefreshState get refreshState => state;

  /// 返回刷新请求。
  @override
  Future<BaseResponse<int>> Function()? get apiRequest => () async {
    if (error case final Object source) {
      Error.throwWithStackTrace(source, StackTrace.current);
    }
    return BaseResponse<int>(data: 8);
  };

  /// 记录请求前状态。
  @override
  void beforeRequest() {
    stateSeenBeforeRequest = networkState.uiState.value;
  }

  /// 保存刷新值。
  @override
  void requestOk(int data) {
    refreshedValue = data;
  }

  /// 保存刷新失败信息。
  @override
  void onRequestError(String message, dynamic error) {
    errorMessage = message;
    errorObject = error;
  }
}
