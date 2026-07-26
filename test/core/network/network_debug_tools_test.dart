import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/network/debug/network_debug_tools.dart';

import '../../support/test_environment.dart';

/// 调试网络工具初始化和拦截器配置测试。
void main() {
  setUp(() async {
    await initializeCoreTestEnvironment();
    NetworkDebugTools.resetForTesting();
  });
  tearDown(() async {
    NetworkDebugTools.resetForTesting();
    await resetCoreTestEnvironment();
  });

  test('调试环境初始化幂等并提供 Alice 与日志拦截器', () {
    int configureCount = 0;
    int adapterRegistrationCount = 0;
    NetworkDebugTools.initialize(
      configureForTesting: () => configureCount++,
      registerAdapterForTesting: (_) => adapterRegistrationCount++,
    );
    NetworkDebugTools.initialize(
      configureForTesting: () => configureCount++,
      registerAdapterForTesting: (_) => adapterRegistrationCount++,
    );

    final List<Interceptor> interceptors = NetworkDebugTools.interceptors;
    expect(configureCount, 1);
    expect(adapterRegistrationCount, 1);
    expect(interceptors, hasLength(2));
    expect(interceptors, everyElement(isA<Interceptor>()));
  });

  test('非调试环境不创建网络调试拦截器', () {
    expect(
      NetworkDebugTools.createInterceptorsForTesting(debugMode: false),
      isEmpty,
    );
    expect(
      NetworkDebugTools.createInterceptorsForTesting(debugMode: true),
      hasLength(2),
    );
  });

  test('Alice 拦截器转发请求、响应和错误事件', () {
    final _RecordingInterceptor delegate = _RecordingInterceptor();
    final Interceptor interceptor =
        NetworkDebugTools.createAliceInterceptorForTesting(delegate);
    final RequestOptions options = RequestOptions(
      path: '/debug',
      baseUrl: 'https://example.com',
    );

    expect(
      () => interceptor.onRequest(options, RequestInterceptorHandler()),
      returnsNormally,
    );
    expect(
      () => interceptor.onResponse(
        Response<Object?>(requestOptions: options, data: <String, Object?>{}),
        ResponseInterceptorHandler(),
      ),
      returnsNormally,
    );
    expect(
      () => interceptor.onError(
        DioException(requestOptions: options, message: 'debug'),
        ErrorInterceptorHandler(),
      ),
      returnsNormally,
    );
    expect(delegate.requestCount, 1);
    expect(delegate.responseCount, 1);
    expect(delegate.errorCount, 1);
  });

  test('Alice 未启用时安全透传请求、响应和错误事件', () async {
    final _RecordingInterceptor delegate = _RecordingInterceptor();
    final Interceptor interceptor =
        NetworkDebugTools.createAliceInterceptorForTesting(
          delegate,
          enabled: false,
        );
    final RequestOptions options = RequestOptions(path: '/disabled');
    final RequestInterceptorHandler requestHandler =
        RequestInterceptorHandler();
    final ResponseInterceptorHandler responseHandler =
        ResponseInterceptorHandler();
    final _InspectableErrorInterceptorHandler errorHandler =
        _InspectableErrorInterceptorHandler();
    final Future<void> errorExpectation = expectLater(
      errorHandler.result,
      throwsA(isNotNull),
    );

    interceptor.onRequest(options, requestHandler);
    interceptor.onResponse(
      Response<Object?>(requestOptions: options),
      responseHandler,
    );
    interceptor.onError(
      DioException(requestOptions: options, message: 'disabled'),
      errorHandler,
    );

    expect(requestHandler.isCompleted, isTrue);
    expect(responseHandler.isCompleted, isTrue);
    await errorExpectation;
    expect(errorHandler.isCompleted, isTrue);
    expect(delegate.requestCount, 0);
    expect(delegate.responseCount, 0);
    expect(delegate.errorCount, 0);
  });
}

/// 暴露错误处理结果的测试 Handler。
class _InspectableErrorInterceptorHandler extends ErrorInterceptorHandler {
  /// Dio 错误透传结果。
  Future<Object?> get result => future;
}

/// 记录 Dio 拦截事件的测试转发目标。
class _RecordingInterceptor extends Interceptor {
  /// 请求事件次数。
  int requestCount = 0;

  /// 响应事件次数。
  int responseCount = 0;

  /// 错误事件次数。
  int errorCount = 0;

  /// 记录请求事件。
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    requestCount++;
  }

  /// 记录响应事件。
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    responseCount++;
  }

  /// 记录错误事件。
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    errorCount++;
  }
}
