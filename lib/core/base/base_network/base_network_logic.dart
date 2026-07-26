import '../../model/response/base/base_response.dart';
import '../../result/error_formatter.dart';
import '../../result/request_helper.dart';
import '../../util/log/log_util.dart';
import '../base/base_logic.dart';
import 'base_network_state.dart';

/// 公共控制器，主要是对网络请求进行封装
abstract class BaseNetworkLogic<T> extends BaseLogic {
  /// 默认网络页面 State，仅在业务 Logic 未重写 [networkState] 时创建
  late final BaseNetworkState _networkState = BaseNetworkState();

  /// 网络页面 State，业务 Logic 可重写并返回自身声明的 State
  BaseNetworkState get networkState => _networkState;

  /// 子类重写此 getter 返回实际请求的 api 接口
  ///
  /// 返回 null 表示当前控制器没有网络请求
  Future<BaseResponse<T>> Function()? get apiRequest;

  /// 请求前的回调
  void beforeRequest() {}

  /// 请求成功后的回调
  ///
  /// [data] 请求返回的业务数据。
  void requestOk(T data) {}

  /// 请求失败后的回调
  ///
  /// 如需统一处理失败状态，请重写 [onRequestError]
  void requestError() {}

  /// 请求失败时的统一处理入口
  ///
  /// [message] 格式化后的错误信息
  /// [error] 原始异常对象
  void onRequestError(String message, dynamic error) {
    requestError();
  }

  /// 进行网络请求
  Future<void> loadData() async {
    final request = apiRequest;
    if (request == null) return;

    String? errorMessage;
    dynamic originalError;

    try {
      final data = await RequestHelper.repository<T>(request())
          .start(() {
            if (networkState.requestSetStatus) setStatusLoad();
            beforeRequest();
          })
          .toast(networkState.requestErrorToast)
          .error((message, error) {
            errorMessage = message;
            originalError = error;
          })
          .execute();

      if (data == null) {
        setStatusEmpty();
        return;
      }

      final NetState stateBeforeRequestOk = networkState.uiState.value;
      requestOk(data);
      if (networkState.uiState.value == stateBeforeRequestOk) {
        setStatusSuccess();
      }
    } on Object catch (error, stackTrace) {
      final message =
          errorMessage ?? ErrorFormatter.formatError(error, stackTrace);

      // 记录错误信息 - 使用格式化后的错误消息
      LogUtil.e('请求错误: $message');
      if (originalError != null) {
        LogUtil.e('错误详情: $originalError');
      } else {
        LogUtil.e('错误详情: $error');
      }

      if (networkState.requestSetStatus) setStatusError();
      onRequestError(message, originalError ?? error);
    }
  }

  /// 设置状态为加载
  void setStatusLoad() {
    networkState.uiState.value = NetState.loading;
  }

  /// 设置状态为失败
  void setStatusError() {
    networkState.uiState.value = NetState.error;
  }

  /// 设置状态为成功
  void setStatusSuccess() {
    networkState.uiState.value = NetState.dataSuccess;
  }

  /// 设置状态为空数据
  void setStatusEmpty() {
    networkState.uiState.value = NetState.emptyData;
  }

  /// 根据首次加载配置初始化网络数据
  @override
  void initData() {
    if (networkState.uiState.value != NetState.loading ||
        !networkState.firstLoad) {
      return;
    }
    loadData();
  }
}
