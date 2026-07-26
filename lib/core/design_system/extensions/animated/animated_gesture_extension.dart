import 'package:flutter/material.dart';

/// Widget 动画手势扩展
/// 提供简洁实用的手势动画效果，支持链式调用
/// 使用 Flutter 原生状态管理，无第三方依赖
///
///
extension AnimatedGestureExtension on Widget {
  /// 简单动画点击效果
  ///
  /// 点击时产生轻微缩放效果，使用简单
  ///
  /// [onTap] 点击回调函数
  ///
  /// 示例:
  /// ```dart
  /// Container(
  ///   width: 100,
  ///   height: 100,
  ///   color: Colors.blue,
  ///   child: Text('点击我'),
  /// ).animatedTap(() => print('点击了'));
  /// ```
  Widget animatedTap(VoidCallback onTap) {
    return _AnimatedTapWidget(onTap: onTap, child: this);
  }

  /// 动画水波纹点击效果
  ///
  /// 为组件添加水波纹点击效果，点击时会产生涟漪动画
  ///
  /// 参数：
  /// - [onTap] 点击回调函数
  /// - [splashColor] 水波纹颜色，默认为主题色
  /// - [highlightColor] 高亮颜色，默认为主题色
  /// - [borderRadius] 边框圆角，默认为无圆角
  ///
  /// 示例:
  /// ```dart
  /// Container(
  ///   width: 100,
  ///   height: 100,
  ///   color: Colors.blue,
  /// ).animatedRipple(
  ///   () => print('点击了'),
  ///   splashColor: Colors.white.withOpacity(0.3),
  ///   highlightColor: Colors.white.withOpacity(0.1),
  ///   borderRadius: BorderRadius.circular(8),
  /// )
  /// ```
  Widget animatedRipple(
    VoidCallback? onTap, {
    Color? splashColor,
    Color? highlightColor,
    BorderRadius? borderRadius,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: splashColor,
        highlightColor: highlightColor,
        borderRadius: borderRadius,
        child: this,
      ),
    );
  }

  /// 组合水波纹和缩放效果
  ///
  /// 同时提供水波纹点击反馈和按压缩放动画
  ///
  /// 参数：
  /// - [onTap] 点击回调函数
  /// - [splashColor] 水波纹颜色
  /// - [highlightColor] 高亮颜色
  /// - [borderRadius] 边框圆角
  /// - [scaleValue] 缩放值，默认为 0.95
  /// - [duration] 动画持续时间，默认为 100ms
  ///
  /// 示例:
  /// ```dart
  /// Container(
  ///   width: 100,
  ///   height: 100,
  ///   color: Colors.blue,
  /// ).animatedTapScale(() => print('点击了'))
  /// ```
  Widget animatedTapScale(
    VoidCallback onTap, {
    Color? splashColor,
    Color? highlightColor,
    BorderRadius? borderRadius,
    double scaleValue = 0.95,
    Duration duration = const Duration(milliseconds: 100),
  }) {
    return _AnimatedTapScaleWidget(
      onTap: onTap,
      splashColor: splashColor,
      highlightColor: highlightColor,
      borderRadius: borderRadius,
      scaleValue: scaleValue,
      duration: duration,
      child: this,
    );
  }

  /// 动画长按效果
  ///
  /// 长按时触发回调，带有简单的视觉反馈
  ///
  /// [onLongPress] 长按回调函数
  ///
  /// 示例:
  /// ```dart
  /// Container(
  ///   width: 80,
  ///   height: 80,
  ///   color: Colors.red,
  ///   child: Text('长按我'),
  /// ).animatedLongPress(() => print('长按了'));
  /// ```
  Widget animatedLongPress(VoidCallback onLongPress) {
    return GestureDetector(onLongPress: onLongPress, child: this);
  }

  /// 动画双击效果
  ///
  /// 双击时触发回调
  ///
  /// [onDoubleTap] 双击回调函数
  ///
  /// 示例:
  /// ```dart
  /// Container(
  ///   width: 100,
  ///   height: 100,
  ///   color: Colors.green,
  ///   child: Text('双击我'),
  /// ).animatedDoubleTap(() => print('双击了'));
  /// ```
  Widget animatedDoubleTap(VoidCallback onDoubleTap) {
    return GestureDetector(onDoubleTap: onDoubleTap, child: this);
  }

  /// 动画悬停效果
  ///
  /// 为组件添加鼠标悬停时的缩放效果
  ///
  /// 参数：
  /// - [scale] 悬停时的缩放比例，默认为 1.05
  /// - [duration] 动画持续时间，默认为 200 毫秒
  /// - [curve] 动画曲线，默认为 Curves.easeInOut
  ///
  /// 示例:
  /// ```dart
  /// Container(
  ///   width: 100,
  ///   height: 100,
  ///   color: Colors.green,
  /// ).animatedHover(
  ///   scale: 1.1,
  ///   duration: Duration(milliseconds: 200),
  ///   curve: Curves.easeInOut,
  /// )
  /// ```
  Widget animatedHover({
    double scale = 1.05,
    Duration duration = const Duration(milliseconds: 200),
    Curve curve = Curves.easeInOut,
  }) {
    return _AnimatedHoverWidget(
      scale: scale,
      duration: duration,
      curve: curve,
      child: this,
    );
  }
}

/// 内部使用的动画点击组件
class _AnimatedTapWidget extends StatefulWidget {
  /// 点击回调
  final VoidCallback onTap;

  /// 应用点击动画的子组件
  final Widget child;

  /// 创建动画点击组件
  ///
  /// [onTap] 点击完成回调。
  /// [child] 应用动画的子组件。
  const _AnimatedTapWidget({required this.onTap, required this.child});

