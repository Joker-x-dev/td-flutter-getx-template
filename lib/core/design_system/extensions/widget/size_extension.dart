import 'package:flutter/material.dart';

/// Widget 尺寸约束相关扩展
/// 提供宽度、高度、约束、宽高比等尺寸控制方法
extension SizeExtension on Widget {
  /// 设置 Widget 的宽度
  /// 
  /// [width] 宽度值
  /// 
  /// 示例:
  /// ```dart
  /// Container().width(100)
  /// ```
  Widget width(double width) {
    return SizedBox(
      width: width,
      child: this,
    );
  }

  /// 设置 Widget 的高度
  /// 
  /// [height] 高度值
  /// 
  /// 示例:
  /// ```dart
  /// Container().height(100)
  /// ```
  Widget height(double height) {
    return SizedBox(
      height: height,
      child: this,
    );
  }

  /// 同时设置 Widget 的宽度和高度
  /// 
  /// [width] 宽度值
  /// [height] 高度值
  /// 
  /// 示例:
  /// ```dart
  /// Container().size(100, 200)
  /// ```
  Widget size(double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }

  /// 设置 Widget 为正方形
  /// 
  /// [size] 正方形的边长
  /// 
  /// 示例:
  /// ```dart
  /// Container().square(100)
  /// ```
  Widget square(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: this,
    );
  }

  /// 设置 Widget 的约束条件
  /// 
  /// [minWidth] 最小宽度
  /// [maxWidth] 最大宽度
  /// [minHeight] 最小高度
  /// [maxHeight] 最大高度
  /// 
  /// 示例:
  /// ```dart
  /// Container().constrained(
  ///   minWidth: 100,
  ///   maxWidth: 200,
  ///   minHeight: 50,
  ///   maxHeight: 100,
  /// )
  /// ```
  Widget constrained({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minWidth ?? 0.0,
        maxWidth: maxWidth ?? double.infinity,
        minHeight: minHeight ?? 0.0,
        maxHeight: maxHeight ?? double.infinity,
      ),
      child: this,
    );
  }

  /// 设置 Widget 的宽高比
  /// 
  /// [aspectRatio] 宽高比值（宽度/高度）
  /// 
  /// 示例:
  /// ```dart
  /// Container().aspectRatio(16 / 9) // 16:9 宽高比
  /// ```
  Widget aspectRatio(double aspectRatio) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: this,
    );
  }

  /// 限制 Widget 的最大尺寸
  /// 
  /// [maxWidth] 最大宽度
  /// [maxHeight] 最大高度
  /// 
  /// 示例:
  /// ```dart
  /// Container().limitedBox(maxWidth: 200, maxHeight: 100)
  /// ```
  Widget limitedBox({
    double maxWidth = double.infinity,
    double maxHeight = double.infinity,
  }) {
    return LimitedBox(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      child: this,
    );
  }

  /// 设置 Widget 占用可用空间的比例
  /// 
  /// [widthFactor] 宽度因子（0.0 到 1.0）
  /// [heightFactor] 高度因子（0.0 到 1.0）
  /// 
  /// 示例:
  /// ```dart
  /// Container().fractionallySizedBox(
  ///   widthFactor: 0.8, // 占用 80% 宽度
  ///   heightFactor: 0.5, // 占用 50% 高度
  /// )
  /// ```
  Widget fractionallySizedBox({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      alignment: alignment,
      child: this,
    );
  }

  /// 设置 Widget 的最小约束
  /// 
  /// [minWidth] 最小宽度
  /// [minHeight] 最小高度
  /// 
  /// 示例:
  /// ```dart
  /// Container().minSize(width: 100, height: 50)
  /// ```
  Widget minSize({
    double? width,
    double? height,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: width ?? 0.0,
        minHeight: height ?? 0.0,
      ),
      child: this,
    );
  }

  /// 设置 Widget 的最大约束
  /// 
  /// [maxWidth] 最大宽度
  /// [maxHeight] 最大高度
  /// 
  /// 示例:
  /// ```dart
  /// Container().maxSize(width: 200, height: 100)
  /// ```
  Widget maxSize({
    double? width,
    double? height,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: width ?? double.infinity,
        maxHeight: height ?? double.infinity,
      ),
      child: this,
    );
  }

  /// 设置 Widget 的固定约束（强制指定尺寸）
  /// 
  /// [width] 固定宽度
  /// [height] 固定高度
  /// 
  /// 示例:
  /// ```dart
  /// Container().tight(width: 100, height: 50)
  /// ```
  Widget tight({
    double? width,
    double? height,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        width: width,
        height: height,
      ),
      child: this,
    );
  }

  /// 设置 Widget 为无约束（允许无限大小）
  /// 
  /// 示例:
  /// ```dart
  /// Container().unconstrained()
  /// ```
  Widget unconstrained() {
    return UnconstrainedBox(
      child: this,
    );
  }

  /// 设置 Widget 的内在尺寸约束
  /// 
  /// [stepWidth] 宽度步长
  /// [stepHeight] 高度步长
  /// 
  /// 示例:
  /// ```dart
  /// Container().intrinsicSize(stepWidth: 10, stepHeight: 10)
  /// ```
  Widget intrinsicSize({
    double? stepWidth,
    double? stepHeight,
  }) {
    Widget result = this;
    
    if (stepWidth != null) {
      result = IntrinsicWidth(
        stepWidth: stepWidth,
        child: result,
      );
    }
    
    if (stepHeight != null) {
      result = IntrinsicHeight(
        child: result,
      );
    }
    
    return result;
  }

  /// 设置 Widget 的内在宽度
  /// 
  /// [stepWidth] 宽度步长
  /// 
  /// 示例:
  /// ```dart
  /// Container().intrinsicWidth(stepWidth: 10)
  /// ```
  Widget intrinsicWidth({double? stepWidth}) {
    return IntrinsicWidth(
      stepWidth: stepWidth,
      child: this,
    );
  }

  /// 设置 Widget 的内在高度
  /// 
  /// 示例:
  /// ```dart
  /// Container().intrinsicHeight()
  /// ```
  Widget intrinsicHeight() {
    return IntrinsicHeight(
      child: this,
    );
  }
}