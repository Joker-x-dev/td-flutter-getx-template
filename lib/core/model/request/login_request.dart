import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

/// 登录请求模型
@JsonSerializable()
class LoginRequest {
  /// 手机号
  final String phone;

  /// 密码
  final String password;

  const LoginRequest({
    this.phone = '',
    this.password = '',
  });

  /// 从 JSON 创建实例
  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  /// 转换为 JSON
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
} 