import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'animation_context.dart';

/// Widget 效果动画扩展
extension AnimatedEffectExtension on Widget {
  /// 带动画的透明度
  ///
  /// 为 Widget 应用透明度效果，支持动画
  ///
  /// 参数：
  /// - [opacity] 透明度值，范围 0.0 到 1.0
  /// - [alwaysIncludeSemantics] 是否始终包含语义信息，默认为 false
  ///
  /// 示例：
  /// ```dart
  /// Container()
  ///   .animate(Duration(milliseconds: 300))
  ///   .animatedOpacity(0.5)
  /// ```
  ///
  /// 返回带有透明度动画的 Widget
  Widget animatedOpacity(
    double opacity, {
    bool alwaysIncludeSemantics = false,
  }) {
    return buildExtensionAnimation(
      child: this,
      builder: (config, child) => AnimatedOpacity(
        opacity: opacity,
        duration: config.duration,
        curve: config.curve,
        alwaysIncludeSemantics: alwaysIncludeSemantics,
        child: child,
      ),
    );
  }

  /// 带动画的淡入效果
  ///
  /// 为 Widget 应用淡入效果，从透明到不透明
  ///
  /// 参数：
  /// - [alwaysIncludeSemantics] 是否始终包含语义信息，默认为 false
  ///
  /// 示例：
  /// ```dart
  /// Text('Hello')
  ///   .animate(Duration(milliseconds: 500))
  ///   .animatedFadeIn()
  /// ```
  ///
  /// 返回带有淡入动画效果的 Widget
  Widget animatedFadeIn({bool alwaysIncludeSemantics = false}) {
    return animatedOpacity(1.0, alwaysIncludeSemantics: alwaysIncludeSemantics);
  }

  /// 带动画的淡出效果
  ///
  /// 为 Widget 应用淡出效果，从不透明到透明
  ///
  /// 参数：
  /// - [alwaysIncludeSemantics] 是否始终包含语义信息，默认为 false
  ///
  /// 示例：
  /// ```dart
  /// Image.asset('image.png')
  ///   .animate(Duration(milliseconds: 400))
  ///   .animatedFadeOut()
  /// ```
  ///
  /// 返回带有淡出动画效果的 Widget
  Widget animatedFadeOut({bool alwaysIncludeSemantics = false}) {
    return animatedOpacity(0.0, alwaysIncludeSemantics: alwaysIncludeSemantics);
  }

