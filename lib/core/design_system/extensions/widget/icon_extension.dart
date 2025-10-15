import 'package:flutter/material.dart';

/// Icon 图标扩展
/// 提供图标相关的链式调用方法
///
/// @author
extension IconExtension on Icon {
  /// 设置图标大小
  ///
  /// [size] 图标大小
  ///
  /// 示例:
  /// ```dart
  /// Icon(Icons.home).iconSize(24.0)
  /// ```
  Icon iconSize(double size) {
    return Icon(
      icon,
      size: size,
      color: color,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    );
  }

  /// 设置图标颜色
  ///
  /// [iconColor] 图标颜色
  ///
  /// 示例:
  /// ```dart
  /// Icon(Icons.home).iconColor(Colors.blue)
  /// ```
  Icon iconColor(Color iconColor) {
    return Icon(
      icon,
      size: size,
      color: iconColor,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    );
  }

  /// 设置语义标签
  ///
  /// [label] 语义标签文本
  ///
  /// 示例:
  /// ```dart
  /// Icon(Icons.home).withSemanticLabel('首页图标')
  /// ```
  Icon withSemanticLabel(String label) {
    return Icon(
      icon,
      size: size,
      color: color,
      semanticLabel: label,
      textDirection: textDirection,
    );
  }

  /// 设置文本方向
  ///
  /// [direction] 文本方向
  ///
  /// 示例:
  /// ```dart
  /// Icon(Icons.arrow_forward).withTextDirection(TextDirection.rtl)
  /// ```
  Icon withTextDirection(TextDirection direction) {
    return Icon(
      icon,
      size: size,
      color: color,
      semanticLabel: semanticLabel,
      textDirection: direction,
    );
  }

  /// 复制并修改图标属性
  ///
  /// [size] 图标大小
  /// [color] 图标颜色
  /// [semanticLabel] 语义标签
  /// [textDirection] 文本方向
  ///
  /// 示例:
  /// ```dart
  /// Icon(Icons.home).copyWith(
  ///   size: 24.0,
  ///   color: Colors.blue,
  /// )
  /// ```
  Icon copyWith({
    double? size,
    Color? color,
    String? semanticLabel,
    TextDirection? textDirection,
  }) {
    return Icon(
      icon,
      size: size ?? this.size,
      color: color ?? this.color,
      semanticLabel: semanticLabel ?? this.semanticLabel,
      textDirection: textDirection ?? this.textDirection,
    );
  }
}