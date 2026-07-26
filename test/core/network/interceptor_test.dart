import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/config/app_config.dart';
import 'package:flutter_kit/core/network/exception/error_exception.dart';
import 'package:flutter_kit/core/network/interceptor/interceptor.dart';

import '../../support/test_environment.dart';

/// HTTP 拦截器与统一错误转换测试。
void main() {
  setUpAll(initializeCoreTestEnvironment);
  tearDownAll(resetCoreTestEnvironment);

  group('CustomErrorHandler', () {
    test('按 HTTP 状态码生成统一错误', () {
      expect(_handleStatus(401).code, 401);
      expect(_handleStatus(404).code, 404);
      expect(_handleStatus(500).code, 500);
      expect(_handleStatus(418).code, 418);
      expect(CustomErrorHandler.handle(StateError('unknown')).code, 999);
    });

    test('业务错误使用服务端 code、msg 和默认值', () {
      final BaseError error = CustomErrorHandler.handleBusinessError(
        <String, dynamic>{'code': 400, 'msg': '业务错误'},
      );
      final BaseError fallback = CustomErrorHandler.handleBusinessError(
        <String, dynamic>{},
      );

      expect(error.code, 400);
      expect(error.message, '业务错误');
      expect(fallback.code, -1);
      expect(fallback.message, isNotEmpty);
    });

    test('业务错误兼容 message、字符串 code 和异常字段类型', () {
      final BaseError messageError = CustomErrorHandler.handleBusinessError(
        <String, dynamic>{'code': '422', 'message': '参数无效'},
      );
      final BaseError numericError = CustomErrorHandler.handleBusinessError(
        <String, dynamic>{'code': 401.0, 'message': '认证失效'},
      );
      final BaseError malformed = CustomErrorHandler.handleBusinessError(
        <String, dynamic>{
          'code': <int>[500],
          'msg': 123,
        },
      );

      expect(messageError.code, 422);
      expect(messageError.message, '参数无效');
      expect(numericError.code, 401);
      expect(numericError.message, '认证失效');
      expect(malformed.code, -1);
      expect(malformed.message, isNotEmpty);
    });
  });

  group('HttpInterceptor', () {
    final HttpInterceptor interceptor = HttpInterceptor();

    test('onRequest 原样继续请求', () {
      final _RequestHandler handler = _RequestHandler();
      final RequestOptions options = RequestOptions(path: '/request');

      interceptor.onRequest(options, handler);

      expect(handler.options, same(options));
    });

    test('HTTP 200 和业务成功码继续响应', () {
      final _ResponseHandler handler = _ResponseHandler();
      final Response<dynamic> response = _response(200, <String, dynamic>{
        'code': AppConfig.successCode,
        'msg': 'ok',
      });

      interceptor.onResponse(response, handler);

      expect(handler.response, same(response));
      expect(handler.error, isNull);
    });

    test('非 Map 的 HTTP 200 响应继续传递', () {
      final _ResponseHandler handler = _ResponseHandler();
      final Response<dynamic> response = _response(200, <Object>[1, 2]);

      interceptor.onResponse(response, handler);

      expect(handler.response, same(response));
    });

    test('业务错误和 HTTP 错误均拒绝响应', () {
      final _ResponseHandler businessHandler = _ResponseHandler();
      final _ResponseHandler httpHandler = _ResponseHandler();

      interceptor.onResponse(
        _response(200, <String, dynamic>{'code': 401, 'msg': '失效'}),
        businessHandler,
      );
      interceptor.onResponse(
        _response(500, <String, dynamic>{'code': 500}),
        httpHandler,
      );

      expect(businessHandler.error?.type, DioExceptionType.badResponse);
      expect((businessHandler.error?.error! as BaseError).code, 401);
      expect(httpHandler.error?.type, DioExceptionType.badResponse);
      expect((httpHandler.error?.error! as BaseError).code, 500);
    });

    test('onError 原样继续异常', () {
      final _ErrorHandler handler = _ErrorHandler();
      final DioException error = DioException(
        requestOptions: RequestOptions(path: '/error'),
        type: DioExceptionType.connectionError,
      );

      interceptor.onError(error, handler);

      expect(handler.error, same(error));
    });
  });
}

/// 构造指定 HTTP 状态码的错误。
BaseError _handleStatus(int statusCode) {
  return CustomErrorHandler.handle(
    DioException(
      requestOptions: RequestOptions(path: '/status'),
      response: Response<dynamic>(
        requestOptions: RequestOptions(path: '/status'),
        statusCode: statusCode,
      ),
    ),
  );
}

/// 构造拦截器响应。
Response<dynamic> _response(int statusCode, dynamic data) {
  return Response<dynamic>(
    requestOptions: RequestOptions(path: '/response'),
    statusCode: statusCode,
    data: data,
  );
}

/// 捕获请求继续事件。
class _RequestHandler extends RequestInterceptorHandler {
  /// 捕获的请求参数。
  RequestOptions? options;

  /// 记录请求参数。
  @override
  void next(RequestOptions options) {
    this.options = options;
  }
}

/// 捕获响应继续和拒绝事件。
class _ResponseHandler extends ResponseInterceptorHandler {
  /// 捕获的响应。
  Response<dynamic>? response;

  /// 捕获的异常。
  DioException? error;

  /// 记录响应。
  @override
  void next(Response<dynamic> response) {
    this.response = response;
  }

  /// 记录拒绝异常。
  @override
  void reject(DioException error, [bool? callFollowingErrorInterceptor]) {
    this.error = error;
  }
}

/// 捕获异常继续事件。
class _ErrorHandler extends ErrorInterceptorHandler {
  /// 捕获的异常。
  DioException? error;

  /// 记录异常。
  @override
  void next(DioException error) {
    this.error = error;
  }
}
