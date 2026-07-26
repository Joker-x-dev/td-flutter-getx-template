import 'package:flutter/material.dart';

import 'animation_context.dart';

/// 旧版通用动画链式扩展兼容入口。

/// 通用隐式动画扩展。
///
/// 该入口保留原有位置参数属性 API；统一导出入口使用分类更明确的
/// Layout、Decoration 与 Transform 动画扩展。
extension AnimatedWidgetExtension on Widget {
  /// 为通用动画提供配置。
  ///
  /// [duration] 动画时长。
  /// [curve] 动画曲线。
  Widget animate({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
  }) {
    return ExtensionAnimationScope(
      config: ExtensionAnimationConfig(duration: duration, curve: curve),
      child: this,
    );
  }

  /// 动画化装饰。
  ///
  /// [decoration] 目标装饰。
  /// [position] 装饰绘制位置。
  Widget animatedDecoration(
    Decoration decoration, {
    DecorationPosition position = DecorationPosition.background,
  }) {
    return buildExtensionAnimation(
      child: this,
      builder: (config, child) => AnimatedContainer(
        duration: config.duration,
        curve: config.curve,
        decoration: position == DecorationPosition.background
            ? decoration
            : null,
        foregroundDecoration: position == DecorationPosition.foreground
            ? decoration
            : null,
        child: child,
      ),
    );
  }

  /// 动画化尺寸约束。
  ///
  /// [constraints] 目标尺寸约束。
  Widget animatedConstraints(BoxConstraints constraints) {
    return buildExtensionAnimation(
      child: this,
      builder: (config, child) => AnimatedContainer(
        constraints: constraints,
        duration: config.duration,
        curve: config.curve,
        child: child,
      ),
    );
  }

  /// 动画化变换矩阵。
  ///
  /// [transform] 目标变换矩阵。
  /// [alignment] 变换对齐方式。
  /// [origin] 变换原点。
  /// [transformHitTests] 是否变换命中测试。
  Widget animatedTransform(
    Matrix4 transform, {
    AlignmentGeometry? alignment,
    Offset? origin,
    bool transformHitTests = true,
  }) {
    return buildExtensionAnimation(
      child: this,
      builder: (config, child) => TweenAnimationBuilder<Matrix4>(
        tween: Matrix4Tween(begin: Matrix4.identity(), end: transform),
        duration: config.duration,
        curve: config.curve,
        child: child,
        builder: (context, value, animatedChild) => Transform(
          transform: value,
          alignment: alignment,
          origin: origin,
          transformHitTests: transformHitTests,
          child: animatedChild,
        ),
      ),
    );
  }

  /// 动画化内边距。
  ///
  /// [padding] 目标内边距。
  Widget animatedPadding(EdgeInsetsGeometry padding) {
    return buildExtensionAnimation(
      child: this,
      builder: (config, child) => AnimatedPadding(
        padding: padding,
        duration: config.duration,
        curve: config.curve,
        child: child,
      ),
    );
  }

  /// 动画化外边距。
  ///
  /// [margin] 目标外边距。
  Widget animatedMargin(EdgeInsetsGeometry margin) {
    return buildExtensionAnimation(
      child: this,
      builder: (config, child) => AnimatedContainer(
        margin: margin,
        duration: config.duration,
        curve: config.curve,
        child: child,
      ),
    );
  }
}
