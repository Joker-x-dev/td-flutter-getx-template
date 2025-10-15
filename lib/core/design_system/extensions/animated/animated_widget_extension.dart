/// 动画 Widget 扩展
/// 提供各种 Widget 的动画效果支持，包括装饰、约束、变换、内边距、边距等属性的动画过渡

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';

/// Widget 动画扩展
/// 
/// 提供便捷的 Widget 动画设置方法，支持装饰、约束、变换等属性的动画过渡
extension AnimatedWidgetExtension on Widget {
  /// 设置动画配置
  /// 
  /// [duration] - 动画持续时间
  /// [curve] - 动画曲线
  /// 
  /// 示例：
  /// ```dart
  /// Container(
  ///   width: 100,
  ///   height: 100,
  ///   color: Colors.blue,
  /// ).animate(
  ///   duration: Duration(milliseconds: 500),
  ///   curve: Curves.easeInOut,
  /// )
  /// ```
  Widget animate({
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

  /// 设置动画装饰
  /// 
  /// [decoration] - 装饰对象
  /// [position] - 装饰位置
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello').animatedDecoration(
  ///   BoxDecoration(
  ///     color: Colors.red,
  ///     borderRadius: BorderRadius.circular(8),
  ///   ),
  /// ).animate(duration: Duration(milliseconds: 300))
  /// ```
  Widget animatedDecoration(
    Decoration decoration, {
    DecorationPosition position = DecorationPosition.background,
  }) {
    return _StyledAnimatedBuilder(
      builder: (animation) => _AnimatedDecorationBox(
        decoration: decoration,
        position: position,
        duration: animation.duration,
        curve: animation.curve,
        child: this,
      ),
    );
  }

  /// 设置动画约束
  /// 
  /// [constraints] - 约束对象
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello').animatedConstraints(
  ///   BoxConstraints(
  ///     minWidth: 100,
  ///     maxWidth: 200,
  ///     minHeight: 50,
  ///     maxHeight: 100,
  ///   ),
  /// ).animate(duration: Duration(milliseconds: 400))
  /// ```
  Widget animatedConstraints(BoxConstraints constraints) {
    return _StyledAnimatedBuilder(
      builder: (animation) => _AnimatedConstrainedBox(
        constraints: constraints,
        duration: animation.duration,
        curve: animation.curve,
        child: this,
      ),
    );
  }

  /// 设置动画变换
  /// 
  /// [transform] - 变换矩阵
  /// [alignment] - 变换对齐方式
  /// [origin] - 变换原点
  /// 
  /// 示例：
  /// ```dart
  /// Container(
  ///   width: 100,
  ///   height: 100,
  ///   color: Colors.green,
  /// ).animatedTransform(
  ///   Matrix4.rotationZ(0.5),
  ///   alignment: Alignment.center,
  /// ).animate(duration: Duration(milliseconds: 600))
  /// ```
  Widget animatedTransform(
    Matrix4 transform, {
    AlignmentGeometry? alignment,
    Offset? origin,
    bool transformHitTests = true,
  }) {
    return _StyledAnimatedBuilder(
      builder: (animation) => _AnimatedTransform(
        transform: transform,
        alignment: alignment,
        origin: origin,
        transformHitTests: transformHitTests,
        duration: animation.duration,
        curve: animation.curve,
        child: this,
      ),
    );
  }

  /// 设置动画内边距
  /// 
  /// [padding] - 内边距
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello').animatedPadding(
  ///   EdgeInsets.all(16.0),
  /// ).animate(duration: Duration(milliseconds: 300))
  /// ```
  Widget animatedPadding(EdgeInsetsGeometry padding) {
    return _StyledAnimatedBuilder(
      builder: (animation) => AnimatedPadding(
        padding: padding,
        duration: animation.duration,
        curve: animation.curve,
        child: this,
      ),
    );
  }

  /// 设置动画外边距
  /// 
  /// [margin] - 外边距
  /// 
  /// 示例：
  /// ```dart
  /// Container(
  ///   width: 50,
  ///   height: 50,
  ///   color: Colors.orange,
  /// ).animatedMargin(
  ///   EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  /// ).animate(duration: Duration(milliseconds: 350))
  /// ```
  Widget animatedMargin(EdgeInsetsGeometry margin) {
    return _StyledAnimatedBuilder(
      builder: (animation) => AnimatedContainer(
        margin: margin,
        duration: animation.duration,
        curve: animation.curve,
        child: this,
      ),
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

/// 动画构建器
class _StyledAnimatedBuilder extends StatelessWidget {
  _StyledAnimatedBuilder({Key? key, required this.builder}) : super(key: key);

  final Widget Function(_StyledAnimatedModel) builder;

  @override
  Widget build(BuildContext context) {
    _StyledAnimatedModel? animation =
        _StyledInheritedAnimation.of(context)?.animation;
    assert(
      animation != null,
      '[styled_widget]: Tried to animate a widget without an animation specified. Define your animation using .animate() as an ancestor of the widget you are trying to animate',
    );
    return builder(animation!);
  }
}

/// 动画装饰盒子
class _AnimatedDecorationBox extends ImplicitlyAnimatedWidget {
  /// [curve] 和 [duration] 参数不能为 null
  _AnimatedDecorationBox({
    Key? key,
    this.decoration,
    this.position = DecorationPosition.background,
    this.child,
    Curve curve = Curves.linear,
    required Duration duration,
    VoidCallback? onEnd,
  })  : assert(decoration == null || decoration.debugAssertIsValid()),
        super(
          key: key,
          curve: curve,
          duration: duration,
          onEnd: onEnd,
        );

  /// 容器包含的子 Widget
  final Widget? child;

  /// 在子 Widget 后面绘制的装饰
  final Decoration? decoration;

  final DecorationPosition? position;

  @override
  _AnimatedDecorationBoxState createState() => _AnimatedDecorationBoxState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<Decoration>('bg', decoration, defaultValue: null));
  }
}

class _AnimatedDecorationBoxState
    extends AnimatedWidgetBaseState<_AnimatedDecorationBox> {
  DecorationTween? _decoration;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _decoration = visitor(
      _decoration,
      widget.decoration,
      (dynamic value) => DecorationTween(begin: value as Decoration),
    ) as DecorationTween?;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      child: widget.child,
      decoration: _decoration?.evaluate(animation) ?? BoxDecoration(),
      position: widget.position ?? DecorationPosition.background,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<DecorationTween>('bg', _decoration,
        defaultValue: null));
  }
}

/// 动画约束盒子
class _AnimatedConstrainedBox extends ImplicitlyAnimatedWidget {
  /// [curve] 和 [duration] 参数不能为 null
  _AnimatedConstrainedBox({
    Key? key,
    this.constraints,
    this.child,
    Curve curve = Curves.linear,
    required Duration duration,
    VoidCallback? onEnd,
  })  : assert(constraints == null || constraints.debugAssertIsValid()),
        super(
          key: key,
          curve: curve,
          duration: duration,
          onEnd: onEnd,
        );

