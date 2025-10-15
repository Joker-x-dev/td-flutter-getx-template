import 'dart:math';
import 'package:flutter/material.dart';

/// Text Widget 的扩展方法
/// 提供链式调用的文本样式设置方法
/// 提供便捷的文本样式设置和链式调用支持
///
extension TextExtension on Text {
  /// 复制当前 Text 并应用新的属性
  ///
  /// [data] 文本内容
  /// [style] 文本样式
  /// [strutStyle] 支撑样式
  /// [textAlign] 文本对齐方式
  /// [textDirection] 文本方向
  /// [locale] 本地化设置
  /// [softWrap] 是否软换行
  /// [overflow] 溢出处理方式
  /// [textScaler] 文本缩放器
  /// [maxLines] 最大行数
  /// [semanticsLabel] 语义标签
  /// [textWidthBasis] 文本宽度基准
  Text copyWith({
    String? data,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
  }) {
    return Text(
      data ?? this.data ?? "",
      style: style ?? this.style,
      strutStyle: strutStyle ?? this.strutStyle,
      textAlign: textAlign ?? this.textAlign,
      locale: locale ?? this.locale,
      maxLines: maxLines ?? this.maxLines,
      overflow: overflow ?? this.overflow,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      softWrap: softWrap ?? this.softWrap,
      textDirection: textDirection ?? this.textDirection,
      textScaler: textScaler ?? this.textScaler,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
    );
  }

  /// 应用文本样式
  ///
  /// [style] 要应用的文本样式
  /// 返回应用了新样式的 Text Widget
  Text textStyle(TextStyle style) {
    return copyWith(
      style: (this.style ?? const TextStyle()).copyWith(
        background: style.background,
        backgroundColor: style.backgroundColor,
        color: style.color,
        debugLabel: style.debugLabel,
        decoration: style.decoration,
        decorationColor: style.decorationColor,
        decorationStyle: style.decorationStyle,
        decorationThickness: style.decorationThickness,
        fontFamily: style.fontFamily,
        fontFamilyFallback: style.fontFamilyFallback,
        fontFeatures: style.fontFeatures,
        fontSize: style.fontSize,
        fontStyle: style.fontStyle,
        fontWeight: style.fontWeight,
        foreground: style.foreground,
        height: style.height,
        inherit: style.inherit,
        letterSpacing: style.letterSpacing,
        locale: style.locale,
        shadows: style.shadows,
        textBaseline: style.textBaseline,
        wordSpacing: style.wordSpacing,
      ),
    );
  }

  /// 设置文本缩放器
  ///
  /// [scaler] 文本缩放器
  /// 返回应用了缩放器的 Text Widget
  Text textScale(TextScaler scaler) {
    return copyWith(textScaler: scaler);
  }

