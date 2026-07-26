import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Widget 文本隐式动画扩展。
extension AnimatedTextExtension on Widget {
  /// 创建支持样式重建补间的文本。
  ///
  /// [text] 文本内容。
  /// [duration] 动画时长。
  /// [curve] 动画曲线。
  /// [style] 目标文本样式。
  /// [textAlign] 文本对齐方式。
  /// [maxLines] 最大行数。
  /// [overflow] 溢出策略。
  /// [semanticsLabel] 语义标签。
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
    final Text source = Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      semanticsLabel: semanticsLabel,
    );
    return _AnimatedExtensionText(
      source: source,
      targetStyle: style,
      duration: duration,
      curve: curve,
    );
  }

  /// 动画化现有 [Text] 的颜色。
  ///
  /// [color] 目标颜色。
  /// [duration] 动画时长。
  /// [curve] 动画曲线。
  ///
  /// 非 [Text] 接收者保持原样返回。
  Widget animatedTextColor(
    Color color, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
  }) {
    if (this case final _AnimatedExtensionText source) {
      final TextStyle targetStyle =
          (source.targetStyle ?? source.source.style ?? const TextStyle())
              .copyWith(color: color);
      return _AnimatedExtensionText(
        key: source.key,
        source: source.source,
        targetStyle: targetStyle,
        duration: duration,
        curve: curve,
      );
    }
    if (this case final Text source) {
      final TextStyle targetStyle = (source.style ?? const TextStyle())
          .copyWith(color: color);
      return _AnimatedExtensionText(
        key: source.key,
        source: source,
        targetStyle: targetStyle,
        duration: duration,
        curve: curve,
      );
    }
    return this;
  }

  /// 动画化现有 [Text] 的字号。
  ///
  /// [fontSize] 目标字号。
  /// [duration] 动画时长。
  /// [curve] 动画曲线。
  ///
  /// 非 [Text] 接收者保持原样返回。
  Widget animatedTextSize(
    double fontSize, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
  }) {
    if (this case final _AnimatedExtensionText source) {
      final TextStyle targetStyle =
          (source.targetStyle ?? source.source.style ?? const TextStyle())
              .copyWith(fontSize: fontSize);
      return _AnimatedExtensionText(
        key: source.key,
        source: source.source,
        targetStyle: targetStyle,
        duration: duration,
        curve: curve,
      );
    }
    if (this case final Text source) {
      final TextStyle targetStyle = (source.style ?? const TextStyle())
          .copyWith(fontSize: fontSize);
      return _AnimatedExtensionText(
        key: source.key,
        source: source,
        targetStyle: targetStyle,
        duration: duration,
        curve: curve,
      );
    }
    return this;
  }

  /// 动画化现有 [Text] 的样式。
  ///
  /// [style] 与原样式合并后的目标样式。
  /// [duration] 动画时长。
  /// [curve] 动画曲线。
  ///
  /// 非 [Text] 接收者保持原样返回。
  Widget animatedTextStyle(
    TextStyle style, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
  }) {
    if (this case final _AnimatedExtensionText source) {
      final TextStyle targetStyle =
          (source.targetStyle ?? source.source.style)?.merge(style) ?? style;
      return _AnimatedExtensionText(
        key: source.key,
        source: source.source,
        targetStyle: targetStyle,
        duration: duration,
        curve: curve,
      );
    }
    if (this case final Text source) {
      final TextStyle targetStyle = source.style?.merge(style) ?? style;
      return _AnimatedExtensionText(
        key: source.key,
        source: source,
        targetStyle: targetStyle,
        duration: duration,
        curve: curve,
      );
    }
    return this;
  }
}

/// 保留 Text 公共字段并补间样式的隐式动画组件。
class _AnimatedExtensionText extends ImplicitlyAnimatedWidget {
  /// 创建文本隐式动画组件。
  const _AnimatedExtensionText({
    super.key,
    required this.source,
    required this.targetStyle,
    required super.duration,
    required super.curve,
  });

  /// 原始文本配置。
  final Text source;

  /// 目标文本样式。
  final TextStyle? targetStyle;

  /// 创建文本动画状态。
  @override
  AnimatedWidgetBaseState<_AnimatedExtensionText> createState() =>
      _AnimatedExtensionTextState();

  /// 输出可诊断的目标属性。
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('data', source.data))
      ..add(DiagnosticsProperty<TextStyle>('style', targetStyle))
      ..add(IntProperty('maxLines', source.maxLines));
  }
}

/// 管理文本样式补间。
class _AnimatedExtensionTextState
    extends AnimatedWidgetBaseState<_AnimatedExtensionText> {
  /// 文本样式补间。
  TextStyleTween? _style;

  /// 更新文本样式补间。
  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _style =
        visitor(
              _style,
              widget.targetStyle,
              (dynamic value) => TextStyleTween(begin: value as TextStyle),
            )
            as TextStyleTween?;
  }

  /// 构建当前补间值对应的文本。
  @override
  Widget build(BuildContext context) {
    return _copyText(widget.source, _style?.evaluate(animation));
  }

  /// 输出补间诊断属性。
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyleTween>('style', _style));
  }
}

/// 复制文本并替换当前动画样式。
///
/// [source] 原始文本配置。
/// [style] 当前动画帧样式。
Text _copyText(Text source, TextStyle? style) {
  final InlineSpan? textSpan = source.textSpan;
  if (textSpan != null) {
    return Text.rich(
      textSpan,
      style: style,
      strutStyle: source.strutStyle,
      textAlign: source.textAlign,
      textDirection: source.textDirection,
      locale: source.locale,
      softWrap: source.softWrap,
      overflow: source.overflow,
      textScaler: source.textScaler,
      maxLines: source.maxLines,
      semanticsLabel: source.semanticsLabel,
      semanticsIdentifier: source.semanticsIdentifier,
      textWidthBasis: source.textWidthBasis,
      textHeightBehavior: source.textHeightBehavior,
      selectionColor: source.selectionColor,
    );
  }
  return Text(
    source.data!,
    style: style,
    strutStyle: source.strutStyle,
    textAlign: source.textAlign,
    textDirection: source.textDirection,
    locale: source.locale,
    softWrap: source.softWrap,
    overflow: source.overflow,
    textScaler: source.textScaler,
    maxLines: source.maxLines,
    semanticsLabel: source.semanticsLabel,
    semanticsIdentifier: source.semanticsIdentifier,
    textWidthBasis: source.textWidthBasis,
    textHeightBehavior: source.textHeightBehavior,
    selectionColor: source.selectionColor,
  );
}
