import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';

import '../../model/response/base/base_list_response.dart';
import '../../model/response/base/base_response.dart';
import '../../util/common/common_util.dart';
import '../base_network/base_network_logic.dart';
import 'base_list_state.dart';

/// 列表 base 类，主要是对列表进行封装
abstract class BaseListLogic<T> extends BaseNetworkLogic<BaseListResponse<T>> {
  /// 默认分页列表 State，仅在业务 Logic 未重写 [listState] 时创建
  late final BaseListState<T> _listState = BaseListState<T>();

  /// 列表状态
  BaseListState<T> get listState => _listState;

  /// 网络父类复用分页列表 State，保证请求状态与分页状态属于同一对象
  @override
  BaseListState<T> get networkState => listState;

  /// 子类重写此 getter 返回列表请求接口
  @override
  Future<BaseResponse<BaseListResponse<T>>> Function()? get apiRequest;

  /// 处理分页请求成功结果
  ///
  /// [data] 分页响应数据。
  @override
  void requestOk(BaseListResponse<T>? data) {
    final record = data?.list ?? [];
    if (CommonUtil.isBlank(record)) {
      if (listState.currentPage == 1) {
        return updateListPageStatusEmpty();
      }

      // 下一页为空表示分页结束，保留已加载内容并结束加载更多。
      listState.noMoreData = true;
      setRefreshStatusNoMore();
      return;
    }

    if (listState.currentPage == 1) {
      // 如果是第一页，直接赋值
      listState.dataList.assignAll(record);
    } else {
      // 如果是加载更多，追加数据到现有列表中
      listState.dataList.addAll(record);
    }
    // 数据处理方法，让子类有机会修改数据
    processDataList(listState.dataList);

    // 计算总页数，避免对后端字段强解包
    final total = data?.pagination?.total ?? 0;
    final size = data?.pagination?.size ?? listState.pageSize;
    final totalPages = size > 0 ? (total / size).ceil() : 0;

    if (listState.currentPage >= totalPages || totalPages == 0) {
      listState.noMoreData = true;
      setRefreshStatusNoMore();
    } else {
      setRefreshStatusSuccess();
    }
  }

  /// 处理数据列表的方法（可被子类覆盖实现）
  ///
  /// [list] 当前分页数据列表。
  /// 默认不修改数据，子类可覆盖并转换列表内容
  void processDataList(List<T> list) {}

  /// 处理列表请求失败状态
  ///
  /// [message] 格式化后的错误信息。
  /// [error] 原始异常对象。
  @override
  void onRequestError(String message, dynamic error) {
    super.onRequestError(message, error);
    if (listState.currentPage > 1) {
      // 加载更多失败时恢复到上一成功页，保证重试请求页码正确。
      listState.currentPage--;
      updatePageParams();
    }
    // 请求失败时结束刷新动画，避免下拉刷新/上拉加载卡住
    if (listState.dataList.isEmpty) {
      super.setStatusError();
    }
    setRefreshStatusFailed();
  }

  /// 刷新数据
  @override
  Future<void> refresh() async {
    listState.currentPage = 1;
    listState.noMoreData = false;
    updatePageParams();
    await loadData();
  }

  /// 加载更多数据
  Future<void> loadMore() async {
    if (listState.noMoreData) {
      final footerState = listState.easyRefreshController.footerState;
      final state = footerState?.result;
      if (state != null && state == IndicatorResult.none) {
        // 只有在没有状态的情况下才设置状态
        setRefreshStatusNoMore();
      }
      return;
    }
    listState.currentPage++;
    updatePageParams();
    await loadData();
  }

  /// 初始化分页请求参数
  @override
  void onInit() {
    super.onInit();
    // 初始化所携带的参数值
    updatePageParams();
  }

  /// 更新分页参数为最新的值
  void updatePageParams() {
    // 初始化基本分页参数
    listState.pageParams = {
      "pageSize": listState.pageSize,
      "pageNum": listState.currentPage,
    };
  }

  /// 设置列表页面状态为空，子类可重写
  void updateListPageStatusEmpty() {
    super.setStatusEmpty();
  }

  /// 设置刷新控制器为无状态
  void setRefreshStatusNone() {
    setRefreshStatus(IndicatorResult.none, true);
  }

  /// 设置刷新控制器为成功
  void setRefreshStatusSuccess() {
    setRefreshStatus(IndicatorResult.success, true);
  }

  /// 设置刷新控制器为没有更多数据了
  void setRefreshStatusNoMore() {
    setRefreshStatus(IndicatorResult.noMore, true);
  }

  /// 设置刷新控制器为加载失败
  void setRefreshStatusFailed() {
    setRefreshStatus(IndicatorResult.fail, true);
  }

  /// 设置刷新控制器状态
  ///
  /// [status] 目标刷新状态。
  /// [force] 是否强制结束当前刷新动作。
  void setRefreshStatus(IndicatorResult status, bool force) {
    listState.easyRefreshController.finishLoad(status, force);
  }

  /// 设置伪造数据，可以设置延迟，单位毫秒
  ///
  /// [fakeRecords] 待写入的伪造数据列表。
  /// [delay] 模拟请求延迟，单位为毫秒。
  Future<void> setFakeData(List<T> fakeRecords, {int delay = 300}) async {
    await Future<void>.delayed(Duration(milliseconds: delay));
    listState.dataList.assignAll(fakeRecords);
    listState.noMoreData = true;
    setRefreshStatusNoMore();
    setStatusSuccess();
  }
}
