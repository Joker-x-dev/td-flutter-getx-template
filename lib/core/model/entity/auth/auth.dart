import 'package:json_annotation/json_annotation.dart';

part 'auth.g.dart';

/// 认证令牌模型
@JsonSerializable()
class Auth {
  /// token
  final String token;

  /// 刷新 token
  final String refreshToken;

  /// token 过期时间(秒)
  final int expire;

  /// 刷新令牌过期时间
  final int refreshExpire;

  const Auth({
    this.token = '',
    this.refreshToken = '',
    this.expire = 0,
    this.refreshExpire = 0,
    int? createdAt,
  });

  /// 从 JSON 创建实例
  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);

  /// 转换为 JSON
  Map<String, dynamic> toJson() => _$AuthToJson(this);
}
