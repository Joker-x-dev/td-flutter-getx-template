import 'package:dio/dio.dart';

class BaseError {
  final int code;
  final String message;

  BaseError({required this.code, required this.message});
}

class CustomErrorHandler {
  static BaseError handle(Object error) {
    if (error is DioException) {
      // 处理 HTTP 状态码错误
      switch (error.response?.statusCode) {
        case 401:
          return BaseError(code: 401, message: '未登录或登录已过期');
        case 404:
          return BaseError(code: 404, message: '请求的资源未找到');
        case 500:
          return BaseError(code: 500, message: '服务器错误');
        default:
          return BaseError(
            code: error.response?.statusCode ?? 500,
            message: '未知错误',
          );
      }
    }
    return BaseError(code: 999, message: '未知错误');
  }

  /// 处理业务逻辑错误
  static BaseError handleBusinessError(Map<String, dynamic> responseData) {
    final int code = responseData['code'] ?? -1; // 获取 code 字段，默认为 -1
    final String message = responseData['msg'] ?? '未知业务错误'; // 获取 msg 字段

    return BaseError(code: code, message: message);
  }
}
