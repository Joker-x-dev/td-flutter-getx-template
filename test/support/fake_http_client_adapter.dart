import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Fake HTTP 响应构建器。
typedef FakeHttpResponseBuilder =
    Map<String, Object?> Function(RequestOptions options);

/// 记录请求并返回固定 JSON 的 Dio Adapter。
class FakeHttpClientAdapter implements HttpClientAdapter {
  /// 创建 Fake Dio Adapter。
  ///
  /// [responseBuilder] 根据请求构造响应 JSON。
  FakeHttpClientAdapter(this.responseBuilder);

  /// 响应 JSON 构建器。
  final FakeHttpResponseBuilder responseBuilder;

  /// 最近一次请求。
  RequestOptions? capturedRequest;

  /// Adapter 是否关闭。
  bool isClosed = false;

  /// 返回 Fake HTTP 响应。
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    capturedRequest = options;
    return ResponseBody.fromString(
      jsonEncode(responseBuilder(options)),
      200,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
  }

  /// 关闭 Fake Adapter。
  @override
  void close({bool force = false}) {
    isClosed = true;
  }
}
