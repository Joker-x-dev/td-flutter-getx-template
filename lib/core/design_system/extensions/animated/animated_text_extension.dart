/// 动画文本扩展
/// 提供文本的动画效果支持，包括文本样式、颜色、大小等属性的动画过渡

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Widget 动画文本扩展
/// 
/// 提供便捷的文本动画设置方法，支持文本样式、颜色、大小等属性的动画过渡
extension AnimatedTextExtension on Widget {
  /// 设置动画文本
  /// 
  /// [text] - 文本内容
  /// [duration] - 动画持续时间
  /// [curve] - 动画曲线
  /// [style] - 文本样式
  /// [textAlign] - 文本对齐方式
  /// [maxLines] - 最大行数
  /// [overflow] - 溢出处理
  /// 
  /// 示例：
  /// ```dart
  /// Container().animatedText(
  ///   'Hello World',
  ///   duration: Duration(milliseconds: 500),
  ///   style: TextStyle(fontSize: 18, color: Colors.blue),
  ///   textAlign: TextAlign.center,
  /// )
  /// ```
  Widget animatedText(
    String text, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    String? semanticsLabel,
  }) {
    return _StyledInheritedAnimation(
      animation: _StyledAnimatedModel(
        duration: duration,
        curve: curve,
      ),
      child: _StyledAnimatedTextContainer(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        semanticsLabel: semanticsLabel,
      ),
    );
  }

  /// 设置动画文本颜色
  /// 
  /// [color] - 文本颜色
  /// [duration] - 动画持续时间
  /// [curve] - 动画曲线
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello').animatedTextColor(
  ///   Colors.red,
  ///   duration: Duration(milliseconds: 300),
  /// )
  /// ```
  Widget animatedTextColor(
    Color color, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
  }) {
    return _StyledInheritedAnimation(
      animation: _StyledAnimatedModel(
        duration: duration,
        curve: curve,
      ),
      child: this,
    );
  }

  /// 设置动画文本大小
  /// 
  /// [fontSize] - 文本大小
  /// [duration] - 动画持续时间
  /// [curve] - 动画曲线
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello').animatedTextSize(
  ///   24.0,
  ///   duration: Duration(milliseconds: 400),
  ///   curve: Curves.easeInOut,
  /// )
  /// ```
  Widget animatedTextSize(
    double fontSize, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
  }) {
    return _StyledInheritedAnimation(
      animation: _StyledAnimatedModel(
        duration: duration,
        curve: curve,
      ),
      child: this,
    );
  }

  /// 设置动画文本样式
  /// 
  /// [style] - 文本样式
  /// [duration] - 动画持续时间
  /// [curve] - 动画曲线
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello').animatedTextStyle(
  ///   TextStyle(
  ///     fontSize: 20,
  ///     color: Colors.green,
  ///     fontWeight: FontWeight.bold,
  ///   ),
  ///   duration: Duration(milliseconds: 350),
  /// )
  /// ```
  Widget animatedTextStyle(
    TextStyle style, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
  }) {
    return _StyledInheritedAnimation(
      animation: _StyledAnimatedModel(
        duration: duration,
        curve: curve,
      ),
      child: this,
    );
  }
}

/// 动画模型类，用于存储动画配置
class _StyledAnimatedModel {
  final Duration duration;
  final Curve curve;
  _StyledAnimatedModel({
    required this.duration,
    this.curve = Curves.linear,
  });
}

/// 继承的动画配置 Widget
class _StyledInheritedAnimation extends InheritedWidget {
  final _StyledAnimatedModel? animation;

  _StyledInheritedAnimation({Key? key, this.animation, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_StyledInheritedAnimation oldAnimation) =>
      !(oldAnimation.animation?.duration == animation?.duration &&
          oldAnimation.animation?.curve == animation?.curve);

  static _StyledInheritedAnimation? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_StyledInheritedAnimation>();
}

/// 样式化动画文本容器
/// 继承自 Text，支持动画效果
class _StyledAnimatedTextContainer extends Text {
  final String data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;

  _StyledAnimatedTextContainer(
    this.data, {
    this.locale,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
    this.softWrap,
    this.strutStyle,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textScaleFactor,
    this.textWidthBasis,
  }) : super(
          data,
          locale: locale,
          maxLines: maxLines,
          overflow: overflow,
          semanticsLabel: semanticsLabel,
          softWrap: softWrap,
          strutStyle: strutStyle,
          style: style,
          textAlign: textAlign,
          textDirection: textDirection,
          textScaleFactor: textScaleFactor,
          textWidthBasis: textWidthBasis,
        );