  /// 容器包含的子 Widget
  final Widget? child;

  /// 应用于子 Widget 的额外约束
  final BoxConstraints? constraints;

  @override
  _AnimatedConstrainedBoxState createState() => _AnimatedConstrainedBoxState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BoxConstraints>(
        'constraints', constraints,
        defaultValue: null, showName: false));
  }
}

class _AnimatedConstrainedBoxState
    extends AnimatedWidgetBaseState<_AnimatedConstrainedBox> {
  BoxConstraintsTween? _constraints;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _constraints = visitor(
      _constraints,
      widget.constraints,
      (dynamic value) => BoxConstraintsTween(begin: value as BoxConstraints),
    ) as BoxConstraintsTween?;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      child: widget.child,
      constraints: _constraints?.evaluate(animation) ?? BoxConstraints(),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<BoxConstraintsTween>(
        'constraints', _constraints,
        showName: false, defaultValue: null));
  }
}

/// 动画变换
class _AnimatedTransform extends ImplicitlyAnimatedWidget {
  /// 创建一个隐式动画的容器
  ///
  /// [curve] 和 [duration] 参数不能为 null
  _AnimatedTransform({
    Key? key,
    this.transform,
    this.origin,
    this.alignment,
    this.transformHitTests = true,
    this.child,
    Curve curve = Curves.linear,
    required Duration duration,
  }) : super(
          key: key,
          curve: curve,
          duration: duration,
        );

