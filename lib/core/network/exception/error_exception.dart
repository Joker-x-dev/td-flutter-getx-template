import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../localization/network/network_keys.dart';

/// 统一错误信息
///
/// 保存业务或网络错误码与可展示错误文案。
class BaseError {
  /// 错误码
  final int code;

  /// 错误文案
  final String message;

  /// 创建统一错误信息
  ///
  /// [code] 错误码。
  /// [message] 错误文案。
  BaseError({required this.code, required this.message});
}

/// 自定义错误转换器
///
/// 将 Dio 异常和业务响应转换为统一的 [BaseError]。
class CustomErrorHandler {
  /// 转换网络异常
  ///
  /// [error] 原始异常对象。
  ///
  /// 返回匹配 HTTP 状态码的统一错误信息。
  static BaseError handle(Object error) {
    if (error is DioException) {
      // 处理 HTTP 状态码错误
      switch (error.response?.statusCode) {
        case 401:
          return BaseError(
            code: 401,
            message: NetworkKeys.errorUnauthorized.tr,
          );
        case 404:
          return BaseError(code: 404, message: NetworkKeys.errorNotFound.tr);
        case 500:
          return BaseError(code: 500, message: NetworkKeys.errorServer.tr);
        default:
          return BaseError(
            code: error.response?.statusCode ?? 500,
            message: NetworkKeys.errorUnknown.tr,
          );
      }
    }
    return BaseError(code: 999, message: NetworkKeys.errorUnknown.tr);
  }

  /// 处理业务逻辑错误
  ///
  /// [responseData] 服务端业务响应数据。
  ///
  /// 返回包含业务错误码和错误文案的统一错误信息。
  static BaseError handleBusinessError(Map<String, dynamic> responseData) {
    final dynamic rawCode = responseData['code'];
    final int code = switch (rawCode) {
      int value => value,
      num value => value.toInt(),
      String value => int.tryParse(value) ?? -1,
      _ => -1,
    };
    final dynamic rawMessage = responseData['msg'] ?? responseData['message'];
    final String message = rawMessage is String && rawMessage.isNotEmpty
        ? rawMessage
        : NetworkKeys.errorBusinessUnknown.tr;

    return BaseError(code: code, message: message);
  }
}
