import 'package:json_annotation/json_annotation.dart';

part 'base_list_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseListResponse<T> {
  final List<T>? records;
  final int? total;
  final int? size;
  final int? current;
  final int? pages;

  BaseListResponse({
    this.records,
    this.total,
    this.size,
    this.current,
    this.pages,
  });

  factory BaseListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BaseListResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(
    Object? Function(T value) toJsonT,
  ) =>
      _$BaseListResponseToJson(this, toJsonT);
}
