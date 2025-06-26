import 'package:json_annotation/json_annotation.dart';

import '../../common/base_entity.dart';

part 'user.g.dart';

/// 用户信息模型
@JsonSerializable()
class User extends BaseEntity {

  /// 登录唯一ID
  final String unionid;

  /// 头像
  final String? avatarUrl;

  /// 昵称
  final String? nickName;

  /// 手机号
  final String? phone;

  /// 性别 0-未知 1-男 2-女
  final int gender;

  /// 状态 0-禁用 1-正常 2-已注销
  final int status;

  /// 登录方式 0-小程序 1-公众号 2-H5
  final String loginType;

  /// 密码
  final String? password;

  const User({
    super.id = 0,
    this.unionid = '',
    this.avatarUrl,
    this.nickName,
    this.phone,
    this.gender = 0,
    this.status = 1,
    this.loginType = '0',
    this.password,
    super.createTime,
    super.updateTime,
  });

  /// 从 JSON 创建实例
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// 转换为 JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);
} 