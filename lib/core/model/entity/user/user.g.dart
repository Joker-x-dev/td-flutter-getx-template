// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num?)?.toInt() ?? 0,
  unionid: json['unionid'] as String? ?? '',
  avatarUrl: json['avatarUrl'] as String?,
  nickName: json['nickName'] as String?,
  phone: json['phone'] as String?,
  gender: (json['gender'] as num?)?.toInt() ?? 0,
  status: (json['status'] as num?)?.toInt() ?? 1,
  loginType: json['loginType'] as String? ?? '0',
  password: json['password'] as String?,
  createTime: json['createTime'] as String?,
  updateTime: json['updateTime'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'createTime': instance.createTime,
  'updateTime': instance.updateTime,
  'unionid': instance.unionid,
  'avatarUrl': instance.avatarUrl,
  'nickName': instance.nickName,
  'phone': instance.phone,
  'gender': instance.gender,
  'status': instance.status,
  'loginType': instance.loginType,
  'password': instance.password,
};
