import 'package:json_annotation/json_annotation.dart';

part 'goods_spec.g.dart';

/// 规格模型
@JsonSerializable()
class GoodsSpec {
  /// ID
  final int id;

  /// 商品ID
  final int goodsId;

  /// 名称
  final String name;

  /// 价格
  final int price;

  /// 库存
  final int stock;

  /// 排序
  final int sortNum;

  /// 图片
  final List<String>? images;

  /// 创建时间
  final String? createTime;

  /// 更新时间
  final String? updateTime;

  const GoodsSpec({
    this.id = 0,
    this.goodsId = 0,
    this.name = '',
    this.price = 0,
    this.stock = 0,
    this.sortNum = 0,
    this.images,
    this.createTime,
    this.updateTime,
  });

  /// 从 JSON 创建实例
  factory GoodsSpec.fromJson(Map<String, dynamic> json) =>
      _$GoodsSpecFromJson(json);

  /// 转换为 JSON
  Map<String, dynamic> toJson() => _$GoodsSpecToJson(this);
}
