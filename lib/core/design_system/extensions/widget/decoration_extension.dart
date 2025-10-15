import 'dart:math';
import 'package:flutter/material.dart';

/// Widget 装饰扩展
/// 
/// 提供便捷的装饰设置方法，包括背景、渐变、圆角、边框、阴影等
extension DecorationExtension on Widget {
  /// 设置背景颜色
  /// 
  /// [color] - 背景颜色
  /// [key] - Widget 的键
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello').backgroundColor(Colors.blue)
  /// ```
  Widget backgroundColor(
    Color color, {
    Key? key,
  }) {
    return DecoratedBox(
      key: key,
      decoration: BoxDecoration(color: color),
      child: this,
    );
  }

  /// 设置背景图片
  /// 
  /// [image] - 背景图片
  /// [key] - Widget 的键
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello').backgroundImage(
  ///   DecorationImage(
  ///     image: AssetImage('assets/bg.jpg'),
  ///     fit: BoxFit.cover,
  ///   ),
  /// )
  /// ```
  Widget backgroundImage(
    DecorationImage image, {
    Key? key,
  }) {
    return DecoratedBox(
      key: key,
      decoration: BoxDecoration(image: image),
      child: this,
    );
  }

  /// 设置背景渐变
  /// 
  /// [gradient] - 渐变对象
  /// [key] - Widget 的键
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello').backgroundGradient(
  ///   LinearGradient(
  ///     colors: [Colors.red, Colors.blue],
  ///   ),
  /// )
  /// ```
  Widget backgroundGradient(
    Gradient gradient, {
    Key? key,
  }) {
    return DecoratedBox(
      key: key,
      decoration: BoxDecoration(gradient: gradient),
      child: this,
    );
  }

