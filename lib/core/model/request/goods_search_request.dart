import 'package:json_annotation/json_annotation.dart';

import 'page_request.dart';

part 'goods_search_request.g.dart';

/// 商品搜索分页请求模型
@JsonSerializable(includeIfNull: false)
class GoodsSearchRequest extends PageRequest {
  /// 商品分类ID列表
  final List<int>? typeId;

  /// 最低价格
  final String? minPrice;

  /// 最高价格
  final String? maxPrice;

  /// 搜索关键词
  final String? keyWord;

  /// 排序字段（如：sold、price等）
  final String? order;

  /// 排序方式："asc"升序，"desc"降序
  final String? sort;

  /// 推荐
  final bool? recommend;

  /// 精选
  final bool? featured;

  const GoodsSearchRequest({
    super.page = 1,
    super.size = 10,
    this.typeId,
    this.minPrice,
    this.maxPrice,
    this.keyWord,
    this.order,
    this.sort,
    this.recommend,
    this.featured,
  });

  /// 从 JSON 创建实例
  factory GoodsSearchRequest.fromJson(Map<String, dynamic> json) =>
      _$GoodsSearchRequestFromJson(json);

  /// 转换为 JSON
  Map<String, dynamic> toJson() => _$GoodsSearchRequestToJson(this);
}
