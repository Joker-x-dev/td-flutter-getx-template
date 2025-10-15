/// 动画图标扩展
/// 提供图标的动画效果支持，包括颜色和大小的动画过渡

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Widget 动画图标扩展
/// 
/// 提供便捷的图标动画设置方法，支持颜色和大小的动画过渡
extension AnimatedIconExtension on Widget {
  /// 设置动画图标
  /// 
  /// [icon] - 图标数据
  /// [duration] - 动画持续时间
  /// [curve] - 动画曲线
  /// [color] - 图标颜色
  /// [size] - 图标大小
  /// [semanticLabel] - 语义标签
  /// [textDirection] - 文本方向
  /// 
  /// 示例：
  /// ```dart
  /// Container().animatedIcon(
  ///   Icons.favorite,
  ///   duration: Duration(milliseconds: 300),
  ///   color: Colors.red,
  ///   size: 24.0,
  /// )
  /// ```
  Widget animatedIcon(
    IconData icon, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
    Color? color,
    double? size,
    String? semanticLabel,
    TextDirection? textDirection,
  }) {
    return _StyledInheritedAnimation(
      animation: _StyledAnimatedModel(
        duration: duration,
        curve: curve,
      ),
      child: _StyledAnimatedIconContainer(
        icon,
        color: color,
        size: size,
        semanticLabel: semanticLabel,
        textDirection: textDirection,
      ),
    );
  }

  /// 设置动画图标颜色
  /// 
  /// [color] - 图标颜色
  /// [duration] - 动画持续时间
  /// [curve] - 动画曲线
  /// 
  /// 示例：
  /// ```dart
  /// Icon(Icons.star).animatedIconColor(
  ///   Colors.yellow,
  ///   duration: Duration(milliseconds: 200),
  /// )
  /// ```
  Widget animatedIconColor(
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

  /// 设置动画图标大小
  /// 
  /// [size] - 图标大小
  /// [duration] - 动画持续时间
  /// [curve] - 动画曲线
  /// 
  /// 示例：
  /// ```dart
  /// Icon(Icons.home).animatedIconSize(
  ///   32.0,
  ///   duration: Duration(milliseconds: 250),
  ///   curve: Curves.easeInOut,
  /// )
  /// ```
  Widget animatedIconSize(
    double size, {
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
  /// 动画持续时间
  final Duration duration;
  /// 动画曲线
  final Curve curve;
  
  /// 创建动画模型
  /// 
  /// [duration] 动画持续时间
  /// [curve] 动画曲线，默认为线性
  _StyledAnimatedModel({
    required this.duration,
    this.curve = Curves.linear,
  });
}

/// 继承的动画配置 Widget
class _StyledInheritedAnimation extends InheritedWidget {
  /// 动画配置模型
  final _StyledAnimatedModel? animation;

  /// 创建继承的动画配置 Widget
  /// 
  /// [animation] 动画配置模型
  /// [child] 子 Widget
  _StyledInheritedAnimation({Key? key, this.animation, required Widget child})
      : super(key: key, child: child);

  /// 判断是否需要通知依赖的 Widget 更新
  @override
  bool updateShouldNotify(_StyledInheritedAnimation oldAnimation) =>
      !(oldAnimation.animation?.duration == animation?.duration &&
          oldAnimation.animation?.curve == animation?.curve);

  /// 从上下文中获取最近的动画配置
  static _StyledInheritedAnimation? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_StyledInheritedAnimation>();
}

/// 样式化动画图标容器
/// 继承自 Icon，支持动画效果
class _StyledAnimatedIconContainer extends Icon {
  /// 图标数据
  final IconData? icon;
  /// 图标大小
  final double? size;
  /// 图标颜色
  final Color? color;
  /// 语义标签
  final String? semanticLabel;
  /// 文本方向
  final TextDirection? textDirection;

  /// 创建样式化动画图标容器
  /// 
  /// [icon] 图标数据
  /// [color] 图标颜色
  /// [semanticLabel] 语义标签
  /// [size] 图标大小
  /// [textDirection] 文本方向
  _StyledAnimatedIconContainer(
    this.icon, {
    this.color,
    this.semanticLabel,
    this.size,
    this.textDirection,
  }) : super(
          icon,
          color: color,
          semanticLabel: semanticLabel,
          size: size,
          textDirection: textDirection,
        );

  /// 构建 Widget
  @override
  Widget build(BuildContext context) {
    _StyledAnimatedModel? animation =
        _StyledInheritedAnimation.of(context)?.animation;
    if (animation == null) {
      return super.build(context);
    }
    return _AnimatedIcon(
      icon,
      duration: animation.duration,
      curve: animation.curve,
      color: color,
      semanticLabel: semanticLabel,
      size: size,
      textDirection: textDirection,
    );
  }
}

/// 动画图标 Widget
/// 支持颜色和大小的动画过渡
class _AnimatedIcon extends ImplicitlyAnimatedWidget {
  /// 创建一个隐式动画的图标
  ///
  /// [icon] 图标数据
  /// [color] 图标颜色
  /// [semanticLabel] 语义标签
  /// [size] 图标大小
  /// [textDirection] 文本方向
  /// [curve] 动画曲线，默认为线性
  /// [duration] 动画持续时间，不能为 null
  _AnimatedIcon(
    this.icon, {
    Key? key,
    this.color,
    this.semanticLabel,
    this.size,
    this.textDirection,
    Curve curve = Curves.linear,
    required Duration duration,
  }) : super(
          key: key,
          curve: curve,
          duration: duration,
        );

  /// 图标数据
  final IconData? icon;
  /// 图标大小
  final double? size;
  /// 图标颜色
  final Color? color;
  /// 语义标签
  final String? semanticLabel;
  /// 文本方向
  final TextDirection? textDirection;

  /// 创建状态
  @override
  _AnimatedIconState createState() => _AnimatedIconState();

  /// 填充调试属性
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
    properties.add(DoubleProperty('size', size));
    properties.add(ColorProperty('color', color));
  }
}

/// 动画图标状态类
class _AnimatedIconState extends AnimatedWidgetBaseState<_AnimatedIcon> {
  /// 颜色动画补间
  ColorTween? _color;
  /// 大小动画补间
  Tween<double>? _size;

  /// 遍历所有补间动画
  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _color = visitor(
      _color,
      widget.color,
      (dynamic value) => ColorTween(begin: value as Color),
    ) as ColorTween?;
    _size = visitor(
      _size,
      widget.size,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
  }

  /// 构建 Widget
  @override
  Widget build(BuildContext context) {
    return Icon(
      widget.icon,
      semanticLabel: widget.semanticLabel,
      textDirection: widget.textDirection,
      color: _color?.evaluate(animation),
      size: _size?.evaluate(animation),
    );
  }

  /// 填充调试属性
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<ColorTween>('color', _color));
    description.add(DiagnosticsProperty<Tween<double>>('size', _size));
  }
}