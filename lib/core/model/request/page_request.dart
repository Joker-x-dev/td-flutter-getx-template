import 'package:json_annotation/json_annotation.dart';

part 'page_request.g.dart';

/// 通用分页请求模型
@JsonSerializable()
class PageRequest {
  /// 页码
  final int page;

  /// 每页大小
  final int size;

  const PageRequest({
    this.page = 1,
    this.size = 10,
  });

  /// 从 JSON 创建实例
  factory PageRequest.fromJson(Map<String, dynamic> json) =>
      _$PageRequestFromJson(json);

  /// 转换为 JSON
  Map<String, dynamic> toJson() => _$PageRequestToJson(this);
}