  /// 带动画的背景模糊
  ///
  /// 为 Widget 应用背景模糊效果，支持动画
  ///
  /// 参数：
  /// - [sigmaX] X 轴模糊程度，默认为 10.0
  /// - [sigmaY] Y 轴模糊程度，默认为 10.0
  ///
  /// 示例：
  /// ```dart
  /// Container()
  ///   .animate(Duration(milliseconds: 600))
  ///   .animatedBackdropFilter(sigmaX: 5.0, sigmaY: 5.0)
  /// ```
  ///
  /// 返回带有背景模糊动画的 Widget
  Widget animatedBackdropFilter({double sigmaX = 10.0, double sigmaY = 10.0}) {
    return buildExtensionAnimation(
      child: this,
      builder: (config, child) => TweenAnimationBuilder<Offset>(
        tween: Tween<Offset>(begin: Offset.zero, end: Offset(sigmaX, sigmaY)),
        duration: config.duration,
        curve: config.curve,
        builder: (context, value, animatedChild) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: value.dx, sigmaY: value.dy),
          child: animatedChild,
        ),
        child: child,
      ),
    );
  }

  /// 带动画的溢出处理
  ///
  /// 为 Widget 应用溢出处理，支持动画
  ///
  /// 参数：
  /// - [minWidth] 最小宽度，默认为 0.0
  /// - [maxWidth] 最大宽度，默认为 double.infinity
  /// - [minHeight] 最小高度，默认为 0.0
  /// - [maxHeight] 最大高度，默认为 double.infinity
  /// - [alignment] 对齐方式，默认为 Alignment.center
  ///
  /// 示例：
  /// ```dart
  /// Text('Very long text that might overflow')
  ///   .animate(Duration(milliseconds: 300))
  ///   .animatedOverflowBox(
  ///     maxWidth: 200,
  ///     maxHeight: 100,
  ///   )
  /// ```
  ///
  /// 返回带有溢出处理动画的 Widget
  Widget animatedOverflowBox({
    double minWidth = 0.0,
    double maxWidth = double.infinity,
    double minHeight = 0.0,
    double maxHeight = double.infinity,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return buildExtensionAnimation(
      child: this,
      builder: (config, child) => TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        duration: config.duration,
        curve: config.curve,
        builder: (context, value, animatedChild) => OverflowBox(
          minWidth: minWidth,
          maxWidth: maxWidth.isFinite
              ? minWidth + (maxWidth - minWidth) * value
              : maxWidth,
          minHeight: minHeight,
          maxHeight: maxHeight.isFinite
              ? minHeight + (maxHeight - minHeight) * value
              : maxHeight,
          alignment: alignment,
          fit: OverflowBoxFit.deferToChild,
          child: animatedChild,
        ),
        child: child,
      ),
    );
  }

  /// 带动画的可见性
  ///
  /// 为 Widget 应用可见性控制，支持动画
  ///
  /// 参数：
  /// - [visible] 是否可见
  /// - [maintainSize] 是否保持尺寸，默认为 false
  /// - [maintainAnimation] 是否保持动画，默认为 false
  /// - [maintainState] 是否保持状态，默认为 false
  /// - [maintainInteractivity] 是否保持交互性，默认为 false
  ///
  /// 示例：
  /// ```dart
  /// Container()
  ///   .animate(Duration(milliseconds: 300))
  ///   .animatedVisibility(visible: false)
  /// ```
  ///
  /// 返回带有可见性控制动画的 Widget
  Widget animatedVisibility(
    bool visible, {
    bool maintainSize = false,
    bool maintainAnimation = false,
    bool maintainState = false,
    bool maintainInteractivity = false,
  }) {
    return buildExtensionAnimation(
      child: this,
      builder: (config, child) => _ExtensionAnimatedVisibility(
        visible: visible,
        maintainSize: maintainSize,
        maintainAnimation: maintainAnimation,
        maintainState: maintainState,
        maintainInteractivity: maintainInteractivity,
        duration: config.duration,
        curve: config.curve,
        child: child,
      ),
    );
  }

  /// 带动画的忽略指针事件
  ///
  /// 为 Widget 应用忽略指针事件，支持动画
  ///
  /// 参数：
  /// - [ignoring] 是否忽略指针事件
  ///
  /// 示例：
  /// ```dart
  /// Button()
  ///   .animate(Duration(milliseconds: 200))
  ///   .animatedIgnorePointer(ignoring: true)
  /// ```
  ///
  /// 返回带有忽略指针事件动画的 Widget
  Widget animatedIgnorePointer(bool ignoring) {
    final double target = ignoring ? 1 : 0;
    return buildExtensionAnimation(
      child: this,
      builder: (config, child) => TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: target, end: target),
        duration: config.duration,
        curve: config.curve,
        builder: (context, value, animatedChild) =>
            IgnorePointer(ignoring: value > 0.5, child: animatedChild),
        child: child,
      ),
    );
  }

  /// 带动画的吸收指针事件
  ///
  /// 为 Widget 应用吸收指针事件，支持动画
  ///
  /// 参数：
  /// - [absorbing] 是否吸收指针事件
  ///
  /// 示例：
  /// ```dart
  /// Container()
  ///   .animate(Duration(milliseconds: 250))
  ///   .animatedAbsorbPointer(absorbing: true)
  /// ```
  ///
  /// 返回带有吸收指针事件动画的 Widget
  Widget animatedAbsorbPointer(bool absorbing) {
    final double target = absorbing ? 1 : 0;
    return buildExtensionAnimation(
      child: this,
      builder: (config, child) => TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: target, end: target),
        duration: config.duration,
        curve: config.curve,
        builder: (context, value, animatedChild) =>
            AbsorbPointer(absorbing: value > 0.5, child: animatedChild),
        child: child,
      ),
    );
  }

  /// 带动画的着色器遮罩
  ///
  /// 为 Widget 应用着色器遮罩效果，支持动画
  ///
  /// 参数：
  /// - [shaderCallback] 着色器回调函数
  /// - [blendMode] 混合模式，默认为 BlendMode.modulate
  ///
  /// 示例：
  /// ```dart
  /// Text('Gradient Text')
  ///   .animate(Duration(milliseconds: 400))
  ///   .animatedShaderMask(
  ///     shaderCallback: (bounds) => LinearGradient(
  ///       colors: [Colors.red, Colors.blue],
  ///     ).createShader(bounds),
  ///   )
  /// ```
  ///
  /// 返回带有着色器遮罩动画的 Widget
  Widget animatedShaderMask(
    ShaderCallback shaderCallback, {
    BlendMode blendMode = BlendMode.modulate,
  }) {
    return buildExtensionAnimation(
      child: this,
      builder: (config, child) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: config.duration,
        curve: config.curve,
        builder: (context, value, animatedChild) => ShaderMask(
          shaderCallback: shaderCallback,
          blendMode: blendMode,
          child: Opacity(opacity: value, child: animatedChild),
        ),
        child: child,
      ),
    );
  }

  /// 带动画的颜色过滤器
  ///
  /// 为 Widget 应用颜色过滤器效果，支持动画
  ///
  /// 参数：
  /// - [colorFilter] 颜色过滤器
  ///
  /// 示例：
  /// ```dart
  /// Image.asset('image.png')
  ///   .animate(Duration(milliseconds: 300))
  ///   .animatedColorFiltered(
  ///     colorFilter: ColorFilter.mode(Colors.red, BlendMode.color),
  ///   )
  /// ```
  ///
  /// 返回带有颜色过滤器动画的 Widget
  Widget animatedColorFiltered(ColorFilter colorFilter) {
    return buildExtensionAnimation(
      child: this,
      builder: (config, child) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: config.duration,
        curve: config.curve,
        builder: (context, value, animatedChild) => ColorFiltered(
          colorFilter: colorFilter,
          child: Opacity(opacity: value, child: animatedChild),
        ),
        child: child,
      ),
    );
  }
}

