import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../env/env.dart';
import '../interceptor/alice_interceptor.dart';
import '../interceptor/interceptor.dart';

/// dio设置
class NetworkModel {
  static final Dio _dio =
      Dio()
        ..interceptors.add(HttpInterceptor())
        // 仅在调试模式下添加调试工具
        ..interceptors.addAll([
          if (kDebugMode) ...[
            AliceInterceptor(),
            PrettyDioLogger(requestHeader: false, requestBody: true),
          ],
        ])
        ..options = BaseOptions(
          baseUrl: Env.getCurrentBaseUrl(),
          connectTimeout: const Duration(milliseconds: 10000),
          receiveTimeout: const Duration(milliseconds: 10000),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );

  static Dio getInstance() {
    return _dio;
  }
}
