import 'package:dio/dio.dart';

import '../di/network_model.dart';

/// api服务
class ApiService {
  static final Dio _dio = NetworkModel.getInstance();

  // static UserApi userApi() => UserApi(_dio);
}
