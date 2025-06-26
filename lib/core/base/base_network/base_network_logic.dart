import '../../model/response/base/base_response.dart';
import '../../network/result/result_handler.dart';
import '../../util/common/common_util.dart';
import '../../util/log/log_util.dart';
import '../base/base_logic.dart';
import 'base_network_state.dart';

/// 公共控制器 主要是对网络请求进行封装
class BaseNetworkLogic<T> extends BaseLogic {
  /// 状态
  final BaseNetworkState networkState;

  /// 构造函数，允许注入自定义状态
  BaseNetworkLogic({BaseNetworkState? state}) 
      : networkState = state ?? BaseNetworkState();

  /// 要请求的 api 接口 子类重写实现（用于不带参数的请求）
  late final Future<BaseResponse<T>> Function()? apiRequest = null;

  /// 请求前的回调
  void beforeRequest() {}

  /// 请求成功后的回调
  void requestOk(T data) {}

  /// 请求失败后的回调
  void requestError() {}

  /// 进行网络请求
  Future<void> loadData() async {
    // 如果没有提供apiRequest或者apiRequestParams，则直接返回
    if (CommonUtil.isNull(apiRequest)) return;

    // 进行网络请求
    await ApiHandler.handleFull(
      api: apiRequest!(),
      showErrorToast: true,
      onStart: () {
        if (networkState.requestSetStatus) setStatusLoad();
        beforeRequest();
      },
      onSuccess: (data) {
        setStatusSuccess();
        requestOk(data as T);
      },
      onError: (message, error) {
        // 记录错误信息 - 使用格式化后的错误消息
        LogUtil.e('请求错误: $message');
        if (error != null) {
          LogUtil.e('错误详情: $error');
        }

        if (networkState.requestSetStatus) setStatusError();
        requestError();
      },
    );
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

  @override
  void initData() {
    if (networkState.uiState.value != NetState.loading ||
        !networkState.firstLoad) {
      return;
    }
    loadData();
  }
}
