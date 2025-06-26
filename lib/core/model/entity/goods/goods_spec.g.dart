// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods_spec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoodsSpec _$GoodsSpecFromJson(Map<String, dynamic> json) => GoodsSpec(
  id: (json['id'] as num?)?.toInt() ?? 0,
  goodsId: (json['goodsId'] as num?)?.toInt() ?? 0,
  name: json['name'] as String? ?? '',
  price: (json['price'] as num?)?.toInt() ?? 0,
  stock: (json['stock'] as num?)?.toInt() ?? 0,
  sortNum: (json['sortNum'] as num?)?.toInt() ?? 0,
  images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
  createTime: json['createTime'] as String?,
  updateTime: json['updateTime'] as String?,
);

Map<String, dynamic> _$GoodsSpecToJson(GoodsSpec instance) => <String, dynamic>{
  'id': instance.id,
  'goodsId': instance.goodsId,
  'name': instance.name,
  'price': instance.price,
  'stock': instance.stock,
  'sortNum': instance.sortNum,
  'images': instance.images,
  'createTime': instance.createTime,
  'updateTime': instance.updateTime,
};
