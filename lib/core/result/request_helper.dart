import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../model/response/base/base_response.dart';
import '../ui/dialog/loading_dialog.dart';
import '../util/common/common_util.dart';
import '../localization/network/network_keys.dart';
import 'error_formatter.dart';

/// 业务失败标记，用于与网络/解析异常区分
class _BusinessFailure extends Error {
  /// 业务失败提示信息
  final String message;

  /// 创建业务失败异常
  ///
  /// [message] 业务失败提示信息。
  _BusinessFailure(this.message);
}

/// 网络请求链式辅助类
///
/// 统一处理请求生命周期（loading、toast、错误提示）并返回数据或完整响应。
/// 使用方式：
/// ```dart
/// RequestHelper.repository<Goods>(repository.getGoodsInfo(1))
///   .start(() { ... })
///   .loading(true)
///   .toast(true)
///   .execute()
///   .then((data) { ... })
///   .catchError(...);
/// ```
class RequestHelper<T> {
  /// 待执行的网络请求
  final Future<BaseResponse<T>> _promise;

  /// 是否显示加载提示
  final bool _loading;

  /// 是否使用 Toast 展示错误
  final bool _toast;

  /// 是否使用对话框展示错误
  final bool _dialog;

  /// 自定义错误提示信息
  final String? _errorMsg;

  /// 请求开始回调
  final VoidCallback? _onStart;

  /// 请求失败回调
  final void Function(String message, dynamic error)? _onError;

  /// 创建网络请求链式辅助类
  ///
  /// [_promise] 待执行的网络请求。
  /// [loading] 是否显示加载提示。
  /// [toast] 是否使用 Toast 展示错误。
  /// [dialog] 是否使用对话框展示错误。
  /// [errorMsg] 自定义错误提示信息。
  /// [onStart] 请求开始回调。
  /// [onError] 请求失败回调。
  const RequestHelper._(
    this._promise, {
    bool loading = false,
    bool toast = false,
    bool dialog = false,
    String? errorMsg,
    VoidCallback? onStart,
    void Function(String message, dynamic error)? onError,
  }) : _loading = loading,
       _toast = toast,
       _dialog = dialog,
       _errorMsg = errorMsg,
       _onStart = onStart,
       _onError = onError;

  /// 从仓库返回的 [Future<BaseResponse<T>>] 创建请求辅助类
  ///
  /// [promise] 网络请求 promise
  static RequestHelper<T> repository<T>(Future<BaseResponse<T>> promise) =>
      RequestHelper<T>._(promise);

  /// 设置请求开始回调
  ///
  /// [onStart] 请求开始前的回调
  RequestHelper<T> start(VoidCallback? onStart) =>
      _copyWith(onStart: onStart, replaceOnStart: true);

  /// 设置是否显示 loading 对话框
  ///
  /// [show] true 时请求期间显示 loading
  RequestHelper<T> loading(bool show) => _copyWith(loading: show);

  /// 设置是否显示错误 Toast
  ///
  /// [show] true 时失败自动弹出 Toast
  RequestHelper<T> toast(bool show) => _copyWith(toast: show);

  /// 设置是否显示错误对话框
  ///
  /// [show] true 时失败自动弹出对话框
  RequestHelper<T> dialog(bool show) => _copyWith(dialog: show);

  /// 设置自定义错误提示信息
  ///
  /// [msg] 失败时优先展示的提示文本
  RequestHelper<T> errorMsg(String? msg) =>
      _copyWith(errorMsg: msg, replaceErrorMsg: true);

  /// 设置错误回调
  ///
  /// [onError] 请求失败时的回调，参数为格式化后的错误信息和原始异常
  RequestHelper<T> error(
    void Function(String message, dynamic error)? onError,
  ) => _copyWith(onError: onError, replaceOnError: true);

  /// 复制请求辅助配置
  ///
  /// [loading] 新的加载提示配置。
  /// [toast] 新的 Toast 错误提示配置。
  /// [dialog] 新的对话框错误提示配置。
  /// [errorMsg] 新的自定义错误提示信息。
  /// [onStart] 新的请求开始回调。
  /// [onError] 新的请求失败回调。
  /// [replaceErrorMsg] 是否覆盖可空错误文案。
  /// [replaceOnStart] 是否覆盖可空开始回调。
  /// [replaceOnError] 是否覆盖可空错误回调。
  ///
  /// 返回合并配置后的 [RequestHelper]。
  RequestHelper<T> _copyWith({
    bool? loading,
    bool? toast,
    bool? dialog,
    String? errorMsg,
    VoidCallback? onStart,
    void Function(String message, dynamic error)? onError,
    bool replaceErrorMsg = false,
    bool replaceOnStart = false,
    bool replaceOnError = false,
  }) => RequestHelper<T>._(
    _promise,
    loading: loading ?? _loading,
    toast: toast ?? _toast,
    dialog: dialog ?? _dialog,
    errorMsg: replaceErrorMsg ? errorMsg : _errorMsg,
    onStart: replaceOnStart ? onStart : _onStart,
    onError: replaceOnError ? onError : _onError,
  );

  /// 执行请求并返回响应数据
  ///
  /// 请求成功返回 [BaseResponse.data]，失败时抛出异常。
  Future<T?> execute() async => (await _execute()).data;

  /// 执行请求并返回完整响应
  ///
  /// 请求成功返回完整 [BaseResponse]，失败时抛出异常。
  Future<BaseResponse<T>> response() async => _execute();

  /// 执行请求并处理通用生命周期
  ///
  /// 成功返回原始 [BaseResponse]，失败抛出 [_BusinessFailure] 或 [Exception]。
  Future<BaseResponse<T>> _execute() async {
    try {
      if (_loading) {
        LoadingDialog.show();
      }
      _onStart?.call();

      final response = await _promise;

      if (response.isSucceeded) {
        return response;
      }

      final message =
          _errorMsg ?? response.message ?? NetworkKeys.errorBusinessUnknown.tr;
      _onError?.call(message, null);
      _showErrorIfNeeded(message);
      throw _BusinessFailure(message);
    } on _BusinessFailure {
      rethrow;
    } on Object catch (e, stackTrace) {
      final formattedError = ErrorFormatter.formatError(e, stackTrace);
      _onError?.call(formattedError, e);
      _showErrorIfNeeded(formattedError);
      throw Exception(formattedError);
    } finally {
      if (_loading) {
        LoadingDialog.hide();
      }
    }
  }

  /// 按配置展示错误提示
  ///
  /// [message] 待展示的错误信息。
  void _showErrorIfNeeded(String message) {
    if (_toast || _dialog) {
      CommonUtil.isError(
        BaseResponse(code: -1, message: message),
        toast: _toast,
        dialog: _dialog,
        msg: _errorMsg,
      );
    }
  }
}
