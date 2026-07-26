import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/env/env.dart';
import 'package:flutter_kit/core/network/interceptor/interceptor.dart';
import 'package:flutter_kit/core/network/provider/dio_provider.dart';

/// DioProvider 单例与基础配置测试。
void main() {
  test('重复获取返回同一 Provider 和 Dio', () {
    final DioProvider first = DioProvider();
    final DioProvider second = DioProvider();

    expect(second, same(first));
    expect(second.dio, same(first.dio));
  });

  test('Dio 使用环境地址、超时和 JSON Headers', () {
    final Dio dio = DioProvider().dio;

    expect(dio.options.baseUrl, Env.baseUrl);
    expect(dio.options.connectTimeout, const Duration(seconds: 10));
    expect(dio.options.receiveTimeout, const Duration(seconds: 10));
    expect(dio.options.headers['Content-Type'], 'application/json');
    expect(dio.options.headers['Accept'], 'application/json');
    expect(dio.interceptors.whereType<HttpInterceptor>(), hasLength(1));
    expect(dio.interceptors.length, greaterThanOrEqualTo(1));
  });
}
