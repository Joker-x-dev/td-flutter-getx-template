import '../base_network/base_network_logic.dart';
import '../base_network/base_network_state.dart';
import 'base_refresh_state.dart';

abstract class BaseRefreshLogic<T> extends BaseNetworkLogic<T> {
  /// 状态管理
  late final BaseRefreshState refreshState;

  /// 构造函数，确保只创建一个实例
  BaseRefreshLogic() : super(state: BaseRefreshState()) {
    refreshState = networkState as BaseRefreshState;
  }

  /// 刷新数据
  @override
  Future<void> refresh() async => await super.loadData();
}
