import 'package:json_annotation/json_annotation.dart';

import '../../common/base_entity.dart';
import 'goods_spec.dart';

part 'goods.g.dart';

/// 商品模型
@JsonSerializable()
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

  /// 从 JSON 创建实例
  factory Goods.fromJson(Map<String, dynamic> json) => _$GoodsFromJson(json);

  /// 转换为 JSON
  Map<String, dynamic> toJson() => _$GoodsToJson(this);
}
