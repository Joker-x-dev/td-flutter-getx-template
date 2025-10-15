import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Widget 变换动画扩展
extension AnimatedTransformExtension on Widget {
  /// 带动画的变换矩阵
  /// 
  /// 为 Widget 应用变换矩阵，支持动画效果
  /// 
  /// 参数：
  /// - [transform] 变换矩阵
  /// - [origin] 变换原点
  /// - [alignment] 对齐方式，默认为 Alignment.center
  /// - [transformHitTests] 是否变换命中测试，默认为 true
  /// - [filterQuality] 过滤质量
  /// 
  /// 示例：
  /// ```dart
  /// Container()
  ///   .animate(Duration(milliseconds: 500))
  ///   .animatedTransform(
  ///     transform: Matrix4.rotationZ(0.5),
  ///   )
  /// ```
  /// 
  /// 返回带有变换动画的 Widget
  Widget animatedTransform(
    Matrix4 transform, {
    Offset? origin,
    AlignmentGeometry alignment = Alignment.center,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return TweenAnimationBuilder<Matrix4>(
      tween: Matrix4Tween(begin: Matrix4.identity(), end: transform),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform(
          transform: value,
          origin: origin,
          alignment: alignment,
          transformHitTests: transformHitTests,
          filterQuality: filterQuality,
          child: this,
        );
      },
      child: this,
    );
  }
  
  /// 带动画的缩放
  /// 
  /// 为 Widget 应用缩放变换，支持动画效果
  /// 
  /// 参数：
  /// - [scale] 缩放比例（同时应用于 X 和 Y 轴）
  /// - [scaleX] X 轴缩放比例
  /// - [scaleY] Y 轴缩放比例
  /// - [alignment] 对齐方式，默认为 Alignment.center
  /// - [filterQuality] 过滤质量
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello')
  ///   .animate(Duration(milliseconds: 300))
  ///   .animatedScale(scale: 1.5)
  /// ```
  /// 
  /// 返回带有缩放动画的 Widget
  Widget animatedScale({
    double? scale,
    double? scaleX,
    double? scaleY,
    AlignmentGeometry alignment = Alignment.center,
    FilterQuality? filterQuality,
  }) {
    return AnimatedScale(
      scale: scale ?? 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: alignment as Alignment? ?? Alignment.center,
      filterQuality: filterQuality,
      child: this,
    );
  }
  
