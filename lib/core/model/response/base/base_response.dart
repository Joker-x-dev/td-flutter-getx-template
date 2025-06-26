import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

/// 解析网络响应
@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> {
  /// 真实数据
  /// 类型是泛型
  final T? data;

  /// 状态码
  /// 等于1000表示成功
  final int code;

  /// 出错的提示信息
  /// 发生了错误不一定有
  final String? message;

  BaseResponse({
    this.data,
    this.code = 1000,
    this.message,
  });

  /// 是否成功
  bool get isSucceeded => code == 1000;

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BaseResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(
    Object? Function(T value) toJsonT,
  ) =>
      _$BaseResponseToJson(this, toJsonT);
}
