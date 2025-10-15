import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Widget 变换相关扩展
/// 提供旋转、缩放、平移等变换方法
extension TransformExtension on Widget {
  /// 旋转 Widget
  /// 
  /// [angle] 旋转角度（弧度）
  /// [origin] 旋转中心点
  /// [alignment] 对齐方式
  /// [transformHitTests] 是否变换命中测试
  /// [filterQuality] 过滤质量
  /// 
  /// 示例:
  /// ```dart
  /// Container().rotate(math.pi / 4) // 旋转 45 度
  /// ```
  Widget rotate(
    double angle, {
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return Transform.rotate(
      angle: angle,
      origin: origin,
      alignment: alignment,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
      child: this,
    );
  }

  /// 按度数旋转 Widget
  /// 
  /// [degrees] 旋转度数
  /// [origin] 旋转中心点
  /// [alignment] 对齐方式
  /// [transformHitTests] 是否变换命中测试
  /// [filterQuality] 过滤质量
  /// 
  /// 示例:
  /// ```dart
  /// Container().rotateDegrees(45) // 旋转 45 度
  /// ```
  Widget rotateDegrees(
    double degrees, {
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return rotate(
      degrees * math.pi / 180,
      origin: origin,
      alignment: alignment,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
    );
  }

  /// 缩放 Widget
  /// 
  /// [scale] 缩放比例
  /// [origin] 缩放中心点
  /// [alignment] 对齐方式
  /// [transformHitTests] 是否变换命中测试
  /// [filterQuality] 过滤质量
  /// 
  /// 示例:
  /// ```dart
  /// Container().scale(1.5) // 放大 1.5 倍
  /// ```
  Widget scale(
    double scale, {
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return Transform.scale(
      scale: scale,
      origin: origin,
      alignment: alignment,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
      child: this,
    );
  }

  /// 按 X、Y 轴分别缩放 Widget
  /// 
  /// [scaleX] X 轴缩放比例
  /// [scaleY] Y 轴缩放比例
  /// [origin] 缩放中心点
  /// [alignment] 对齐方式
  /// [transformHitTests] 是否变换命中测试
  /// [filterQuality] 过滤质量
  /// 
  /// 示例:
  /// ```dart
  /// Container().scaleXY(1.5, 0.8) // X 轴放大 1.5 倍，Y 轴缩小到 0.8 倍
  /// ```
  Widget scaleXY(
    double scaleX,
    double scaleY, {
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return Transform(
      transform: Matrix4.diagonal3Values(scaleX, scaleY, 1.0),
      origin: origin,
      alignment: alignment,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
      child: this,
    );
  }

  /// 平移 Widget
  /// 
  /// [offset] 平移偏移量
  /// [transformHitTests] 是否变换命中测试
  /// [filterQuality] 过滤质量
  /// 
  /// 示例:
  /// ```dart
  /// Container().translate(Offset(10, 20))
  /// ```
  Widget translate(
    Offset offset, {
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return Transform.translate(
      offset: offset,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
      child: this,
    );
  }

  /// 按 X、Y 坐标平移 Widget
  /// 
  /// [x] X 轴平移距离
  /// [y] Y 轴平移距离
  /// [transformHitTests] 是否变换命中测试
  /// [filterQuality] 过滤质量
  /// 
  /// 示例:
  /// ```dart
  /// Container().translateXY(10, 20)
  /// ```
  Widget translateXY(
    double x,
    double y, {
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return translate(
      Offset(x, y),
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
    );
  }

  /// 沿 X 轴平移 Widget
  /// 
  /// [x] X 轴平移距离
  /// [transformHitTests] 是否变换命中测试
  /// [filterQuality] 过滤质量
  /// 
  /// 示例:
  /// ```dart
  /// Container().translateX(10)
  /// ```
  Widget translateX(
    double x, {
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return translateXY(
      x,
      0,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
    );
  }

  /// 沿 Y 轴平移 Widget
  /// 
  /// [y] Y 轴平移距离
  /// [transformHitTests] 是否变换命中测试
  /// [filterQuality] 过滤质量
  /// 
  /// 示例:
  /// ```dart
  /// Container().translateY(20)
  /// ```
  Widget translateY(
    double y, {
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return translateXY(
      0,
      y,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
    );
  }

  /// 应用自定义变换矩阵
  /// 
  /// [transform] 变换矩阵
  /// [origin] 变换中心点
  /// [alignment] 对齐方式
  /// [transformHitTests] 是否变换命中测试
  /// [filterQuality] 过滤质量
  /// 
  /// 示例:
  /// ```dart
  /// Container().transform(Matrix4.skewX(0.2))
  /// ```
  Widget transform(
    Matrix4 transform, {
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return Transform(
      transform: transform,
      origin: origin,
      alignment: alignment,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
      child: this,
    );
  }

  /// 倾斜 Widget
  /// 
  /// [skewX] X 轴倾斜角度（弧度）
  /// [skewY] Y 轴倾斜角度（弧度）
  /// [origin] 变换中心点
  /// [alignment] 对齐方式
  /// [transformHitTests] 是否变换命中测试
  /// [filterQuality] 过滤质量
  /// 
  /// 示例:
  /// ```dart
  /// Container().skew(0.2, 0.1)
  /// ```
  Widget skew(
    double skewX,
    double skewY, {
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return transform(
      Matrix4.skew(skewX, skewY),
      origin: origin,
      alignment: alignment,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
    );
  }

  /// 沿 X 轴倾斜 Widget
  /// 
  /// [skew] X 轴倾斜角度（弧度）
  /// [origin] 变换中心点
  /// [alignment] 对齐方式
  /// [transformHitTests] 是否变换命中测试
  /// [filterQuality] 过滤质量
  /// 
  /// 示例:
  /// ```dart
  /// Container().skewX(0.2)
  /// ```
  Widget skewX(
    double skew, {
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return transform(
      Matrix4.skewX(skew),
      origin: origin,
      alignment: alignment,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
    );
  }

  /// 沿 Y 轴倾斜 Widget
  /// 
  /// [skew] Y 轴倾斜角度（弧度）
  /// [origin] 变换中心点
  /// [alignment] 对齐方式
  /// [transformHitTests] 是否变换命中测试
  /// [filterQuality] 过滤质量
  /// 
  /// 示例:
  /// ```dart
  /// Container().skewY(0.1)
  /// ```
  Widget skewY(
    double skew, {
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return transform(
      Matrix4.skewY(skew),
      origin: origin,
      alignment: alignment,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
    );
  }

  /// 翻转 Widget（水平翻转）
  /// 
  /// [origin] 变换中心点
  /// [alignment] 对齐方式
  /// [transformHitTests] 是否变换命中测试
  /// [filterQuality] 过滤质量
  /// 
  /// 示例:
  /// ```dart
  /// Container().flipHorizontal()
  /// ```
  Widget flipHorizontal({
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return scaleXY(
      -1.0,
      1.0,
      origin: origin,
      alignment: alignment,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
    );
  }

  /// 翻转 Widget（垂直翻转）
  /// 
  /// [origin] 变换中心点
  /// [alignment] 对齐方式
  /// [transformHitTests] 是否变换命中测试
  /// [filterQuality] 过滤质量
  /// 
  /// 示例:
  /// ```dart
  /// Container().flipVertical()
  /// ```
  Widget flipVertical({
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return scaleXY(
      1.0,
      -1.0,
      origin: origin,
      alignment: alignment,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
    );
  }

  /// 组合多种变换
  /// 
  /// [transforms] 变换列表
  /// [origin] 变换中心点
  /// [alignment] 对齐方式
  /// [transformHitTests] 是否变换命中测试
  /// [filterQuality] 过滤质量
  /// 
  /// 示例:
  /// ```dart
  /// Container().multiTransform([
  ///   Matrix4.rotationZ(math.pi / 4),
  ///   Matrix4.diagonal3Values(1.5, 1.5, 1.0),
  /// ])
  /// ```
  Widget multiTransform(
    List<Matrix4> transforms, {
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    Matrix4 combinedTransform = Matrix4.identity();
    for (final transform in transforms) {
      combinedTransform = combinedTransform * transform;
    }
    
    return transform(
      combinedTransform,
      origin: origin,
      alignment: alignment,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
    );
  }
}