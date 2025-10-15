import 'package:flutter/material.dart';

/// 动画模型类
/// 
/// 用于存储动画的持续时间和曲线
class AnimationModel {
  /// 动画持续时间
  final Duration duration;
  
  /// 动画曲线
  final Curve curve;
  
  /// 创建动画模型
  /// 
  /// [duration] 动画持续时间
  /// [curve] 动画曲线，默认为 Curves.easeInOut
  const AnimationModel({
    required this.duration,
    this.curve = Curves.easeInOut,
  });
}

/// 动画继承 Widget
/// 
/// 用于在 Widget 树中传递动画配置
class _InheritedAnimation extends InheritedWidget {
  /// 动画模型
  final AnimationModel animation;
  
  /// 创建动画继承 Widget
  /// 
  /// [animation] 动画模型
  /// [child] 子 Widget
  const _InheritedAnimation({
    required this.animation,
    required super.child,
  });
  
  /// 获取最近的动画配置
  /// 
  /// [context] 构建上下文
  /// 返回最近的 _InheritedAnimation 实例
  static _InheritedAnimation? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedAnimation>();
  }
  
  @override
  bool updateShouldNotify(_InheritedAnimation oldWidget) {
    return animation.duration != oldWidget.animation.duration ||
           animation.curve != oldWidget.animation.curve;
  }
}

/// 动画构建器
/// 
/// 用于构建带有动画配置的 Widget
class _AnimatedBuilder extends StatelessWidget {
  /// 构建函数
  final Widget Function(AnimationModel animation) builder;
  
  /// 创建动画构建器
  /// 
  /// [builder] 构建函数，接收动画模型参数
  const _AnimatedBuilder({
    required this.builder,
  });
  
  @override
  Widget build(BuildContext context) {
    final animation = _InheritedAnimation.of(context)?.animation;
    assert(animation != null, 
        '动画扩展错误：无法找到动画配置。请在 Widget 层次结构中调用 animate() 方法来定义动画。');
    return builder(animation!);
  }
}

/// Widget 动画扩展
extension AnimationExtension on Widget {
  /// 获取动画配置
  /// 
  /// [context] 构建上下文
  /// 返回当前上下文中的动画模型
  AnimationModel _getAnimation(BuildContext context) {
    final animation = _InheritedAnimation.of(context)?.animation;
    assert(animation != null,
        '动画扩展错误：无法找到动画配置。请在 Widget 层次结构中调用 animate() 方法来定义动画。');
    return animation!;
  }
  
  /// 为所有后续属性启用动画
  /// 
  /// 此方法必须在其他动画方法之前调用，用于定义动画的持续时间和曲线。
  /// 所有在此方法之后调用的带有 animate 参数的方法都将使用这里定义的动画配置。
  /// 
  /// 参数：
  /// - [duration] 动画持续时间
  /// - [curve] 动画曲线，默认为 Curves.easeInOut
  /// 
  /// 示例：
  /// ```dart
  /// Container()
  ///   .animate(Duration(milliseconds: 300), Curves.bounceIn)
  ///   .pad(all: 20, animate: true)
  ///   .opacity(0.8, animate: true)
  /// ```
  /// 
  /// 返回包含动画配置的 Widget
  Widget animate(
    Duration duration, {
    Curve curve = Curves.easeInOut,
  }) {
    return _InheritedAnimation(
      animation: AnimationModel(
        duration: duration,
        curve: curve,
      ),
      child: this,
    );
  }
  
  /// 创建动画构建器
  /// 
  /// 内部方法，用于创建带有动画配置的构建器
  /// 
  /// [builder] 构建函数
  /// 返回动画构建器 Widget
  Widget _animatedBuilder(Widget Function(AnimationModel animation) builder) {
    return _AnimatedBuilder(builder: builder);
  }
}