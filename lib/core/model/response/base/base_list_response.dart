import 'package:json_annotation/json_annotation.dart';

part 'base_list_response.g.dart';

/// 网络响应分页模型
@JsonSerializable(genericArgumentFactories: true, explicitToJson: true)
class BaseListResponse<T> {
  /// 列表
  final List<T>? list;

  /// 分页数据
  final PageMeta? pagination;

  /// 创建网络响应分页模型
  ///
  /// [list] 可选数据列表。
  /// [pagination] 可选分页元数据。
  BaseListResponse({this.list, this.pagination});

  /// 从 JSON 创建网络响应分页模型
  ///
  /// [json] 分页响应 JSON 数据。
  /// [fromJsonT] 泛型列表项 JSON 转换函数。
  ///
  /// 返回解析后的 [BaseListResponse]。
  factory BaseListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$BaseListResponseFromJson(json, fromJsonT);

  /// 将网络响应分页模型转换为 JSON
  ///
  /// [toJsonT] 泛型列表项 JSON 转换函数。
  ///
  /// 返回当前分页响应的 JSON 数据。
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BaseListResponseToJson(this, toJsonT);
}

/// 分页模型
@JsonSerializable()
class PageMeta {
  /// 总条数
  final int? total;

  /// 每页显示条数
  final int? size;

  /// 当前页码
  final int? page;

  /// 创建分页元数据
  ///
  /// [total] 可选总记录数。
  /// [size] 可选每页数量。
  /// [page] 可选当前页码。
  PageMeta({this.total, this.size, this.page});

  /// 从 JSON 创建分页元数据
  ///
  /// [json] 分页元数据 JSON。
  ///
  /// 返回解析后的 [PageMeta]。
  factory PageMeta.fromJson(Map<String, dynamic> json) =>
      _$PageMetaFromJson(json);

  /// 将分页元数据转换为 JSON
  ///
  /// 返回当前分页元数据的 JSON 数据。
  Map<String, dynamic> toJson() => _$PageMetaToJson(this);
}
