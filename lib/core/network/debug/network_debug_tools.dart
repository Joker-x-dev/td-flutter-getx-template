import 'package:alice/alice.dart';
import 'package:alice_dio/alice_dio_adapter.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// 网络调试工具集中管理
///
/// 将 [Alice]、[PrettyDioLogger] 等调试依赖收敛到本文件，
/// 业务代码通过 [NetworkDebugTools.interceptors] 与 [NetworkDebugTools.initialize]
/// 使用，避免直接依赖调试包的具体类型。
///
/// 所有功能仅在 [kDebugMode] 下生效，生产环境返回空拦截器列表。
abstract final class NetworkDebugTools {
  /// Alice Dio 适配器
  static final AliceDioAdapter _aliceDioAdapter = AliceDioAdapter();

  /// Alice Adapter 注册入口
  ///
  /// 方法撕离会持有 Alice 实例，确保调试工具在应用生命周期内持续可用。
  static void Function(AliceDioAdapter)? _adapterRegistrar;

  /// Alice 调试工具是否完成初始化
  static bool _initialized = false;

  /// 初始化 Alice 调试工具
  ///
  /// 需要在 [GetMaterialApp] 构建前调用，以便 Dio 拦截器能正确挂载 Adapter。
  static void initialize({
    @visibleForTesting VoidCallback? configureForTesting,
    @visibleForTesting
    void Function(AliceDioAdapter)? registerAdapterForTesting,
  }) {
    if (!kDebugMode || _initialized) {
      return;
    }

    if (configureForTesting != null) {
      configureForTesting();
      _adapterRegistrar = registerAdapterForTesting;
    } else {
      _adapterRegistrar = (Alice()..setNavigatorKey(Get.key)).addAdapter;
    }
    _initialized = true;
  }

  /// 获取调试模式下需要注入 Dio 的拦截器列表
  ///
  /// 生产环境返回空列表，避免调试代码参与网络请求。
  static List<dio.Interceptor> get interceptors =>
      _createInterceptors(debugMode: kDebugMode);

  /// 创建指定调试模式的测试拦截器列表
  ///
  /// [debugMode] 指定是否启用网络调试能力。
  @visibleForTesting
  static List<dio.Interceptor> createInterceptorsForTesting({
    required bool debugMode,
  }) {
    return _createInterceptors(debugMode: debugMode);
  }

  /// 重置网络调试工具的进程内状态。
  ///
  /// 仅用于隔离单元测试中的初始化场景。
  @visibleForTesting
  static void resetForTesting() {
    _adapterRegistrar = null;
    _initialized = false;
  }

  /// 按调试模式创建 Dio 拦截器列表
  ///
  /// [debugMode] 指定是否启用网络调试能力。
  static List<dio.Interceptor> _createInterceptors({required bool debugMode}) {
    if (!debugMode) {
      return <dio.Interceptor>[];
    }

    return <dio.Interceptor>[
      _AliceInterceptor(),
      PrettyDioLogger(requestHeader: false, requestBody: true),
    ];
  }

  /// 创建可注入转发目标的 Alice 测试拦截器
  ///
  /// [delegate] 接收请求、响应和错误事件的测试转发目标。
  /// [enabled] 指定是否将事件转发给测试目标。
  @visibleForTesting
  static dio.Interceptor createAliceInterceptorForTesting(
    dio.Interceptor delegate, {
    bool enabled = true,
  }) {
    return _AliceInterceptor(delegate: delegate, enabled: enabled);
  }
}

/// Alice Dio 拦截器
///
/// 拦截器在构造时向 Alice 注册 Dio Adapter，实现网络请求在通知栏展示。
class _AliceInterceptor extends dio.Interceptor {
  /// 事件转发目标
  final dio.Interceptor _delegate;

  /// 是否启用 Alice 事件转发
  final bool _enabled;

  /// 创建 Alice Dio 拦截器并注册适配器
  ///
  /// [delegate] 可选事件转发目标。
  /// [enabled] 可选启用状态。
  _AliceInterceptor({dio.Interceptor? delegate, bool? enabled})
    : _delegate = delegate ?? NetworkDebugTools._aliceDioAdapter,
      _enabled = enabled ?? NetworkDebugTools._adapterRegistrar != null {
    if (delegate == null) {
      NetworkDebugTools._adapterRegistrar?.call(
        NetworkDebugTools._aliceDioAdapter,
      );
    }
  }

  /// 将请求事件转发给 Alice 调试适配器
  ///
  /// [options] Dio 请求配置。
  /// [handler] 请求拦截处理器。
  @override
  void onRequest(
    dio.RequestOptions options,
    dio.RequestInterceptorHandler handler,
  ) {
    if (kDebugMode && _enabled) {
      _delegate.onRequest(options, handler);
      return;
    }
    handler.next(options);
  }

  /// 将响应事件转发给 Alice 调试适配器
  ///
  /// [response] Dio 响应数据。
  /// [handler] 响应拦截处理器。
  @override
  void onResponse(
    dio.Response<dynamic> response,
    dio.ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode && _enabled) {
      _delegate.onResponse(response, handler);
      return;
    }
    handler.next(response);
  }

  /// 将错误事件转发给 Alice 调试适配器
  ///
  /// [err] Dio 请求异常。
  /// [handler] 错误拦截处理器。
  @override
  void onError(dio.DioException err, dio.ErrorInterceptorHandler handler) {
    if (kDebugMode && _enabled) {
      _delegate.onError(err, handler);
      return;
    }
    handler.next(err);
  }
}
