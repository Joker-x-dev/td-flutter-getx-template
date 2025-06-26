import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';

import '../../model/response/base/base_list_response.dart';
import '../../model/response/base/base_response.dart';
import '../../util/common/common_util.dart';
import '../base_network/base_network_logic.dart';
import '../base_network/base_network_state.dart';
import 'base_list_state.dart';

/// 列表base类 主要是对列表进行封装
abstract class BaseListLogic<T> extends BaseNetworkLogic<BaseListResponse<T>> {
  /// 列表状态
  late final BaseListState<T> listState;

  /// 构造函数，确保只创建一个实例
  BaseListLogic() : super(state: BaseListState<T>()) {
    listState = networkState as BaseListState<T>;
  }

  /// 重写 apiRequest，让其返回 Future<BaseResponse<BaseListResponse<T>>>
  @override
  Future<BaseResponse<BaseListResponse<T>>> Function()? get apiRequest => null;

  @override
  void requestOk(BaseListResponse<T>? data) {
    final record = data?.list ?? [];
    if (CommonUtil.isNull(record)) {
      return updateListPageStatusEmpty();
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
    // 如果已经到了最后一页，也设置 noMoreData 为 true
    final totalPages =
        (data!.pagination!.total! / data.pagination!.size!).ceil();
    if (listState.currentPage >= totalPages || totalPages == 0) {
      listState.noMoreData = true;
      setRefreshStatusNoMore();
    } else {
      setRefreshStatusSuccess();
    }
  }

  /// 处理数据列表的方法（可被子类覆盖实现）
  /// 默认情况下什么都不做，子类可以在这里修改列表中的具体值
  void processDataList(List<T> list) {}

  @override
  void requestError() {
    // 就只有数据为空的情况下加载失败才会显示错误页面
    // 为了不影响下拉刷新加载失败 才会这么做
    if (CommonUtil.isNull(listState.dataList)) super.setStatusError();
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
      IndicatorState? footerState = listState.easyRefreshController.footerState;
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

  /// 设置列表页面状态为空 子类可重写
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
  void setRefreshStatus(IndicatorResult status, bool force) {
    listState.easyRefreshController.finishLoad(status, force);
  }

  /// 设置伪造数据 可以设置延迟 单位毫秒
  Future<void> setFakeData(List<T> fakeRecords, {int delay = 300}) async {
    await Future.delayed(Duration(milliseconds: delay));
    listState.dataList.assignAll(fakeRecords);
    listState.noMoreData = true;
    setRefreshStatusNoMore();
    setStatusSuccess();
  }
}
