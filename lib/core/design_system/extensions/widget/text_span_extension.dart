import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// TextSpan 的扩展方法
/// 提供链式调用的文本片段样式设置方法
/// 提供便捷的文本片段样式设置和链式调用支持
///
extension TextSpanExtension on TextSpan {
  /// 复制当前 TextSpan 并应用新的属性
  ///
  /// [style] 文本样式
  /// [recognizer] 手势识别器
  /// [semanticsLabel] 语义标签
  /// 返回新的 TextSpan 实例
  TextSpan copyWith({
    TextStyle? style,
    GestureRecognizer? recognizer,
    String? semanticsLabel,
  }) {
    return TextSpan(
      text: text,
      children: children,
      style: style ?? this.style,
      recognizer: recognizer ?? this.recognizer,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
    );
  }

  /// 应用文本样式
  ///
  /// [style] 要应用的文本样式
  /// 返回应用了新样式的 TextSpan
  TextSpan textStyle(TextStyle style) {
    return copyWith(
      style: this.style?.copyWith(
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
          ) ??
          style,
    );
  }

  /// 设置文本为粗体
  ///
  /// 返回粗体样式的 TextSpan
  TextSpan bold() {
    return copyWith(
      style: (style ?? const TextStyle()).copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// 设置文本为斜体
  ///
  /// 返回斜体样式的 TextSpan
  TextSpan italic() {
    return copyWith(
      style: (style ?? const TextStyle()).copyWith(
        fontStyle: FontStyle.italic,
      ),
    );
  }

  /// 设置字体粗细
  ///
  /// [fontWeight] 字体粗细值
  /// 返回应用了字体粗细的 TextSpan
  TextSpan fontWeight(FontWeight fontWeight) {
    return copyWith(
      style: (style ?? const TextStyle()).copyWith(
        fontWeight: fontWeight,
      ),
    );
  }

  /// 设置字体大小
  ///
  /// [size] 字体大小
  /// 返回应用了字体大小的 TextSpan
  TextSpan fontSize(double size) {
    return copyWith(
      style: (style ?? const TextStyle()).copyWith(
        fontSize: size,
      ),
    );
  }

  /// 设置字体家族
  ///
  /// [font] 字体家族名称
  /// 返回应用了字体家族的 TextSpan
  TextSpan fontFamily(String font) {
    return copyWith(
      style: (style ?? const TextStyle()).copyWith(
        fontFamily: font,
      ),
    );
  }

  /// 设置字母间距
  ///
  /// [space] 字母间距值
  /// 返回应用了字母间距的 TextSpan
  TextSpan letterSpacing(double space) {
    return copyWith(
      style: (style ?? const TextStyle()).copyWith(
        letterSpacing: space,
      ),
    );
  }

  /// 设置单词间距
  ///
  /// [space] 单词间距值
  /// 返回应用了单词间距的 TextSpan
  TextSpan wordSpacing(double space) {
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
  /// 返回带有阴影效果的 TextSpan
  TextSpan textShadow({
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
  /// 返回带有立体阴影效果的 TextSpan
  TextSpan textElevation(
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
  /// 返回应用了颜色的 TextSpan
  TextSpan textColor(Color color) {
    return copyWith(
      style: (style ?? const TextStyle()).copyWith(
        color: color,
      ),
    );
  }

  /// 设置文本基线
  ///
  /// [textBaseline] 文本基线
  /// 返回应用了文本基线的 TextSpan
  TextSpan textBaseline(TextBaseline textBaseline) {
    return copyWith(
      style: (style ?? const TextStyle()).copyWith(
        textBaseline: textBaseline,
      ),
    );
  }
}