  /// 容器包含的子 Widget
  final Widget? child;

  final Offset? origin;

  final AlignmentGeometry? alignment;

  final bool? transformHitTests;

  /// 在绘制容器之前应用的变换矩阵
  final Matrix4? transform;

  @override
  _AnimatedTransformState createState() => _AnimatedTransformState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AlignmentGeometry>(
        'alignment', alignment,
        showName: false, defaultValue: null));
    properties.add(ObjectFlagProperty<Matrix4>.has('transform', transform));
  }
}

class _AnimatedTransformState
    extends AnimatedWidgetBaseState<_AnimatedTransform> {
  AlignmentGeometryTween? _alignment;
  Matrix4Tween? _transform;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _alignment = visitor(
      _alignment,
      widget.alignment,
      (dynamic value) => AlignmentGeometryTween(
        begin: value as AlignmentGeometry?,
      ),
    ) as AlignmentGeometryTween?;
    _transform = visitor(
      _transform,
      widget.transform,
      (dynamic value) => Matrix4Tween(
        begin: value as Matrix4?,
      ),
    ) as Matrix4Tween?;
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      child: widget.child,
      transform: _transform?.evaluate(animation) ?? Matrix4.zero(),
      alignment: _alignment?.evaluate(animation),
      origin: widget.origin,
      transformHitTests: widget.transformHitTests ?? true,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<AlignmentGeometryTween>(
        'alignment', _alignment,
        showName: false, defaultValue: null));
    description
        .add(ObjectFlagProperty<Matrix4Tween>.has('transform', _transform));
  }
}

/// 动画圆角裁剪
class _AnimatedClipRRect extends ImplicitlyAnimatedWidget {
  /// [curve] 和 [duration] 参数不能为 null
  _AnimatedClipRRect({
    Key? key,
    this.topLeft,
    this.topRight,
    this.bottomLeft,
    this.bottomRight,
    this.clipper,
    this.clipBehavior,
    this.child,
    Curve curve = Curves.linear,
    required Duration duration,
    VoidCallback? onEnd,
  }) : super(
          key: key,
          curve: curve,
          duration: duration,
          onEnd: onEnd,
        );

  /// 容器包含的子 Widget
  final Widget? child;

  final double? topLeft;
  final double? topRight;
  final double? bottomLeft;
  final double? bottomRight;
  final CustomClipper<RRect>? clipper;
  final Clip? clipBehavior;

  @override
  _AnimatedClipRRectState createState() => _AnimatedClipRRectState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('topLeft', topLeft));
    properties.add(DoubleProperty('topRight', topRight));
    properties.add(DoubleProperty('bottomLeft', bottomLeft));
    properties.add(DoubleProperty('bottomRight', bottomRight));
  }
}

