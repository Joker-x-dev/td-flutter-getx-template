import 'package:easy_refresh/easy_refresh.dart';

import '../base_network/base_network_state.dart';

/// 刷新状态管理
class BaseRefreshState extends BaseNetworkState {
  /// 每次加载前是否设置为加载状态 一般配合base_list使用
  @override
  bool get requestSetStatus => false;

  /// 刷新控制器
  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishLoad: true,
  );
}
