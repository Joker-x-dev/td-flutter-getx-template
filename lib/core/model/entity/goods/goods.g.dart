// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Goods _$GoodsFromJson(Map<String, dynamic> json) => Goods(
  id: (json['id'] as num?)?.toInt() ?? 0,
  typeId: (json['typeId'] as num?)?.toInt() ?? 0,
  title: json['title'] as String? ?? '',
  subTitle: json['subTitle'] as String?,
  mainPic: json['mainPic'] as String? ?? '',
  pics: (json['pics'] as List<dynamic>?)?.map((e) => e as String).toList(),
  price: (json['price'] as num?)?.toInt() ?? 0,
  sold: (json['sold'] as num?)?.toInt() ?? 0,
  content: json['content'] as String?,
  contentPics:
      (json['contentPics'] as List<dynamic>?)?.map((e) => e as String).toList(),
  recommend: json['recommend'] as bool? ?? false,
  featured: json['featured'] as bool? ?? false,
  status: (json['status'] as num?)?.toInt() ?? 0,
  sortNum: (json['sortNum'] as num?)?.toInt() ?? 0,
  specs:
      (json['specs'] as List<dynamic>?)
          ?.map((e) => GoodsSpec.fromJson(e as Map<String, dynamic>))
          .toList(),
  createTime: json['createTime'] as String?,
  updateTime: json['updateTime'] as String?,
);

Map<String, dynamic> _$GoodsToJson(Goods instance) => <String, dynamic>{
  'id': instance.id,
  'createTime': instance.createTime,
  'updateTime': instance.updateTime,
  'typeId': instance.typeId,
  'title': instance.title,
  'subTitle': instance.subTitle,
  'mainPic': instance.mainPic,
  'pics': instance.pics,
  'price': instance.price,
  'sold': instance.sold,
  'content': instance.content,
  'contentPics': instance.contentPics,
  'recommend': instance.recommend,
  'featured': instance.featured,
  'status': instance.status,
  'sortNum': instance.sortNum,
  'specs': instance.specs,
};
