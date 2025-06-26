import 'package:json_annotation/json_annotation.dart';

part 'id.g.dart';

/// ID 实体类
@JsonSerializable()
class Id {
  /// ID 值
  final int id;

  const Id({
    this.id = 0,
  });

  /// 从 JSON 创建实例
  factory Id.fromJson(Map<String, dynamic> json) => _$IdFromJson(json);

  /// 转换为 JSON
  Map<String, dynamic> toJson() => _$IdToJson(this);
}
