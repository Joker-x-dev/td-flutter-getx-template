import 'package:json_annotation/json_annotation.dart';

import '../../common/base_entity.dart';
import 'goods_spec.dart';

part 'goods.g.dart';

/// 商品模型
@JsonSerializable(explicitToJson: true)
class Goods extends BaseEntity {
  /// 类型ID
  final int typeId;

  /// 标题
  final String title;

  /// 副标题
  final String? subTitle;

  /// 主图
  final String mainPic;

  /// 图片
  final List<String>? pics;

  /// 价格
  final int price;

  /// 已售
  final int sold;

  /// 详情富文本(已弃用)
  final String? content;

  /// 详情图片
  final List<String>? contentPics;

  /// 推荐
  final bool recommend;

  /// 精选
  final bool featured;

  /// 状态 0-下架 1-上架
  final int status;

  /// 排序
  final int sortNum;

  /// 规格
  final List<GoodsSpec>? specs;

  /// 创建商品模型
  ///
  /// [id] 商品 ID。
  /// [typeId] 商品分类 ID。
  /// [title] 商品标题。
  /// [subTitle] 可选商品副标题。
  /// [mainPic] 商品主图地址。
  /// [pics] 可选商品图片列表。
  /// [price] 商品价格。
  /// [sold] 商品销量。
  /// [content] 可选详情富文本。
  /// [contentPics] 可选详情图片列表。
  /// [recommend] 是否推荐。
  /// [featured] 是否精选。
  /// [status] 商品状态。
  /// [sortNum] 商品排序值。
  /// [specs] 可选商品规格列表。
  /// [createTime] 可选创建时间。
  /// [updateTime] 可选更新时间。
  const Goods({
    super.id = 0,
    this.typeId = 0,
    this.title = '',
    this.subTitle,
    this.mainPic = '',
    this.pics,
    this.price = 0,
    this.sold = 0,
    this.content,
    this.contentPics,
    this.recommend = false,
    this.featured = false,
    this.status = 0,
    this.sortNum = 0,
    this.specs,
    super.createTime,
    super.updateTime,
  });

  /// 从 JSON 创建商品模型
  ///
  /// [json] 商品 JSON 数据。
  ///
  /// 返回解析后的 [Goods]。
  factory Goods.fromJson(Map<String, dynamic> json) => _$GoodsFromJson(json);

  /// 将商品模型转换为 JSON
  ///
  /// 返回当前商品的 JSON 数据。
  Map<String, dynamic> toJson() => _$GoodsToJson(this);
}
