import '../../model/response/base/base_response.dart';
import '../../ui/dialog/loading_dialog.dart';
import '../../util/common/common_util.dart';
import 'error_formatter.dart';

/// API请求处理工具类
///
/// 用于简化网络请求的状态处理，提供统一的请求生命周期回调。
/// 主要处理以下几个方面：
/// 1. 请求开始状态 [onStart]
/// 2. 请求成功状态 [onSuccess]
/// 3. 请求错误状态 [onError]
/// 4. 统一的错误提示
class ApiHandler {
  /// 处理网络请求（简化版）
  ///
  /// 参数说明：
  /// * [api] - 网络请求响应，类型为[BaseResponse]
  /// * [onSuccess] - 请求成功时的回调，参数为响应数据
  /// * [loading] - 是否显示加载对话框，默认为false
  /// * [showErrorToast] - 是否显示错误提示Toast，默认为true
  ///
  /// 示例：
  /// ```dart
  /// ApiHandler.handle(
  ///   await api.getData(),
  ///   (data) {
  ///     // 处理成功数据
  ///     handleData(data);
  ///   }
  /// );
  /// ```
  static void handle<T>(
    BaseResponse<T> response,
    void Function(T? data) onSuccess, {
    bool loading = false,
    bool showErrorToast = true,
  }) {
    handleFull(
      api: Future.value(response),
      loading: loading,
      showErrorToast: showErrorToast,
      onSuccess: onSuccess,
    );
  }

  /// 处理网络请求（完整版）
  ///
  /// 参数说明：
  /// * [api] - 网络请求Future，需要返回[BaseResponse]类型
  /// * [loading] - 是否显示加载对话框，默认为false
  /// * [onStart] - 请求开始时的回调，可用于显示加载状态
  /// * [onSuccess] - 请求成功时的回调，参数为响应数据
  /// * [onError] - 请求失败时的回调，包含错误信息和异常对象
  /// * [showErrorToast] - 是否显示错误提示Toast，默认为false
  /// * [showErrorDialog] - 是否显示错误提示对话框，默认为false
  /// * [errorMsg] - 自定义错误提示信息
  ///
  /// 示例：
  /// ```dart
  /// await ApiHandler.handleFull(
  ///   api: api.getData(),
  ///   loading: true,
  ///   showErrorToast: true,
  ///   onSuccess: (data) => handleData(data),
  ///   onError: (msg, err) => handleError(msg),
  /// );
  /// ```
  static Future<void> handleFull<T>({
    required Future<BaseResponse<T>> api,
    bool loading = false,
    void Function()? onStart,
    void Function(T? data)? onSuccess,
    void Function(String message, dynamic error)? onError,
    bool showErrorToast = false,
    bool showErrorDialog = false,
    String? errorMsg,
  }) async {
    try {
      if (loading) {
        LoadingDialog.show();
      }
      onStart?.call();

      final response = await api;

      if (CommonUtil.isSuccess(
        response,
        toast: showErrorToast,
        dialog: showErrorDialog,
        msg: errorMsg,
      )) {
        onSuccess?.call(response.data);
      } else {
        final message = errorMsg ?? response.message ?? "未知错误";
        onError?.call(message, null);
      }
    } catch (e, stackTrace) {
      // 使用ErrorFormatter获取格式化的错误信息
      final formattedError = ErrorFormatter.formatError(e, stackTrace);
      onError?.call(formattedError, stackTrace);

      if (showErrorToast || showErrorDialog) {
        CommonUtil.isError(
          BaseResponse(code: -1, message: formattedError),
          toast: showErrorToast,
          dialog: showErrorDialog,
          msg: errorMsg,
        );
      }
    } finally {
      if (loading) {
        LoadingDialog.hide();
      }
    }
  }
}
