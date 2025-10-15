import 'package:flutter/material.dart';
import 'animation_extension.dart';

/// Widget 装饰动画扩展
extension AnimatedDecorationExtension on Widget {
  /// 带动画的边框
  /// 
  /// 为 Widget 添加边框，支持动画效果
  /// 
  /// 参数：
  /// - [color] 边框颜色，默认为 Colors.grey
  /// - [width] 边框宽度，默认为 1.0
  /// - [style] 边框样式，默认为 BorderStyle.solid
  /// - [strokeAlign] 边框对齐方式，默认为 BorderSide.strokeAlignInside
  /// 
  /// 示例：
  /// ```dart
  /// Container()
  ///   .animate(Duration(milliseconds: 300))
  ///   .animatedBorder(color: Colors.blue, width: 2.0)
  /// ```
  /// 
  /// 返回带有边框动画的 Widget
  Widget animatedBorder({
    Color color = Colors.grey,
    double width = 1.0,
    BorderStyle style = BorderStyle.solid,
    double strokeAlign = BorderSide.strokeAlignInside,
  }) {
    final border = Border.all(
      color: color,
      width: width,
      style: style,
      strokeAlign: strokeAlign,
    );
    
    return AnimatedContainer(
      decoration: BoxDecoration(border: border),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: this,
    );
  }
  
  /// 带动画的装饰
  /// 
  /// 为 Widget 添加装饰，支持动画效果
  /// 
  /// 参数：
  /// - [color] 背景颜色
  /// - [gradient] 渐变背景
  /// - [image] 背景图片
  /// - [border] 边框
  /// - [borderRadius] 圆角半径
  /// - [boxShadow] 阴影列表
  /// - [shape] 形状，默认为 BoxShape.rectangle
  /// 
  /// 示例：
  /// ```dart
  /// Container()
  ///   .animate(Duration(milliseconds: 500))
  ///   .animatedDecoration(
  ///     color: Colors.blue,
  ///     borderRadius: BorderRadius.circular(10),
  ///   )
  /// ```
  /// 
  /// 返回带有装饰动画的 Widget
  Widget animatedDecoration({
    Color? color,
    Gradient? gradient,
    DecorationImage? image,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    BoxShape shape = BoxShape.rectangle,
  }) {
    final decoration = BoxDecoration(
      color: color,
      gradient: gradient,
      image: image,
      border: border,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
      shape: shape,
    );
    
    return AnimatedContainer(
      decoration: decoration,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: this,
    );
  }
  
  /// 带动画的圆角矩形裁剪
  /// 
  /// 为 Widget 添加圆角矩形裁剪，支持动画效果
  /// 
  /// 参数：
  /// - [borderRadius] 圆角半径，默认为 BorderRadius.zero
  /// - [clipBehavior] 裁剪行为，默认为 Clip.antiAlias
  /// 
  /// 示例：
  /// ```dart
  /// Image.network('url')
  ///   .animate(Duration(milliseconds: 300))
  ///   .animatedClipRRect(
  ///     borderRadius: BorderRadius.circular(15),
  ///   )
  /// ```
  /// 
  /// 返回带有圆角裁剪动画的 Widget
  Widget animatedClipRRect({
    BorderRadiusGeometry borderRadius = BorderRadius.zero,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return TweenAnimationBuilder<BorderRadiusGeometry>(
      tween: Tween(begin: BorderRadius.zero, end: borderRadius),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return ClipRRect(
          borderRadius: value,
          clipBehavior: clipBehavior,
          child: this,
        );
      },
    );
  }
  
  /// 带动画的矩形裁剪
  /// 
  /// 为 Widget 添加矩形裁剪，支持动画效果
  /// 
  /// 参数：
  /// - [clipper] 自定义裁剪器
  /// - [clipBehavior] 裁剪行为，默认为 Clip.antiAlias
  /// 
  /// 示例：
  /// ```dart
  /// Container()
  ///   .animate(Duration(milliseconds: 300))
  ///   .animatedClipRect()
  /// ```
  /// 
  /// 返回带有矩形裁剪动画的 Widget
  Widget animatedClipRect({
    CustomClipper<Rect>? clipper,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: ClipRect(
        clipper: clipper,
        clipBehavior: clipBehavior,
        child: this,
      ),
    );
  }
  
  /// 带动画的椭圆裁剪
  /// 
  /// 为 Widget 添加椭圆裁剪，支持动画效果
  /// 
  /// 参数：
  /// - [clipper] 自定义裁剪器
  /// - [clipBehavior] 裁剪行为，默认为 Clip.antiAlias
  /// 
  /// 示例：
  /// ```dart
  /// Image.asset('image.png')
  ///   .animate(Duration(milliseconds: 400))
  ///   .animatedClipOval()
  /// ```
  /// 
  /// 返回带有椭圆裁剪动画的 Widget
  Widget animatedClipOval({
    CustomClipper<Rect>? clipper,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: ClipOval(
        clipper: clipper,
        clipBehavior: clipBehavior,
        child: this,
      ),
    );
  }
  
  /// 带动画的路径裁剪
  /// 
  /// 为 Widget 添加路径裁剪，支持动画效果
  /// 
  /// 参数：
  /// - [clipper] 路径裁剪器
  /// - [clipBehavior] 裁剪行为，默认为 Clip.antiAlias
  /// 
  /// 示例：
  /// ```dart
  /// Container()
  ///   .animate(Duration(milliseconds: 500))
  ///   .animatedClipPath(
  ///     clipper: MyCustomClipper(),
  ///   )
  /// ```
  /// 
  /// 返回带有路径裁剪动画的 Widget
  Widget animatedClipPath({
    required CustomClipper<Path> clipper,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: ClipPath(
        clipper: clipper,
        clipBehavior: clipBehavior,
        child: this,
      ),
    );
  }
  
  /// 带动画的阴影
  /// 
  /// 为 Widget 添加阴影效果，支持动画
  /// 
  /// 参数：
  /// - [elevation] 阴影高度，默认为 4.0
  /// - [shadowColor] 阴影颜色，默认为 Colors.black54
  /// - [shape] 形状，默认为 RoundedRectangleBorder()
  /// 
  /// 示例：
  /// ```dart
  /// Container()
  ///   .animate(Duration(milliseconds: 300))
  ///   .animatedElevation(elevation: 8.0)
  /// ```
  /// 
  /// 返回带有阴影动画的 Widget
  Widget animatedElevation({
    double elevation = 4.0,
    Color shadowColor = Colors.black54,
    ShapeBorder shape = const RoundedRectangleBorder(),
  }) {
    return AnimatedPhysicalModel(
      elevation: elevation,
      shadowColor: shadowColor,
      shape: BoxShape.rectangle,
      color: Colors.transparent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: this,
    );
  }
  
  /// 带动画的背景颜色
  /// 
  /// 为 Widget 添加背景颜色，支持动画效果
  /// 
  /// 参数：
  /// - [color] 背景颜色
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello')
  ///   .animate(Duration(milliseconds: 300))
  ///   .animatedBackgroundColor(Colors.blue)
  /// ```
  /// 
  /// 返回带有背景颜色动画的 Widget
  Widget animatedBackgroundColor(
    Color color,
  ) {
    return AnimatedContainer(
      color: color,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: this,
    );
  }
}