  @override
  Widget build(BuildContext context) {
    _StyledAnimatedModel? animation = _StyledInheritedAnimation.of(context)?.animation;
    if (animation == null) {
      return super.build(context);
    }
    return _AnimatedText(
      data,
      duration: animation.duration,
      curve: animation.curve,
      locale: locale,
      maxLines: maxLines,
      overflow: overflow,
      semanticsLabel: semanticsLabel,
      softWrap: softWrap,
      strutStyle: strutStyle,
      style: style,
      textAlign: textAlign,
      textDirection: textDirection,
      textScaleFactor: textScaleFactor,
      textWidthBasis: textWidthBasis,
    );
  }
}

/// 动画文本 Widget
/// 支持文本样式的动画过渡
class _AnimatedText extends ImplicitlyAnimatedWidget {
  /// 创建一个隐式动画的文本
  ///
  /// [curve] 和 [duration] 参数不能为 null
  _AnimatedText(
    this.data, {
    Key? key,
    this.locale,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
    this.softWrap,
    this.strutStyle,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textScaleFactor,
    this.textWidthBasis,
    Curve curve = Curves.linear,
    required Duration duration,
    VoidCallback? onEnd,
  }) : super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  final String data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;

  @override
  _AnimatedTextState createState() => _AnimatedTextState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('data', data));
    properties.add(DiagnosticsProperty<TextStyle>('style', style));
    properties.add(IntProperty('maxLines', maxLines));
  }
}

/// 动画文本状态类
class _AnimatedTextState extends AnimatedWidgetBaseState<_AnimatedText> {
  Tween<double>? _textScaleFactor;
  Tween<double>? _fontSize;
  Tween<double>? _letterSpacing;
  Tween<double>? _wordSpacing;
  Tween<double>? _height;
  Tween<double>? _decorationThickness;
  IntTween? _maxLines;
  ColorTween? _color;
  ColorTween? _decorationColor;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _textScaleFactor =
        visitor(_textScaleFactor, widget.textScaleFactor, (dynamic value) => Tween<double>(begin: value as double))
            as Tween<double>?;
    _fontSize = visitor(_fontSize, widget.style?.fontSize, (dynamic value) => Tween<double>(begin: value as double))
        as Tween<double>?;
    _letterSpacing =
        visitor(_letterSpacing, widget.style?.letterSpacing, (dynamic value) => Tween<double>(begin: value as double))
            as Tween<double>?;
    _wordSpacing =
        visitor(_wordSpacing, widget.style?.wordSpacing, (dynamic value) => Tween<double>(begin: value as double))
            as Tween<double>?;
    _height = visitor(_height, widget.style?.height, (dynamic value) => Tween<double>(begin: value as double))
        as Tween<double>?;
    _decorationThickness = visitor(
      _decorationThickness,
      widget.style?.decorationThickness,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
    _maxLines = visitor(
      _maxLines,
      widget.maxLines,
      (dynamic value) => IntTween(begin: value as int),
    ) as IntTween?;
    _color = visitor(
      _color,
      widget.style?.color,
      (dynamic value) => ColorTween(begin: value as Color),
    ) as ColorTween?;
    _decorationColor = visitor(
      _decorationColor,
      widget.style?.decorationColor,
      (dynamic value) => ColorTween(begin: value as Color),
    ) as ColorTween?;
  }

  @override
  Widget build(BuildContext context) => Text(
        widget.data,
        style: widget.style?.copyWith(
          fontSize: _fontSize?.evaluate(animation),
          letterSpacing: _letterSpacing?.evaluate(animation),
          wordSpacing: _wordSpacing?.evaluate(animation),
          height: _height?.evaluate(animation),
          decorationThickness: _decorationThickness?.evaluate(animation),
          color: _color?.evaluate(animation),
          decorationColor: _decorationColor?.evaluate(animation),
        ),
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        locale: widget.locale,
        softWrap: widget.softWrap,
        overflow: widget.overflow,
        textScaleFactor: _textScaleFactor?.evaluate(animation),
        maxLines: _maxLines?.evaluate(animation),
        semanticsLabel: widget.semanticsLabel,
        textWidthBasis: widget.textWidthBasis,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<Tween<double>>('fontSize', _fontSize));
    description.add(DiagnosticsProperty<ColorTween>('color', _color));
    description.add(DiagnosticsProperty<IntTween>('maxLines', _maxLines));
  }
}