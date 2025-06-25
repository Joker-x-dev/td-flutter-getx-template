import '../base_network/base_network_logic.dart';
import 'base_refresh_state.dart';

abstract class BaseRefreshLogic<T> extends BaseNetworkLogic<T> {
  /// 状态管理
  final BaseRefreshState refreshState = BaseRefreshState();

  /// 刷新数据
  @override
  Future<void> refresh() async => await super.loadData();
}