  /// 设置文本为粗体
  ///
  /// 返回粗体样式的 Text Widget
  Text bold() {
    return copyWith(
      style: (style ?? const TextStyle()).copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// 设置文本为斜体
  ///
  /// 返回斜体样式的 Text Widget
  Text italic() {
    return copyWith(
      style: (style ?? const TextStyle()).copyWith(
        fontStyle: FontStyle.italic,
      ),
    );
  }

  /// 设置字体粗细
  ///
  /// [fontWeight] 字体粗细值
  /// 返回应用了字体粗细的 Text Widget
  Text fontWeight(FontWeight? fontWeight) {
    return copyWith(
      style: (style ?? const TextStyle()).copyWith(
        fontWeight: fontWeight,
      ),
    );
  }

  /// 设置字体大小
  ///
  /// [size] 字体大小
  /// 返回应用了字体大小的 Text Widget
  Text fontSize(double? size) {
    return copyWith(
      style: (style ?? const TextStyle()).copyWith(
        fontSize: size,
      ),
    );
  }

  /// 设置字体家族
  ///
  /// [font] 字体家族名称
  /// 返回应用了字体家族的 Text Widget
  Text fontFamily(String? font) {
    return copyWith(
      style: (style ?? const TextStyle()).copyWith(
        fontFamily: font,
      ),
    );
  }

  /// 设置字母间距
  ///
  /// [space] 字母间距值
  /// 返回应用了字母间距的 Text Widget
  Text letterSpacing(double? space) {
    return copyWith(
      style: (style ?? const TextStyle()).copyWith(
        letterSpacing: space,
      ),
    );
  }

  /// 设置单词间距
  ///
  /// [space] 单词间距值
  /// 返回应用了单词间距的 Text Widget
  Text wordSpacing(double? space) {
    return copyWith(
      style: (style ?? const TextStyle()).copyWith(
        wordSpacing: space,
      ),
    );
  }

  /// 添加文本阴影
  ///
  /// [color] 阴影颜色，默认为半透明黑色
  /// [blurRadius] 模糊半径，默认为 0.0
  /// [offset] 阴影偏移，默认为 Offset.zero
  /// 返回带有阴影效果的 Text Widget
  Text textShadow({
    Color color = const Color(0x33000000),
    double blurRadius = 0.0,
    Offset offset = Offset.zero,
  }) {
    return copyWith(
      style: (style ?? const TextStyle()).copyWith(
        shadows: [
          Shadow(
            color: color,
            blurRadius: blurRadius,
            offset: offset,
          ),
        ],
      ),
    );
  }

  /// 计算阴影透明度曲线
  ///
  /// [x] 输入值
  /// 返回计算后的透明度值
  double _elevationOpacityCurve(double x) {
    return pow(x, 1 / 16) / sqrt(pow(x, 2) + 2) + 0.2;
  }

  /// 添加文本立体阴影效果
  ///
  /// [elevation] 立体高度
  /// [angle] 阴影角度，默认为 0.0
  /// [color] 阴影颜色，默认为半透明黑色
  /// [opacityRatio] 透明度比例，默认为 1.0
  /// 返回带有立体阴影效果的 Text Widget
  Text textElevation(
    double elevation, {
    double angle = 0.0,
    Color color = const Color(0x33000000),
    double opacityRatio = 1.0,
  }) {
    double calculatedOpacity = _elevationOpacityCurve(elevation) * opacityRatio;

    Shadow shadow = Shadow(
      color: color.withValues(alpha: calculatedOpacity),
      blurRadius: elevation,
      offset: Offset(sin(angle) * elevation, cos(angle) * elevation),
    );
    
    return copyWith(
      style: (style ?? const TextStyle()).copyWith(
        shadows: [shadow],
      ),
    );
  }

  /// 设置文本颜色
  ///
  /// [color] 文本颜色
  /// 返回应用了颜色的 Text Widget
  Text textColor(Color? color) {
    return copyWith(
      style: (style ?? const TextStyle()).copyWith(
        color: color,
      ),
    );
  }

  /// 设置文本对齐方式
  ///
  /// [align] 对齐方式
  /// 返回应用了对齐方式的 Text Widget
  Text textAlignment(TextAlign? align) {
    return copyWith(textAlign: align);
  }

  /// 设置文本方向
  ///
  /// [direction] 文本方向
  /// 返回应用了文本方向的 Text Widget
  Text textDirection(TextDirection? direction) {
    return copyWith(textDirection: direction);
  }

  /// 设置文本基线
  ///
  /// [textBaseline] 文本基线
  /// 返回应用了文本基线的 Text Widget
  Text textBaseline(TextBaseline? textBaseline) {
    return copyWith(
      style: (style ?? const TextStyle()).copyWith(
        textBaseline: textBaseline,
      ),
    );
  }

  /// 设置文本宽度基准
  ///
  /// [textWidthBasis] 文本宽度基准
  /// 返回应用了文本宽度基准的 Text Widget
  Text textWidthBasis(TextWidthBasis? textWidthBasis) {
    return copyWith(textWidthBasis: textWidthBasis);
  }
}