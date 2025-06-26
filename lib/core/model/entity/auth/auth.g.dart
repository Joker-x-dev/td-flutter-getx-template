// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auth _$AuthFromJson(Map<String, dynamic> json) => Auth(
  token: json['token'] as String? ?? '',
  refreshToken: json['refreshToken'] as String? ?? '',
  expire: (json['expire'] as num?)?.toInt() ?? 0,
  refreshExpire: (json['refreshExpire'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AuthToJson(Auth instance) => <String, dynamic>{
  'token': instance.token,
  'refreshToken': instance.refreshToken,
  'expire': instance.expire,
  'refreshExpire': instance.refreshExpire,
};
