// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods_search_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoodsSearchRequest _$GoodsSearchRequestFromJson(Map<String, dynamic> json) =>
    GoodsSearchRequest(
      page: (json['page'] as num?)?.toInt() ?? 1,
      size: (json['size'] as num?)?.toInt() ?? 10,
      typeId:
          (json['typeId'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList(),
      minPrice: json['minPrice'] as String?,
      maxPrice: json['maxPrice'] as String?,
      keyWord: json['keyWord'] as String?,
      order: json['order'] as String?,
      sort: json['sort'] as String?,
      recommend: json['recommend'] as bool?,
      featured: json['featured'] as bool?,
    );

Map<String, dynamic> _$GoodsSearchRequestToJson(GoodsSearchRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
      'size': instance.size,
      if (instance.typeId case final value?) 'typeId': value,
      if (instance.minPrice case final value?) 'minPrice': value,
      if (instance.maxPrice case final value?) 'maxPrice': value,
      if (instance.keyWord case final value?) 'keyWord': value,
      if (instance.order case final value?) 'order': value,
      if (instance.sort case final value?) 'sort': value,
      if (instance.recommend case final value?) 'recommend': value,
      if (instance.featured case final value?) 'featured': value,
    };
