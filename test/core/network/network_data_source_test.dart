import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/config/app_config.dart';
import 'package:flutter_kit/core/model/request/goods_search_request.dart';
import 'package:flutter_kit/core/model/request/login_request.dart';
import 'package:flutter_kit/core/network/datasource/auth/auth_network_data_source_impl.dart';
import 'package:flutter_kit/core/network/datasource/goods/goods_network_data_source_impl.dart';
import 'package:flutter_kit/core/network/datasource/user/user_network_data_source_impl.dart';

import '../../support/fake_http_client_adapter.dart';

/// Retrofit Auth、Goods、User 网络契约测试。
void main() {
  late Dio dio;
  late FakeHttpClientAdapter adapter;
  Map<String, Object?>? forcedResponse;

  setUp(() {
    forcedResponse = null;
    adapter = FakeHttpClientAdapter((RequestOptions options) {
      if (forcedResponse case final Map<String, Object?> response) {
        return response;
      }
      if (options.path.endsWith('/login')) {
        return <String, Object?>{
          'code': AppConfig.successCode,
          'message': 'ok',
          'data': <String, Object?>{
            'token': 'token',
            'refreshToken': 'refresh',
            'expire': 3600,
            'refreshExpire': 7200,
            'createdAt': 1,
          },
        };
      }
      if (options.path.endsWith('/page')) {
        return <String, Object?>{
          'code': AppConfig.successCode,
          'message': 'ok',
          'data': <String, Object?>{
            'list': <Object?>[
              <String, Object?>{'id': 1, 'title': '商品'},
            ],
            'pagination': <String, Object?>{'total': 1, 'size': 20, 'page': 1},
          },
        };
      }
      if (options.path.endsWith('/info') &&
          options.baseUrl.endsWith('goods/info')) {
        return <String, Object?>{
          'code': AppConfig.successCode,
          'message': 'ok',
          'data': <String, Object?>{
            'id': options.queryParameters['id'] ?? 1,
            'title': '商品详情',
          },
        };
      }
      return <String, Object?>{
        'code': AppConfig.successCode,
        'message': 'ok',
        'data': <String, Object?>{'id': 7, 'unionid': 'u7', 'nickName': '用户'},
      };
    });
    dio = Dio(BaseOptions(baseUrl: 'https://example.com/'))
      ..httpClientAdapter = adapter;
  });

  tearDown(() {
    dio.close(force: true);
    expect(adapter.isClosed, isTrue);
  });

  test('认证数据源发送 POST 登录请求和 JSON Body', () async {
    final AuthNetworkDataSourceImpl dataSource = AuthNetworkDataSourceImpl(dio);
    const LoginRequest request = LoginRequest(phone: '138', password: 'pwd');

    final response = await dataSource.loginByPassword(request);

    expect(adapter.capturedRequest?.method, 'POST');
    expect(adapter.capturedRequest?.baseUrl, endsWith('auth'));
    expect(adapter.capturedRequest?.path, '/login');
    expect(adapter.capturedRequest?.data, request.toJson());
    expect(response.data?.token, 'token');
  });

  test('商品数据源发送分页 POST 并解析列表和分页数据', () async {
    final GoodsNetworkDataSourceImpl dataSource = GoodsNetworkDataSourceImpl(
      dio,
    );
    const GoodsSearchRequest request = GoodsSearchRequest(page: 1, size: 20);

    final response = await dataSource.getGoodsPage(request);

    expect(adapter.capturedRequest?.method, 'POST');
    expect(adapter.capturedRequest?.baseUrl, endsWith('goods/info'));
    expect(adapter.capturedRequest?.path, '/page');
    expect(adapter.capturedRequest?.data, request.toJson());
    expect(response.data?.list?.first.id, 1);
    expect(response.data?.pagination?.total, 1);
  });

  test('商品数据源发送详情 GET 和 id Query', () async {
    final GoodsNetworkDataSourceImpl dataSource = GoodsNetworkDataSourceImpl(
      dio,
    );

    final response = await dataSource.getGoodsInfo(42);

    expect(adapter.capturedRequest?.method, 'GET');
    expect(adapter.capturedRequest?.path, '/info');
    expect(adapter.capturedRequest?.queryParameters, <String, Object>{
      'id': 42,
    });
    expect(response.data?.id, 42);
  });

  test('用户数据源发送 GET 并解析用户信息', () async {
    final UserNetworkDataSourceImpl dataSource = UserNetworkDataSourceImpl(dio);

    final response = await dataSource.getPersonInfo();

    expect(adapter.capturedRequest?.method, 'GET');
    expect(adapter.capturedRequest?.baseUrl, endsWith('user'));
    expect(adapter.capturedRequest?.path, '/info');
    expect(response.data?.nickName, '用户');
  });

  test('响应缺少可选数据时保留成功响应并返回空数据', () async {
    forcedResponse = <String, Object?>{
      'code': AppConfig.successCode,
      'message': 'ok',
    };
    final UserNetworkDataSourceImpl dataSource = UserNetworkDataSourceImpl(dio);

    final response = await dataSource.getPersonInfo();

    expect(response.isSucceeded, isTrue);
    expect(response.data, isNull);
  });

  test('响应数据结构错误时抛出解析异常而不伪造模型', () async {
    forcedResponse = <String, Object?>{
      'code': AppConfig.successCode,
      'message': 'ok',
      'data': <Object?>[],
    };
    final UserNetworkDataSourceImpl dataSource = UserNetworkDataSourceImpl(dio);

    await expectLater(dataSource.getPersonInfo(), throwsA(isA<TypeError>()));
  });
}
