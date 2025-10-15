import 'package:flutter/material.dart';

/// Widget 裁剪相关扩展
/// 提供基本的裁剪方法
extension ClipExtension on Widget {
  /// 圆角矩形裁剪
  /// 
  /// [borderRadius] 圆角半径
  /// [clipBehavior] 裁剪行为
  /// 
  /// 示例:
  /// ```dart
  /// Container().clipRRect(BorderRadius.circular(10))
  /// ```
  Widget clipRRect(BorderRadius borderRadius, {
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return ClipRRect(
      borderRadius: borderRadius,
      clipBehavior: clipBehavior,
      child: this,
    );
  }

  /// 圆角裁剪（所有角相同半径）
  /// 
  /// [radius] 圆角半径
  /// [clipBehavior] 裁剪行为
  /// 
  /// 示例:
  /// ```dart
  /// Container().clipRadius(10)
  /// ```
  Widget clipRadius(double radius, {
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return clipRRect(
      BorderRadius.circular(radius),
      clipBehavior: clipBehavior,
    );
  }

  /// 圆形裁剪
  /// 
  /// [clipBehavior] 裁剪行为
  /// 
  /// 示例:
  /// ```dart
  /// Container().clipCircle()
  /// ```
  Widget clipCircle({
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return ClipOval(
      clipBehavior: clipBehavior,
      child: this,
    );
  }

  /// 椭圆裁剪
  /// 
  /// [clipBehavior] 裁剪行为
  /// 
  /// 示例:
  /// ```dart
  /// Container().clipOval()
  /// ```
  Widget clipOval({
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return ClipOval(
      clipBehavior: clipBehavior,
      child: this,
    );
  }

  /// 矩形裁剪
  /// 
  /// [clipBehavior] 裁剪行为
  /// 
  /// 示例:
  /// ```dart
  /// Container().clipRect()
  /// ```
  Widget clipRect({
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return ClipRect(
      clipBehavior: clipBehavior,
      child: this,
    );
  }

  /// 自定义路径裁剪
  /// 
  /// [clipper] 自定义裁剪器
  /// [clipBehavior] 裁剪行为
  /// 
  /// 示例:
  /// ```dart
  /// Container().clipPath(
  ///   MyCustomClipper(),
  ///   clipBehavior: Clip.antiAlias,
  /// )
  /// ```
  Widget clipPath(CustomClipper<Path> clipper, {
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return ClipPath(
      clipper: clipper,
      clipBehavior: clipBehavior,
      child: this,
    );
  }

}