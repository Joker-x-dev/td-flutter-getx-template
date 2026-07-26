import 'package:flutter/material.dart';

/// 链式动画配置与上下文。

/// 链式扩展共享的动画时长与曲线。
@immutable
class ExtensionAnimationConfig {
  /// 创建链式动画配置。
  ///
  /// [duration] 动画时长。
  /// [curve] 动画曲线。
  const ExtensionAnimationConfig({required this.duration, required this.curve});

  /// 动画时长。
  final Duration duration;

  /// 动画曲线。
  final Curve curve;
}

/// 在 Widget 子树中提供链式动画配置。
class ExtensionAnimationScope extends InheritedWidget {
  /// 创建动画配置作用域。
  ///
  /// [config] 动画配置。
  /// [child] 使用动画配置的子树。
  const ExtensionAnimationScope({
    super.key,
    required this.config,
    required super.child,
  });

  /// 当前动画配置。
  final ExtensionAnimationConfig config;

  /// 读取最近的动画配置作用域。
  ///
  /// [context] 当前构建上下文。
  static ExtensionAnimationScope? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ExtensionAnimationScope>();
  }

  /// 动画配置变化时通知依赖节点重建。
  @override
  bool updateShouldNotify(ExtensionAnimationScope oldWidget) {
    return oldWidget.config.duration != config.duration ||
        oldWidget.config.curve != config.curve;
  }
}

/// 延迟读取动画配置并构建目标动画 Widget。
class ExtensionAnimationBuilder extends StatelessWidget {
  /// 创建动画配置构建器。
  ///
  /// [builder] 动画 Widget 构建函数。
  /// [child] 被动画化的 Widget。
  const ExtensionAnimationBuilder({
    super.key,
    required this.builder,
    required this.child,
  });

  /// 动画 Widget 构建函数。
  final Widget Function(ExtensionAnimationConfig config, Widget child) builder;

  /// 被动画化的 Widget。
  final Widget child;

  /// 使用祖先动画配置构建目标 Widget。
  @override
  Widget build(BuildContext context) {
    final ExtensionAnimationScope? scope = ExtensionAnimationScope.maybeOf(
      context,
    );
    if (scope == null) {
      throw FlutterError(
        '动画扩展缺少配置：请在链式调用末尾使用 '
        '.animate(duration: ..., curve: ...)。',
      );
    }
    return builder(scope.config, child);
  }
}

/// 使用动画上下文构建扩展 Widget。
///
/// [child] 当前链式调用的 Widget。
/// [builder] 根据配置构建动画 Widget 的函数。
///
/// 当 [child] 已经是动画作用域时立即消费配置并继续携带作用域，
/// 从而兼容旧的“先调用 animate”链式顺序。
Widget buildExtensionAnimation({
  required Widget child,
  required Widget Function(ExtensionAnimationConfig config, Widget child)
  builder,
}) {
  if (child case final ExtensionAnimationScope scope) {
    return ExtensionAnimationScope(
      config: scope.config,
      child: builder(scope.config, scope.child),
    );
  }
  return ExtensionAnimationBuilder(builder: builder, child: child);
}

/// 规范链式动画配置入口。
extension ExtensionAnimationContext on Widget {
  /// 为子树提供动画时长和曲线。
  ///
  /// [duration] 动画时长。
  /// [curve] 动画曲线。
  Widget animate({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    final ExtensionAnimationConfig config = ExtensionAnimationConfig(
      duration: duration,
      curve: curve,
    );
    if (this case final ExtensionAnimationScope scope) {
      return ExtensionAnimationScope(config: config, child: scope.child);
    }
    return ExtensionAnimationScope(config: config, child: this);
  }
}
