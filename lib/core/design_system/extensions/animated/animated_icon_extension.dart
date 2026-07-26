import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Widget 图标隐式动画扩展。
extension AnimatedIconExtension on Widget {
  /// 创建支持颜色与尺寸重建补间的图标。
  ///
  /// [icon] 图标数据。
  /// [duration] 动画时长。
  /// [curve] 动画曲线。
  /// [color] 目标颜色。
  /// [size] 目标尺寸。
  /// [semanticLabel] 语义标签。
  /// [textDirection] 文本方向。
  Widget animatedIcon(
    IconData icon, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
    Color? color,
    double? size,
    String? semanticLabel,
    TextDirection? textDirection,
  }) {
    final Icon source = Icon(
      icon,
      color: color,
      size: size,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    );
    return _AnimatedExtensionIcon(
      source: source,
      targetColor: color,
      targetSize: size,
      duration: duration,
      curve: curve,
    );
  }

  /// 动画化现有 [Icon] 的颜色。
  ///
  /// [color] 目标颜色。
  /// [duration] 动画时长。
  /// [curve] 动画曲线。
  ///
  /// 非 [Icon] 接收者保持原样返回。
  Widget animatedIconColor(
    Color color, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
  }) {
    if (this case final _AnimatedExtensionIcon source) {
      return _AnimatedExtensionIcon(
        key: source.key,
        source: source.source,
        targetColor: color,
        targetSize: source.targetSize,
        duration: duration,
        curve: curve,
      );
    }
    if (this case final Icon source) {
      return _AnimatedExtensionIcon(
        key: source.key,
        source: source,
        targetColor: color,
        targetSize: source.size,
        duration: duration,
        curve: curve,
      );
    }
    return this;
  }

  /// 动画化现有 [Icon] 的尺寸。
  ///
  /// [size] 目标尺寸。
  /// [duration] 动画时长。
  /// [curve] 动画曲线。
  ///
  /// 非 [Icon] 接收者保持原样返回。
  Widget animatedIconSize(
    double size, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
  }) {
    if (this case final _AnimatedExtensionIcon source) {
      return _AnimatedExtensionIcon(
        key: source.key,
        source: source.source,
        targetColor: source.targetColor,
        targetSize: size,
        duration: duration,
        curve: curve,
      );
    }
    if (this case final Icon source) {
      return _AnimatedExtensionIcon(
        key: source.key,
        source: source,
        targetColor: source.color,
        targetSize: size,
        duration: duration,
        curve: curve,
      );
    }
    return this;
  }
}

/// 保留 Icon 公共字段并补间颜色和尺寸的隐式动画组件。
class _AnimatedExtensionIcon extends ImplicitlyAnimatedWidget {
  /// 创建图标隐式动画组件。
  const _AnimatedExtensionIcon({
    super.key,
    required this.source,
    required this.targetColor,
    required this.targetSize,
    required super.duration,
    required super.curve,
  });

  /// 原始图标配置。
  final Icon source;

  /// 目标颜色。
  final Color? targetColor;

  /// 目标尺寸。
  final double? targetSize;

  /// 创建图标动画状态。
  @override
  AnimatedWidgetBaseState<_AnimatedExtensionIcon> createState() =>
      _AnimatedExtensionIconState();

  /// 输出可诊断的目标属性。
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<IconData>('icon', source.icon))
      ..add(ColorProperty('color', targetColor))
      ..add(DoubleProperty('size', targetSize));
  }
}

/// 管理图标颜色与尺寸补间。
class _AnimatedExtensionIconState
    extends AnimatedWidgetBaseState<_AnimatedExtensionIcon> {
  /// 颜色补间。
  ColorTween? _color;

  /// 尺寸补间。
  Tween<double>? _size;

  /// 更新颜色与尺寸补间。
  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _color =
        visitor(
              _color,
              widget.targetColor,
              (dynamic value) => ColorTween(begin: value as Color),
            )
            as ColorTween?;
    _size =
        visitor(
              _size,
              widget.targetSize,
              (dynamic value) => Tween<double>(begin: value as double),
            )
            as Tween<double>?;
  }

  /// 构建当前补间值对应的图标。
  @override
  Widget build(BuildContext context) {
    final Icon source = widget.source;
    return Icon(
      source.icon,
      size: _size?.evaluate(animation),
      fill: source.fill,
      weight: source.weight,
      grade: source.grade,
      opticalSize: source.opticalSize,
      color: _color?.evaluate(animation),
      shadows: source.shadows,
      semanticLabel: source.semanticLabel,
      textDirection: source.textDirection,
      applyTextScaling: source.applyTextScaling,
      blendMode: source.blendMode,
      fontWeight: source.fontWeight,
    );
  }

  /// 输出补间诊断属性。
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ColorTween>('color', _color))
      ..add(DiagnosticsProperty<Tween<double>>('size', _size));
  }
}
