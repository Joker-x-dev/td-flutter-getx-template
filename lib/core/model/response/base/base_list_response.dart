import 'package:json_annotation/json_annotation.dart';

part 'base_list_response.g.dart';

/// 网络响应分页模型
@JsonSerializable(genericArgumentFactories: true)
class BaseListResponse<T> {
  /// 列表
  final List<T>? list;

  /// 分页数据
  final PageMeta? pagination;

  BaseListResponse({this.list, this.pagination});

  factory BaseListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$BaseListResponseFromJson(json, fromJsonT);

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

  PageMeta({this.total, this.size, this.page});

  factory PageMeta.fromJson(Map<String, dynamic> json) =>
      _$PageMetaFromJson(json);

  Map<String, dynamic> toJson() => _$PageMetaToJson(this);
}
