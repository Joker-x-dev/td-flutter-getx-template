// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageRequest _$PageRequestFromJson(Map<String, dynamic> json) => PageRequest(
  page: (json['page'] as num?)?.toInt() ?? 1,
  size: (json['size'] as num?)?.toInt() ?? 10,
);

Map<String, dynamic> _$PageRequestToJson(PageRequest instance) =>
    <String, dynamic>{'page': instance.page, 'size': instance.size};
