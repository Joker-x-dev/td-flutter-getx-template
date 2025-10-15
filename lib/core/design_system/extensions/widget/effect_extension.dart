import 'package:flutter/material.dart';
import 'dart:ui';

/// Widget 效果相关扩展
/// 提供透明度、模糊、水波纹、发光等视觉效果
extension EffectExtension on Widget {
  /// 设置透明度
  /// 
  /// [opacity] 透明度值（0.0 到 1.0）
  /// [alwaysIncludeSemantics] 是否始终包含语义信息
  /// 
  /// 示例:
  /// ```dart
  /// Container().opacity(0.5)
  /// ```
  Widget opacity(
    double opacity, {
    bool alwaysIncludeSemantics = false,
  }) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      alwaysIncludeSemantics: alwaysIncludeSemantics,
      child: this,
    );
  }



  /// 背景模糊效果
  /// 
  /// [sigmaX] X 轴模糊程度
  /// [sigmaY] Y 轴模糊程度
  /// [tileMode] 平铺模式
  /// 
  /// 示例:
  /// ```dart
  /// Container().backgroundBlur(sigmaX: 5, sigmaY: 5)
  /// ```
  Widget backgroundBlur({
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    TileMode tileMode = TileMode.clamp,
  }) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: sigmaX,
        sigmaY: sigmaY,
        tileMode: tileMode,
      ),
      child: this,
    );
  }

  /// 图像模糊效果
  /// 
  /// [sigmaX] X 轴模糊程度
  /// [sigmaY] Y 轴模糊程度
  /// [tileMode] 平铺模式
  /// 
  /// 示例:
  /// ```dart
  /// Image.asset('image.png').blur(sigmaX: 3, sigmaY: 3)
  /// ```
  Widget blur({
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    TileMode tileMode = TileMode.clamp,
  }) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: sigmaX,
        sigmaY: sigmaY,
        tileMode: tileMode,
      ),
      child: this,
    );
  }

  /// 水波纹点击效果
  /// 
  /// [key] Widget key
  /// [focusColor] 焦点颜色
  /// [hoverColor] 悬停颜色
  /// [highlightColor] 高亮颜色
  /// [splashColor] 水波纹颜色
  /// [splashFactory] 水波纹工厂
  /// [radius] 水波纹半径
  /// [customBorder] 自定义边框
  /// [enableFeedback] 启用反馈
  /// [excludeFromSemantics] 排除语义
  /// [focusNode] 焦点节点
  /// [canRequestFocus] 可请求焦点
  /// [autoFocus] 自动焦点
  /// [enable] 启用状态
  /// 
  /// 示例:
  /// ```dart
  /// Container().ripple(
  ///   splashColor: Colors.blue,
  ///   highlightColor: Colors.grey,
  /// )
  /// ```
  Widget ripple({
    Key? key,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? splashColor,
    InteractiveInkFeatureFactory? splashFactory,
    double? radius,
    ShapeBorder? customBorder,
    bool enableFeedback = true,
    bool excludeFromSemantics = false,
    FocusNode? focusNode,
    bool canRequestFocus = true,
    bool autoFocus = false,
    bool enable = true,
  }) =>
      enable
          ? Builder(
              key: key,
              builder: (BuildContext context) {
                // 查找祖先 GestureDetector 以获取 onTap 回调
                GestureDetector? gestures =
                    context.findAncestorWidgetOfExactType<GestureDetector>();
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: focusColor,
                    hoverColor: hoverColor,
                    highlightColor: highlightColor,
                    splashColor: splashColor,
                    splashFactory: splashFactory,
                    radius: radius,
                    customBorder: customBorder,
                    enableFeedback: enableFeedback,
                    excludeFromSemantics: excludeFromSemantics,
                    focusNode: focusNode,
                    canRequestFocus: canRequestFocus,
                    autofocus: autoFocus,
                    onTap: gestures?.onTap,
                    child: this,
                  ),
                );
              },
            )
          : Builder(
              key: key,
              builder: (context) => this,
            );

  /// 发光效果
  /// 
  /// [color] 发光颜色
  /// [blurRadius] 模糊半径
  /// [spreadRadius] 扩散半径
  /// [offset] 偏移量
  /// 
  /// 示例:
  /// ```dart
  /// Container().glow(
  ///   color: Colors.blue,
  ///   blurRadius: 10,
  ///   spreadRadius: 2,
  /// )
  /// ```
  Widget glow({
    Color color = Colors.blue,
    double blurRadius = 10.0,
    double spreadRadius = 0.0,
    Offset offset = Offset.zero,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
            offset: offset,
          ),
        ],
      ),
      child: this,
    );
  }

  /// 彩色发光效果
  /// 
  /// [colors] 发光颜色列表
  /// [blurRadius] 模糊半径
  /// [spreadRadius] 扩散半径
  /// 
  /// 示例:
  /// ```dart
  /// Container().multiGlow(
  ///   colors: [Colors.red, Colors.blue, Colors.green],
  ///   blurRadius: 15,
  /// )
  /// ```
  Widget multiGlow({
    required List<Color> colors,
    double blurRadius = 10.0,
    double spreadRadius = 0.0,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: colors
            .map((color) => BoxShadow(
                  color: color,
                  blurRadius: blurRadius,
                  spreadRadius: spreadRadius,
                ))
            .toList(),
      ),
      child: this,
    );
  }

  /// 霓虹灯效果
  /// 
  /// [color] 霓虹灯颜色
  /// [blurRadius] 模糊半径
  /// [spreadRadius] 扩散半径
  /// [strokeWidth] 描边宽度
  /// 
  /// 示例:
  /// ```dart
  /// Text('Neon').neon(
  ///   color: Colors.cyan,
  ///   blurRadius: 20,
  ///   strokeWidth: 2,
  /// )
  /// ```
  Widget neon({
    Color color = Colors.cyan,
    double blurRadius = 20.0,
    double spreadRadius = 0.0,
    double strokeWidth = 1.0,
  }) {
    return Stack(
      children: [
        // 外发光
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.8),
                blurRadius: blurRadius,
                spreadRadius: spreadRadius,
              ),
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: blurRadius * 2,
                spreadRadius: spreadRadius * 2,
              ),
            ],
          ),
          child: this,
        ),
        // 内发光
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: color,
              width: strokeWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.6),
                blurRadius: blurRadius / 2,
                spreadRadius: -spreadRadius,
              ),
            ],
          ),
          child: this,
        ),
      ],
    );
  }

  /// 渐变遮罩效果
  /// 
  /// [gradient] 渐变
  /// [blendMode] 混合模式
  /// 
  /// 示例:
  /// ```dart
  /// Image.asset('image.png').gradientMask(
  ///   LinearGradient(
  ///     colors: [Colors.red, Colors.blue],
  ///   ),
  /// )
  /// ```
  Widget gradientMask(
    Gradient gradient, {
    BlendMode blendMode = BlendMode.srcIn,
  }) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(bounds),
      blendMode: blendMode,
      child: this,
    );
  }

  /// 彩虹渐变遮罩
  /// 
  /// [blendMode] 混合模式
  /// 
  /// 示例:
  /// ```dart
  /// Text('Rainbow').rainbowMask()
  /// ```
  Widget rainbowMask({
    BlendMode blendMode = BlendMode.srcIn,
  }) {
    return gradientMask(
      const LinearGradient(
        colors: [
          Colors.red,
          Colors.orange,
          Colors.yellow,
          Colors.green,
          Colors.blue,
          Colors.indigo,
          Colors.purple,
        ],
      ),
      blendMode: blendMode,
    );
  }

  /// 闪烁效果
  /// 
  /// [duration] 闪烁周期
  /// [minOpacity] 最小透明度
  /// [maxOpacity] 最大透明度
  /// 
  /// 示例:
  /// ```dart
  /// Container().shimmer(
  ///   duration: Duration(seconds: 1),
  ///   minOpacity: 0.3,
  ///   maxOpacity: 1.0,
  /// )
  /// ```
  Widget shimmer({
    Duration duration = const Duration(milliseconds: 1500),
    double minOpacity = 0.0,
    double maxOpacity = 1.0,
  }) {
    return _ShimmerWidget(
      duration: duration,
      minOpacity: minOpacity,
      maxOpacity: maxOpacity,
      child: this,
    );
  }

  /// 脉冲效果
  /// 
  /// [duration] 脉冲周期
  /// [minScale] 最小缩放
  /// [maxScale] 最大缩放
  /// 
  /// 示例:
  /// ```dart
  /// Container().pulse(
  ///   duration: Duration(seconds: 1),
  ///   minScale: 0.8,
  ///   maxScale: 1.2,
  /// )
  /// ```
  Widget pulse({
    Duration duration = const Duration(milliseconds: 1000),
    double minScale = 0.95,
    double maxScale = 1.05,
  }) {
    return _PulseWidget(
      duration: duration,
      minScale: minScale,
      maxScale: maxScale,
      child: this,
    );
  }

  /// 呼吸效果（透明度变化）
  /// 
  /// [duration] 呼吸周期
  /// [minOpacity] 最小透明度
  /// [maxOpacity] 最大透明度
  /// 
  /// 示例:
  /// ```dart
  /// Container().breathe(
  ///   duration: Duration(seconds: 2),
  ///   minOpacity: 0.5,
  ///   maxOpacity: 1.0,
  /// )
  /// ```
  Widget breathe({
    Duration duration = const Duration(milliseconds: 2000),
    double minOpacity = 0.5,
    double maxOpacity = 1.0,
  }) {
    return _BreatheWidget(
      duration: duration,
      minOpacity: minOpacity,
      maxOpacity: maxOpacity,
      child: this,
    );
  }

  /// 抖动效果
  /// 
  /// [duration] 抖动周期
  /// [offset] 抖动偏移量
  /// 
  /// 示例:
  /// ```dart
  /// Container().shake(
  ///   duration: Duration(milliseconds: 500),
  ///   offset: 5.0,
  /// )
  /// ```
  Widget shake({
    Duration duration = const Duration(milliseconds: 500),
    double offset = 5.0,
  }) {
    return _ShakeWidget(
      duration: duration,
      offset: offset,
      child: this,
    );
  }
}