  /// 带动画的旋转（弧度）
  /// 
  /// 为 Widget 应用旋转变换，支持动画效果
  /// 
  /// 参数：
  /// - [angle] 旋转角度（弧度）
  /// - [origin] 变换原点
  /// - [alignment] 对齐方式，默认为 Alignment.center
  /// - [transformHitTests] 是否变换命中测试，默认为 true
  /// - [filterQuality] 过滤质量
  /// 
  /// 示例：
  /// ```dart
  /// Icon(Icons.refresh)
  ///   .animate(Duration(milliseconds: 500))
  ///   .animatedRotate(angle: math.pi / 4)
  /// ```
  /// 
  /// 返回带有旋转动画的 Widget
  Widget animatedRotate(
    double angle, {
    Offset? origin,
    AlignmentGeometry alignment = Alignment.center,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: angle),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value,
          origin: origin,
          alignment: alignment,
          transformHitTests: transformHitTests,
          filterQuality: filterQuality,
          child: this,
        );
      },
      child: this,
    );
  }
  
  /// 带动画的度数旋转
  /// 
  /// 为 Widget 应用旋转变换（使用度数），支持动画效果
  /// 
  /// 参数：
  /// - [degrees] 旋转角度（度数）
  /// - [origin] 变换原点
  /// - [alignment] 对齐方式，默认为 Alignment.center
  /// - [transformHitTests] 是否变换命中测试，默认为 true
  /// - [filterQuality] 过滤质量
  /// 
  /// 示例：
  /// ```dart
  /// Container()
  ///   .animate(Duration(milliseconds: 400))
  ///   .animatedRotateDegrees(45)
  /// ```
  /// 
  /// 返回带有旋转动画的 Widget
  Widget animatedRotateDegrees(
    double degrees, {
    Offset? origin,
    AlignmentGeometry alignment = Alignment.center,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return animatedRotate(
      degrees * math.pi / 180,
      origin: origin,
      alignment: alignment,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
    );
  }
  
  /// 带动画的平移
  /// 
  /// 为 Widget 应用平移变换，支持动画效果
  /// 
  /// 参数：
  /// - [offset] 平移偏移量
  /// - [transformHitTests] 是否变换命中测试，默认为 true
  /// - [filterQuality] 过滤质量
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello')
  ///   .animate(Duration(milliseconds: 300))
  ///   .animatedTranslate(Offset(50, 100))
  /// ```
  /// 
  /// 返回带有平移动画的 Widget
  Widget animatedTranslate(
    Offset offset, {
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: Offset.zero, end: offset),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: value,
          transformHitTests: transformHitTests,
          filterQuality: filterQuality,
          child: this,
        );
      },
      child: this,
    );
  }
  
  /// 带动画的 X、Y 坐标平移
  /// 
  /// 为 Widget 应用 X、Y 坐标平移变换，支持动画效果
  /// 
  /// 参数：
  /// - [x] X 轴平移距离，默认为 0.0
  /// - [y] Y 轴平移距离，默认为 0.0
  /// - [transformHitTests] 是否变换命中测试，默认为 true
  /// - [filterQuality] 过滤质量
  /// 
  /// 示例：
  /// ```dart
  /// Container()
  ///   .animate(Duration(milliseconds: 300))
  ///   .animatedTranslateXY(x: 20, y: -30)
  /// ```
  /// 
  /// 返回带有平移动画的 Widget
  Widget animatedTranslateXY({
    double x = 0.0,
    double y = 0.0,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return animatedTranslate(
      Offset(x, y),
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
    );
  }
  
  /// 带动画的 X 轴平移
  /// 
  /// 为 Widget 应用 X 轴平移变换，支持动画效果
  /// 
  /// 参数：
  /// - [distance] X 轴平移距离
  /// - [transformHitTests] 是否变换命中测试，默认为 true
  /// - [filterQuality] 过滤质量
  /// 
  /// 示例：
  /// ```dart
  /// Text('Slide')
  ///   .animate(Duration(milliseconds: 250))
  ///   .animatedTranslateX(100)
  /// ```
  /// 
  /// 返回带有 X 轴平移动画的 Widget
  Widget animatedTranslateX(
    double distance, {
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return animatedTranslate(
      Offset(distance, 0),
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
    );
  }
  
  /// 带动画的 Y 轴平移
  /// 
  /// 为 Widget 应用 Y 轴平移变换，支持动画效果
  /// 
  /// 参数：
  /// - [distance] Y 轴平移距离
  /// - [transformHitTests] 是否变换命中测试，默认为 true
  /// - [filterQuality] 过滤质量
  /// 
  /// 示例：
  /// ```dart
  /// Icon(Icons.arrow_upward)
  ///   .animate(Duration(milliseconds: 200))
  ///   .animatedTranslateY(-50)
  /// ```
  /// 
  /// 返回带有 Y 轴平移动画的 Widget
  Widget animatedTranslateY(
    double distance, {
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    return animatedTranslate(
      Offset(0, distance),
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
    );
  }
  
  /// 带动画的倾斜
  /// 
  /// 为 Widget 应用倾斜变换，支持动画效果
  /// 
  /// 参数：
  /// - [skewX] X 轴倾斜角度（弧度），默认为 0.0
  /// - [skewY] Y 轴倾斜角度（弧度），默认为 0.0
  /// - [origin] 变换原点
  /// - [alignment] 对齐方式，默认为 Alignment.center
  /// - [transformHitTests] 是否变换命中测试，默认为 true
  /// - [filterQuality] 过滤质量
  /// 
  /// 示例：
  /// ```dart
  /// Container()
  ///   .animate(Duration(milliseconds: 400))
  ///   .animatedSkew(skewX: 0.2, skewY: 0.1)
  /// ```
  /// 
  /// 返回带有倾斜动画的 Widget
  Widget animatedSkew({
    double skewX = 0.0,
    double skewY = 0.0,
    Offset? origin,
    AlignmentGeometry alignment = Alignment.center,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
  }) {
    final transform = Matrix4.identity()
      ..setEntry(0, 1, skewX)
      ..setEntry(1, 0, skewY);
    
    return animatedTransform(
      transform,
      origin: origin,
      alignment: alignment,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
    );
  }
  
  /// 带动画的水平翻转
  /// 
  /// 为 Widget 应用水平翻转变换，支持动画效果
  /// 
  /// 参数：
  /// - [alignment] 对齐方式，默认为 Alignment.center
  /// - [filterQuality] 过滤质量
  /// 
  /// 示例：
  /// ```dart
  /// Image.asset('image.png')
  ///   .animate(Duration(milliseconds: 300))
  ///   .animatedFlipHorizontal()
  /// ```
  /// 
  /// 返回带有水平翻转动画的 Widget
  Widget animatedFlipHorizontal({
    AlignmentGeometry alignment = Alignment.center,
    FilterQuality? filterQuality,
  }) {
    return animatedScale(
      scaleX: -1.0,
      scaleY: 1.0,
      alignment: alignment,
      filterQuality: filterQuality,
    );
  }
  
  /// 带动画的垂直翻转
  /// 
  /// 为 Widget 应用垂直翻转变换，支持动画效果
  /// 
  /// 参数：
  /// - [alignment] 对齐方式，默认为 Alignment.center
  /// - [filterQuality] 过滤质量
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello')
  ///   .animate(Duration(milliseconds: 300))
  ///   .animatedFlipVertical()
  /// ```
  /// 
  /// 返回带有垂直翻转动画的 Widget
  Widget animatedFlipVertical({
    AlignmentGeometry alignment = Alignment.center,
    FilterQuality? filterQuality,
  }) {
    return animatedScale(
      scaleX: 1.0,
      scaleY: -1.0,
      alignment: alignment,
      filterQuality: filterQuality,
    );
  }
}