class _AnimatedClipRRectState
    extends AnimatedWidgetBaseState<_AnimatedClipRRect> {
  Tween<double>? _topLeft;
  Tween<double>? _topRight;
  Tween<double>? _bottomLeft;
  Tween<double>? _bottomRight;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _topLeft = visitor(
      _topLeft,
      widget.topLeft,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
    _topRight = visitor(
      _topRight,
      widget.topRight,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
    _bottomLeft = visitor(
      _bottomLeft,
      widget.bottomLeft,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
    _bottomRight = visitor(
      _bottomRight,
      widget.bottomRight,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: widget.child,
      clipper: widget.clipper,
      clipBehavior: widget.clipBehavior ?? Clip.antiAlias,
      borderRadius: BorderRadius.only(
        topLeft: _topLeft != null
            ? Radius.circular(_topLeft!.evaluate(animation))
            : Radius.zero,
        topRight: _topRight != null
            ? Radius.circular(_topRight!.evaluate(animation))
            : Radius.zero,
        bottomLeft: _bottomLeft != null
            ? Radius.circular(_bottomLeft!.evaluate(animation))
            : Radius.zero,
        bottomRight: _bottomRight != null
            ? Radius.circular(_bottomRight!.evaluate(animation))
            : Radius.zero,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<Tween<double>>('topLeft', _topLeft));
    description.add(DiagnosticsProperty<Tween<double>>('topRight', _topRight));
    description.add(DiagnosticsProperty<Tween<double>>('bottomLeft', _bottomLeft));
    description.add(DiagnosticsProperty<Tween<double>>('bottomRight', _bottomRight));
  }
}

/// 动画背景模糊
class _AnimatedBackgroundBlur extends ImplicitlyAnimatedWidget {
  /// 创建一个隐式动画的透明度 Widget
  ///
  /// [sigma] 参数不能为 null 且必须大于等于 0.0
  /// [curve] 和 [duration] 参数不能为 null
  const _AnimatedBackgroundBlur({
    Key? key,
    this.child,
    required this.sigma,
    Curve curve = Curves.linear,
    required Duration duration,
    VoidCallback? onEnd,
  })  : assert(sigma >= 0.0),
        super(
          key: key,
          curve: curve,
          duration: duration,
          onEnd: onEnd,
        );

  /// 树中此 Widget 下方的 Widget
  final Widget? child;

  final double sigma;

  @override
  _AnimatedBackgroundBlurState createState() => _AnimatedBackgroundBlurState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('background blur', sigma));
  }
}

class _AnimatedBackgroundBlurState
    extends ImplicitlyAnimatedWidgetState<_AnimatedBackgroundBlur> {
  Tween<double>? _sigma;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _sigma = visitor(
      _sigma,
      widget.sigma,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: _sigma?.evaluate(animation) ?? 0,
        sigmaY: _sigma?.evaluate(animation) ?? 0,
      ),
      child: widget.child,
    );
  }
}

/// 动画溢出盒子
class _AnimatedOverflowBox extends ImplicitlyAnimatedWidget {
  /// 创建一个隐式动画的溢出盒子
  ///
  /// [curve] 和 [duration] 参数不能为 null
  const _AnimatedOverflowBox({
    Key? key,
    this.child,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    this.alignment,
    Curve curve = Curves.linear,
    required Duration duration,
    VoidCallback? onEnd,
  }) : super(
          key: key,
          curve: curve,
          duration: duration,
          onEnd: onEnd,
        );

  /// 树中此 Widget 下方的 Widget
  final Widget? child;
  final AlignmentGeometry? alignment;
  final double? minWidth;
  final double? maxWidth;
  final double? minHeight;
  final double? maxHeight;

  @override
  _AnimatedOverflowBoxState createState() => _AnimatedOverflowBoxState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('minWidth', minWidth));
    properties.add(DoubleProperty('maxWidth', maxWidth));
    properties.add(DoubleProperty('minHeight', minHeight));
    properties.add(DoubleProperty('maxHeight', maxHeight));
  }
}

class _AnimatedOverflowBoxState
    extends ImplicitlyAnimatedWidgetState<_AnimatedOverflowBox> {
  Tween<double>? _minWidth;
  Tween<double>? _maxWidth;
  Tween<double>? _minHeight;
  Tween<double>? _maxHeight;
  AlignmentGeometryTween? _alignment;
  
  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _minWidth = visitor(
      _minWidth,
      widget.minWidth,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
    _maxWidth = visitor(
      _maxWidth,
      widget.maxWidth,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
    _minHeight = visitor(
      _minHeight,
      widget.minHeight,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
    _maxHeight = visitor(
      _maxHeight,
      widget.maxHeight,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
    _alignment = visitor(
            _alignment,
            widget.alignment,
            (dynamic value) =>
                AlignmentGeometryTween(begin: value as AlignmentGeometry))
        as AlignmentGeometryTween?;
  }

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      minWidth: _minWidth?.evaluate(animation),
      maxWidth: _maxWidth?.evaluate(animation),
      minHeight: _minHeight?.evaluate(animation),
      maxHeight: _maxHeight?.evaluate(animation),
      alignment: _alignment?.evaluate(animation) ?? Alignment.center,
      child: widget.child,
    );
  }
}