/// 在淡出结束后按需移除子树的可见性组件。
class _ExtensionAnimatedVisibility extends StatefulWidget {
  /// 创建动画可见性组件。
  const _ExtensionAnimatedVisibility({
    required this.visible,
    required this.maintainSize,
    required this.maintainAnimation,
    required this.maintainState,
    required this.maintainInteractivity,
    required this.duration,
    required this.curve,
    required this.child,
  });

  /// 是否显示子树。
  final bool visible;

  /// 隐藏后是否保留尺寸。
  final bool maintainSize;

  /// 隐藏后是否保留动画。
  final bool maintainAnimation;

  /// 隐藏后是否保留状态。
  final bool maintainState;

  /// 隐藏后是否保留交互。
  final bool maintainInteractivity;

  /// 淡入淡出时长。
  final Duration duration;

  /// 淡入淡出曲线。
  final Curve curve;

  /// 受可见性控制的子树。
  final Widget child;

  /// 创建动画可见性状态。
  @override
  State<_ExtensionAnimatedVisibility> createState() =>
      _ExtensionAnimatedVisibilityState();
}

/// 管理淡出结束后的子树移除时机。
class _ExtensionAnimatedVisibilityState
    extends State<_ExtensionAnimatedVisibility> {
  /// Visibility 当前是否保留子树。
  late bool _showChild;

  /// 初始化子树可见性。
  @override
  void initState() {
    super.initState();
    _showChild = widget.visible;
  }

  /// 在淡入开始前恢复子树。
  @override
  void didUpdateWidget(covariant _ExtensionAnimatedVisibility oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible && !_showChild) {
      _showChild = true;
    }
  }

  /// 淡出结束后根据维护策略移除子树。
  void _handleAnimationEnd() {
    if (!widget.visible && _showChild && mounted) {
      setState(() => _showChild = false);
    }
  }

  /// 构建透明度与可见性组合。
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _showChild,
      maintainSize: widget.maintainSize,
      maintainAnimation: widget.maintainAnimation,
      maintainState: widget.maintainState,
      maintainInteractivity: widget.maintainInteractivity,
      child: AnimatedOpacity(
        opacity: widget.visible ? 1 : 0,
        duration: widget.duration,
        curve: widget.curve,
        onEnd: _handleAnimationEnd,
        child: widget.child,
      ),
    );
  }
}
