import 'package:flutter/material.dart';

/// Widget 内边距扩展
/// 
/// 提供便捷的内边距设置方法，支持链式调用
/// 使用 'pad' 前缀避免与 其他框架 扩展冲突
extension PaddingExtension on Widget {
  /// 设置内边距
  /// 
  /// [all] - 所有方向的内边距
  /// [horizontal] - 水平方向的内边距（左右）
  /// [vertical] - 垂直方向的内边距（上下）
  /// [top] - 顶部内边距
  /// [bottom] - 底部内边距
  /// [left] - 左侧内边距
  /// [right] - 右侧内边距
  /// [key] - Widget 的键
  /// 
  /// 优先级：具体方向 > horizontal/vertical > all
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello')
  ///   .pad(all: 16)
  ///   .pad(horizontal: 20, vertical: 10)
  ///   .pad(left: 8, top: 12)
  /// ```
  Widget pad({
    Key? key,
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return Padding(
      key: key,
      padding: EdgeInsets.only(
        top: top ?? vertical ?? all ?? 0.0,
        bottom: bottom ?? vertical ?? all ?? 0.0,
        left: left ?? horizontal ?? all ?? 0.0,
        right: right ?? horizontal ?? all ?? 0.0,
      ),
      child: this,
    );
  }

  /// 设置方向性内边距（支持 RTL 布局）
  /// 
  /// [all] - 所有方向的内边距
  /// [horizontal] - 水平方向的内边距（start/end）
  /// [vertical] - 垂直方向的内边距（上下）
  /// [top] - 顶部内边距
  /// [bottom] - 底部内边距
  /// [start] - 起始方向内边距（LTR 为左，RTL 为右）
  /// [end] - 结束方向内边距（LTR 为右，RTL 为左）
  /// [key] - Widget 的键
  /// 
  /// 优先级：具体方向 > horizontal/vertical > all
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello')
  ///   .padDirectional(all: 16)
  ///   .padDirectional(horizontal: 20, vertical: 10)
  ///   .padDirectional(start: 8, top: 12)
  /// ```
  Widget padDirectional({
    Key? key,
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? start,
    double? end,
  }) {
    return Padding(
      key: key,
      padding: EdgeInsetsDirectional.only(
        top: top ?? vertical ?? all ?? 0.0,
        bottom: bottom ?? vertical ?? all ?? 0.0,
        start: start ?? horizontal ?? all ?? 0.0,
        end: end ?? horizontal ?? all ?? 0.0,
      ),
      child: this,
    );
  }

  /// 设置对称内边距（自定义方法，避免与 GetX 扩展冲突）
  /// 
  /// [horizontal] - 水平方向的内边距
  /// [vertical] - 垂直方向的内边距
  /// [key] - Widget 的键
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello').padSymmetric(horizontal: 16, vertical: 8)
  /// ```
  Widget padSymmetric({
    Key? key,
    double horizontal = 0.0,
    double vertical = 0.0,
  }) {
    return Padding(
      key: key,
      padding: EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
      child: this,
    );
  }

  /// 设置所有方向相同的内边距（自定义方法，避免与 GetX 扩展冲突）
  /// 
  /// [value] - 内边距值
  /// [key] - Widget 的键
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello').padAll(16)
  /// ```
  Widget padAll(
    double value, {
    Key? key,
  }) {
    return Padding(
      key: key,
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  /// 仅设置顶部内边距
  /// 
  /// [value] - 内边距值
  /// [key] - Widget 的键
  Widget padTop(
    double value, {
    Key? key,
  }) {
    return Padding(
      key: key,
      padding: EdgeInsets.only(top: value),
      child: this,
    );
  }

  /// 仅设置底部内边距
  /// 
  /// [value] - 内边距值
  /// [key] - Widget 的键
  Widget padBottom(
    double value, {
    Key? key,
  }) {
    return Padding(
      key: key,
      padding: EdgeInsets.only(bottom: value),
      child: this,
    );
  }

  /// 仅设置左侧内边距
  /// 
  /// [value] - 内边距值
  /// [key] - Widget 的键
  Widget padLeft(
    double value, {
    Key? key,
  }) {
    return Padding(
      key: key,
      padding: EdgeInsets.only(left: value),
      child: this,
    );
  }

  /// 仅设置右侧内边距
  /// 
  /// [value] - 内边距值
  /// [key] - Widget 的键
  Widget padRight(
    double value, {
    Key? key,
  }) {
    return Padding(
      key: key,
      padding: EdgeInsets.only(right: value),
      child: this,
    );
  }

  /// 仅设置水平方向内边距
  /// 
  /// [value] - 内边距值
  /// [key] - Widget 的键
  Widget padHorizontal(
    double value, {
    Key? key,
  }) {
    return Padding(
      key: key,
      padding: EdgeInsets.symmetric(horizontal: value),
      child: this,
    );
  }

  /// 仅设置垂直方向内边距
  /// 
  /// [value] - 内边距值
  /// [key] - Widget 的键
  Widget padVertical(
    double value, {
    Key? key,
  }) {
    return Padding(
      key: key,
      padding: EdgeInsets.symmetric(vertical: value),
      child: this,
    );
  }
}