import 'package:dio/dio.dart';

import '../../util/log/log_util.dart';
import '../exception/error_exception.dart';

/// 请求拦截
class HttpInterceptor extends Interceptor {
  /// 请求前
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  /// 请求后
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 统一处理响应
    _handleResponse(response);
    return handler.next(response);
  }

  /// 请求出错
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }

  /// 统一返回处理
  void _handleResponse(Response response) {
    // 检查状态码
    if (response.statusCode != 200) {
      final error = CustomErrorHandler.handle(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
        ),
      );
      LogUtil.e('错误代码: ${error.code}, 错误信息: ${error.message}');
    } else {
      final responseData = response.data;
      // 使用 CustomErrorHandler 处理业务错误
      final businessError = CustomErrorHandler.handleBusinessError(
        responseData,
      );
      if (businessError.code == 200) return;
      if (businessError.code == 401) {
        // 401 登录过期等触发
      }
    }
  }
}
