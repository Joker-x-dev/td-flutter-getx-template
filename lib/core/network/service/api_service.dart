import 'package:dio/dio.dart';

import '../di/network_model.dart';
import 'auth/auth_api.dart';
import 'goods/goods_api.dart';
import 'user/user_api.dart';

/// api服务
class ApiService {
  static final Dio _dio = NetworkModel.getInstance();

  /// 认证相关 API
  static AuthApi get auth => AuthApi(_dio);

  /// 用户相关 API
  static UserApi get user => UserApi(_dio);

  /// 商品相关 API
  static GoodsApi get goods => GoodsApi(_dio);
}
