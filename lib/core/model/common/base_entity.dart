import 'package:json_annotation/json_annotation.dart';

import 'id.dart';

part 'base_entity.g.dart';

/// 通用基础实体类
@JsonSerializable()
class BaseEntity extends Id {
  /// 创建时间
  final String? createTime;

  /// 更新时间
  final String? updateTime;

  const BaseEntity({
    super.id = 0,
    this.createTime,
    this.updateTime,
  });

  /// 从 JSON 创建实例
  factory BaseEntity.fromJson(Map<String, dynamic> json) =>
      _$BaseEntityFromJson(json);

  /// 转换为 JSON
  Map<String, dynamic> toJson() => _$BaseEntityToJson(this);
} 