  /// 设置线性渐变背景
  /// 
  /// [begin] - 渐变起始位置
  /// [end] - 渐变结束位置
  /// [colors] - 渐变颜色列表
  /// [stops] - 渐变停止点
  /// [tileMode] - 平铺模式
  /// [transform] - 渐变变换
  /// [key] - Widget 的键
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello').backgroundLinearGradient(
  ///   colors: [Colors.red, Colors.blue],
  ///   begin: Alignment.topLeft,
  ///   end: Alignment.bottomRight,
  /// )
  /// ```
  Widget backgroundLinearGradient({
    Key? key,
    AlignmentGeometry begin = Alignment.centerLeft,
    AlignmentGeometry end = Alignment.centerRight,
    required List<Color> colors,
    List<double>? stops,
    TileMode tileMode = TileMode.clamp,
    GradientTransform? transform,
  }) {
    return DecoratedBox(
      key: key,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors,
          stops: stops,
          tileMode: tileMode,
          transform: transform,
        ),
      ),
      child: this,
    );
  }

  /// 设置径向渐变背景
  /// 
  /// [center] - 渐变中心位置
  /// [radius] - 渐变半径
  /// [colors] - 渐变颜色列表
  /// [stops] - 渐变停止点
  /// [tileMode] - 平铺模式
  /// [focal] - 焦点位置
  /// [focalRadius] - 焦点半径
  /// [transform] - 渐变变换
  /// [key] - Widget 的键
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello').backgroundRadialGradient(
  ///   colors: [Colors.red, Colors.blue],
  ///   center: Alignment.center,
  ///   radius: 0.8,
  /// )
  /// ```
  Widget backgroundRadialGradient({
    Key? key,
    AlignmentGeometry center = Alignment.center,
    double radius = 0.5,
    required List<Color> colors,
    List<double>? stops,
    TileMode tileMode = TileMode.clamp,
    AlignmentGeometry? focal,
    double focalRadius = 0.0,
    GradientTransform? transform,
  }) {
    return DecoratedBox(
      key: key,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: center,
          radius: radius,
          colors: colors,
          stops: stops,
          tileMode: tileMode,
          focal: focal,
          focalRadius: focalRadius,
          transform: transform,
        ),
      ),
      child: this,
    );
  }

  /// 设置扫描渐变背景
  /// 
  /// [center] - 渐变中心位置
  /// [startAngle] - 起始角度
  /// [endAngle] - 结束角度
  /// [colors] - 渐变颜色列表
  /// [stops] - 渐变停止点
  /// [tileMode] - 平铺模式
  /// [transform] - 渐变变换
  /// [key] - Widget 的键
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello').backgroundSweepGradient(
  ///   colors: [Colors.red, Colors.blue, Colors.green],
  ///   center: Alignment.center,
  /// )
  /// ```
  Widget backgroundSweepGradient({
    Key? key,
    AlignmentGeometry center = Alignment.center,
    double startAngle = 0.0,
    double endAngle = pi * 2,
    required List<Color> colors,
    List<double>? stops,
    TileMode tileMode = TileMode.clamp,
    GradientTransform? transform,
  }) {
    return DecoratedBox(
      key: key,
      decoration: BoxDecoration(
        gradient: SweepGradient(
          center: center,
          startAngle: startAngle,
          endAngle: endAngle,
          colors: colors,
          stops: stops,
          tileMode: tileMode,
          transform: transform,
        ),
      ),
      child: this,
    );
  }

  /// 设置背景混合模式
  /// 
  /// [blendMode] - 混合模式
  /// [key] - Widget 的键
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello').backgroundBlendMode(BlendMode.multiply)
  /// ```
  Widget backgroundBlendMode(
    BlendMode blendMode, {
    Key? key,
  }) {
    return DecoratedBox(
      key: key,
      decoration: BoxDecoration(backgroundBlendMode: blendMode),
      child: this,
    );
  }

  /// 设置圆角
  /// 
  /// [all] - 所有角的圆角半径
  /// [topLeft] - 左上角圆角半径
  /// [topRight] - 右上角圆角半径
  /// [bottomLeft] - 左下角圆角半径
  /// [bottomRight] - 右下角圆角半径
  /// [key] - Widget 的键
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello')
  ///   .backgroundColor(Colors.blue)
  ///   .borderRadius(all: 8)
  /// ```
  Widget borderRadius({
    Key? key,
    double? all,
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
  }) {
    return DecoratedBox(
      key: key,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft ?? all ?? 0.0),
          topRight: Radius.circular(topRight ?? all ?? 0.0),
          bottomLeft: Radius.circular(bottomLeft ?? all ?? 0.0),
          bottomRight: Radius.circular(bottomRight ?? all ?? 0.0),
        ),
      ),
      child: this,
    );
  }

  /// 设置方向性圆角（支持 RTL 布局）
  /// 
  /// [all] - 所有角的圆角半径
  /// [topStart] - 顶部起始角圆角半径
  /// [topEnd] - 顶部结束角圆角半径
  /// [bottomStart] - 底部起始角圆角半径
  /// [bottomEnd] - 底部结束角圆角半径
  /// [key] - Widget 的键
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello')
  ///   .backgroundColor(Colors.blue)
  ///   .borderRadiusDirectional(all: 8)
  /// ```
  Widget borderRadiusDirectional({
    Key? key,
    double? all,
    double? topStart,
    double? topEnd,
    double? bottomStart,
    double? bottomEnd,
  }) {
    return DecoratedBox(
      key: key,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(topStart ?? all ?? 0.0),
          topEnd: Radius.circular(topEnd ?? all ?? 0.0),
          bottomStart: Radius.circular(bottomStart ?? all ?? 0.0),
          bottomEnd: Radius.circular(bottomEnd ?? all ?? 0.0),
        ),
      ),
      child: this,
    );
  }

  /// 设置边框
  /// 
  /// [all] - 所有边的边框宽度
  /// [left] - 左边框宽度
  /// [right] - 右边框宽度
  /// [top] - 上边框宽度
  /// [bottom] - 下边框宽度
  /// [color] - 边框颜色
  /// [style] - 边框样式
  /// [key] - Widget 的键
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello').border(
  ///   all: 2,
  ///   color: Colors.red,
  ///   style: BorderStyle.solid,
  /// )
  /// ```
  Widget border({
    Key? key,
    double? all,
    double? left,
    double? right,
    double? top,
    double? bottom,
    Color color = const Color(0xFF000000),
    BorderStyle style = BorderStyle.solid,
  }) {
    return DecoratedBox(
      key: key,
      decoration: BoxDecoration(
        border: Border(
          left: (left ?? all) == null
              ? BorderSide.none
              : BorderSide(color: color, width: left ?? all ?? 0, style: style),
          right: (right ?? all) == null
              ? BorderSide.none
              : BorderSide(color: color, width: right ?? all ?? 0, style: style),
          top: (top ?? all) == null
              ? BorderSide.none
              : BorderSide(color: color, width: top ?? all ?? 0, style: style),
          bottom: (bottom ?? all) == null
              ? BorderSide.none
              : BorderSide(color: color, width: bottom ?? all ?? 0, style: style),
        ),
      ),
      child: this,
    );
  }

  /// 设置盒阴影
  /// 
  /// [boxShadow] - 阴影列表
  /// [key] - Widget 的键
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello').boxShadow([
  ///   BoxShadow(
  ///     color: Colors.black26,
  ///     blurRadius: 4,
  ///     offset: Offset(0, 2),
  ///   ),
  /// ])
  /// ```
  Widget boxShadow(
    List<BoxShadow> boxShadow, {
    Key? key,
  }) {
    return DecoratedBox(
      key: key,
      decoration: BoxDecoration(boxShadow: boxShadow),
      child: this,
    );
  }

  /// 设置阴影效果
  /// 
  /// [elevation] - 阴影高度
  /// [borderRadius] - 边框圆角
  /// [shadowColor] - 阴影颜色
  /// [key] - Widget 的键
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello').elevation(
  ///   4,
  ///   borderRadius: BorderRadius.circular(8),
  ///   shadowColor: Colors.black54,
  /// )
  /// ```
  Widget elevation(
    double elevation, {
    Key? key,
    BorderRadiusGeometry borderRadius = BorderRadius.zero,
    Color shadowColor = const Color(0xFF000000),
  }) {
    return Material(
      key: key,
      color: Colors.transparent,
      elevation: elevation,
      borderRadius: borderRadius,
      shadowColor: shadowColor,
      child: this,
    );
  }

  /// 设置拟物化效果
  /// 
  /// [elevation] - 阴影高度
  /// [borderRadius] - 边框圆角
  /// [backgroundColor] - 背景颜色
  /// [curve] - 曲线强度
  /// [key] - Widget 的键
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello').neumorphism(
  ///   elevation: 4,
  ///   borderRadius: BorderRadius.circular(12),
  ///   backgroundColor: Color(0xffEDF1F5),
  /// )
  /// ```
  Widget neumorphism({
    Key? key,
    required double elevation,
    BorderRadius borderRadius = BorderRadius.zero,
    Color backgroundColor = const Color(0xffEDF1F5),
    double curve = 0.0,
  }) {
    double offset = elevation / 2;
    int colorOffset = (40 * curve).toInt();
    
    int adjustColor(int color, int colorOffset) {
      int colorVal = color + colorOffset;
      if (colorVal > 255) return 255;
      if (colorVal < 0) return 0;
      return colorVal;
    }

    return DecoratedBox(
      key: key,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(
              adjustColor((backgroundColor.r * 255.0).round() & 0xff, colorOffset),
              adjustColor((backgroundColor.g * 255.0).round() & 0xff, colorOffset),
              adjustColor((backgroundColor.b * 255.0).round() & 0xff, colorOffset),
              1.0,
            ),
            Color.fromRGBO(
              adjustColor((backgroundColor.r * 255.0).round() & 0xff, -colorOffset),
              adjustColor((backgroundColor.g * 255.0).round() & 0xff, -colorOffset),
              adjustColor((backgroundColor.b * 255.0).round() & 0xff, -colorOffset),
              1.0,
            ),
          ],
        ),
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            blurRadius: elevation.abs(),
            offset: Offset(-offset, -offset),
          ),
          BoxShadow(
            color: const Color(0xAAA3B1C6),
            blurRadius: elevation.abs(),
            offset: Offset(offset, offset),
          ),
        ],
      ),
      child: this,
    );
  }

  /// 综合装饰设置
  /// 
  /// [color] - 背景颜色
  /// [image] - 背景图片
  /// [border] - 边框
  /// [borderRadius] - 圆角
  /// [boxShadow] - 阴影
  /// [gradient] - 渐变
  /// [backgroundBlendMode] - 背景混合模式
  /// [shape] - 形状
  /// [position] - 装饰位置
  /// [key] - Widget 的键
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello').decorated(
  ///   color: Colors.blue,
  ///   borderRadius: BorderRadius.circular(8),
  ///   boxShadow: [
  ///     BoxShadow(
  ///       color: Colors.black26,
  ///       blurRadius: 4,
  ///       offset: Offset(0, 2),
  ///     ),
  ///   ],
  /// )
  /// ```
  Widget decorated({
    Key? key,
    Color? color,
    DecorationImage? image,
    BoxBorder? border,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
    BlendMode? backgroundBlendMode,
    BoxShape shape = BoxShape.rectangle,
    DecorationPosition position = DecorationPosition.background,
  }) {
    return DecoratedBox(
      key: key,
      decoration: BoxDecoration(
        color: color,
        image: image,
        border: border,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        gradient: gradient,
        backgroundBlendMode: backgroundBlendMode,
        shape: shape,
      ),
      position: position,
      child: this,
    );
  }
}