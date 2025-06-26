// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseListResponse<T> _$BaseListResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => BaseListResponse<T>(
  list: (json['list'] as List<dynamic>?)?.map(fromJsonT).toList(),
  pagination:
      json['pagination'] == null
          ? null
          : PageMeta.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BaseListResponseToJson<T>(
  BaseListResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'list': instance.list?.map(toJsonT).toList(),
  'pagination': instance.pagination,
};

PageMeta _$PageMetaFromJson(Map<String, dynamic> json) => PageMeta(
  total: (json['total'] as num?)?.toInt(),
  size: (json['size'] as num?)?.toInt(),
  page: (json['page'] as num?)?.toInt(),
);

Map<String, dynamic> _$PageMetaToJson(PageMeta instance) => <String, dynamic>{
  'total': instance.total,
  'size': instance.size,
  'page': instance.page,
};