  /// 创建动画点击组件状态
  @override
  State<_AnimatedTapWidget> createState() => _AnimatedTapWidgetState();
}

/// 组合水波纹和缩放效果的 Widget
class _AnimatedTapScaleWidget extends StatefulWidget {
  /// 应用点击动画的子组件
  final Widget child;

  /// 点击回调
  final VoidCallback onTap;

  /// 水波纹颜色
  final Color? splashColor;

  /// 高亮颜色
  final Color? highlightColor;

  /// 水波纹边框圆角
  final BorderRadius? borderRadius;

  /// 按下状态缩放比例
  final double scaleValue;

  /// 缩放动画时长
  final Duration duration;

  /// 创建水波纹缩放组件
  ///
  /// [child] 应用动画的子组件。
  /// [onTap] 点击完成回调。
  /// [splashColor] 水波纹颜色。
  /// [highlightColor] 高亮颜色。
  /// [borderRadius] 水波纹边框圆角。
  /// [scaleValue] 按下状态缩放比例。
  /// [duration] 缩放动画时长。
  const _AnimatedTapScaleWidget({
    required this.child,
    required this.onTap,
    this.splashColor,
    this.highlightColor,
    this.borderRadius,
    this.scaleValue = 0.95,
    this.duration = const Duration(milliseconds: 100),
  });

  /// 创建水波纹缩放组件状态
  @override
  State<_AnimatedTapScaleWidget> createState() =>
      _AnimatedTapScaleWidgetState();
}

/// 动画点击组件状态
class _AnimatedTapWidgetState extends State<_AnimatedTapWidget>
    with SingleTickerProviderStateMixin {
  /// 点击缩放动画控制器
  late AnimationController _controller;

  /// 点击缩放动画
  late Animation<double> _scaleAnimation;

  /// 初始化点击缩放动画
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  /// 释放点击缩放动画控制器
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 处理指针按下事件
  ///
  /// [details] 指针按下详情。
  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  /// 处理指针抬起事件并触发点击回调
  ///
  /// [details] 指针抬起详情。
  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  /// 处理点击取消事件
  void _onTapCancel() {
    _controller.reverse();
  }

  /// 构建点击缩放组件
  ///
  /// [context] 当前构建上下文。
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// 水波纹缩放组件状态
class _AnimatedTapScaleWidgetState extends State<_AnimatedTapScaleWidget>
    with SingleTickerProviderStateMixin {
  /// 缩放动画控制器
  late AnimationController _controller;

  /// 缩放动画
  late Animation<double> _scaleAnimation;

  /// 初始化水波纹缩放动画
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleValue,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  /// 同步重建后的动画时长与目标缩放比例。
  @override
  void didUpdateWidget(covariant _AnimatedTapScaleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
    if (oldWidget.scaleValue != widget.scaleValue) {
      _scaleAnimation = Tween<double>(
        begin: 1.0,
        end: widget.scaleValue,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    }
  }

  /// 释放缩放动画控制器
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 处理指针按下事件
  ///
  /// [details] 指针按下详情。
  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  /// 处理指针抬起事件并触发点击回调
  ///
  /// [details] 指针抬起详情。
  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  /// 处理点击取消事件
  void _onTapCancel() {
    _controller.reverse();
  }

  /// 构建水波纹缩放组件
  ///
  /// [context] 当前构建上下文。
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: () {}, // 点击回调由 onTapUp 统一触发
        splashColor: widget.splashColor,
        highlightColor: widget.highlightColor,
        borderRadius: widget.borderRadius,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: widget.child,
            );
          },
        ),
      ),
    );
  }
}

/// 内部使用的悬停动画组件
class _AnimatedHoverWidget extends StatefulWidget {
  /// 悬停状态缩放比例
  final double scale;

  /// 悬停动画时长
  final Duration duration;

  /// 悬停动画曲线
  final Curve curve;

  /// 应用悬停动画的子组件
  final Widget child;

  /// 创建悬停动画组件
  ///
  /// [scale] 悬停状态缩放比例。
  /// [duration] 悬停动画时长。
  /// [curve] 悬停动画曲线。
  /// [child] 应用动画的子组件。
  const _AnimatedHoverWidget({
    required this.scale,
    required this.duration,
    required this.curve,
    required this.child,
  });

  /// 创建悬停动画组件状态
  @override
  State<_AnimatedHoverWidget> createState() => _AnimatedHoverWidgetState();
}

/// 悬停动画组件状态
class _AnimatedHoverWidgetState extends State<_AnimatedHoverWidget>
    with SingleTickerProviderStateMixin {
  /// 悬停动画控制器
  late AnimationController _controller;

  /// 悬停缩放动画
  late Animation<double> _scaleAnimation;

  /// 鼠标是否处于悬停状态
  bool _isHovering = false;

  /// 初始化悬停缩放动画
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scale,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  /// 同步重建后的悬停动画配置。
  @override
  void didUpdateWidget(covariant _AnimatedHoverWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
    if (oldWidget.scale != widget.scale || oldWidget.curve != widget.curve) {
      _scaleAnimation = Tween<double>(
        begin: 1.0,
        end: widget.scale,
      ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    }
  }

  /// 释放悬停动画控制器
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 处理鼠标进入事件
  void _onEnter() {
    if (!_isHovering) {
      _isHovering = true;
      _controller.forward();
    }
  }

  /// 处理鼠标离开事件
  void _onExit() {
    if (_isHovering) {
      _isHovering = false;
      _controller.reverse();
    }
  }

  /// 构建悬停缩放组件
  ///
  /// [context] 当前构建上下文。
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onEnter(),
      onExit: (_) => _onExit(),
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}
