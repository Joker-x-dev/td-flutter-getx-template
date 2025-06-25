import 'package:alice/alice.dart';
import 'package:alice_dio/alice_dio_adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../application.dart';

/// Alice 网络请求调试拦截器
class AliceInterceptor extends Interceptor {
  static final AliceDioAdapter _aliceDioAdapter = AliceDioAdapter();

  static Alice get _alice => Application.alice;

  AliceInterceptor() {
    if (kDebugMode) {
      _alice.addAdapter(_aliceDioAdapter);
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      _aliceDioAdapter.onRequest(options, handler);
    } else {
      handler.next(options);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _aliceDioAdapter.onResponse(response, handler);
    } else {
      handler.next(response);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      _aliceDioAdapter.onError(err, handler);
    } else {
      handler.next(err);
    }
  }
}
