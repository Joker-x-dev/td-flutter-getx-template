import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../model/entity/user/user.dart';
import '../../../model/response/base/base_response.dart';

part 'user_api.g.dart';

/// 用户信息相关接口
@RestApi(baseUrl: 'user/info')
abstract class UserApi {
  factory UserApi(Dio dio, {String baseUrl}) = _UserApi;

  /// 用户个人信息
  @GET('/person')
  Future<BaseResponse<User>> getPersonInfo();
}