/// 闪烁效果 Widget
class _ShimmerWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minOpacity;
  final double maxOpacity;

  const _ShimmerWidget({
    required this.child,
    required this.duration,
    required this.minOpacity,
    required this.maxOpacity,
  });

  @override
  State<_ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<_ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: widget.minOpacity,
      end: widget.maxOpacity,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// 脉冲效果 Widget
class _PulseWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  const _PulseWidget({
    required this.child,
    required this.duration,
    required this.minScale,
    required this.maxScale,
  });

  @override
  State<_PulseWidget> createState() => _PulseWidgetState();
}

class _PulseWidgetState extends State<_PulseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// 呼吸效果 Widget
class _BreatheWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minOpacity;
  final double maxOpacity;

  const _BreatheWidget({
    required this.child,
    required this.duration,
    required this.minOpacity,
    required this.maxOpacity,
  });

  @override
  State<_BreatheWidget> createState() => _BreatheWidgetState();
}

class _BreatheWidgetState extends State<_BreatheWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: widget.minOpacity,
      end: widget.maxOpacity,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// 抖动效果 Widget
class _ShakeWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;

  const _ShakeWidget({
    required this.child,
    required this.duration,
    required this.offset,
  });

  @override
  State<_ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<_ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -widget.offset,
      end: widget.offset,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value, 0),
          child: widget.child,
        );
      },
    );
  }
}