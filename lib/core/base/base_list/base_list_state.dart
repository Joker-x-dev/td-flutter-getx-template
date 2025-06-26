import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';

import '../base_network/base_network_state.dart';

/// 列表状态管理类
class BaseListState<T> extends BaseNetworkState {
  @override
  bool get requestSetStatus => false;

  /// 刷新控制器
  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishLoad: true,
  );

  /// 单页最大数量 子类可通过重写修改
  int pageSize = 20;

  /// 当前页数
  int currentPage = 1;

  /// 存储列表数据
  RxList<T> dataList = RxList<T>([]);

  /// 没有更多数据了
  bool noMoreData = false;

  /// 默认的分页参数
  late Map<String, dynamic> pageParams;
}
