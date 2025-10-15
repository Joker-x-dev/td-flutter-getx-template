import 'package:flutter/material.dart';

/// Widget 手势扩展
/// 提供各种手势事件的扩展方法，支持链式调用
///
/// 
extension GestureExtension on Widget {
  /// 简单点击事件
  ///
  /// [onTap] 点击回调函数
  /// [behavior] 手势检测行为，默认为 [HitTestBehavior.opaque]
  ///
  /// 示例:
  /// ```dart
  /// Container().onTap(() => print('点击了'));
  /// ```
  Widget onTap(
    VoidCallback? onTap, {
    HitTestBehavior? behavior,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: behavior ?? HitTestBehavior.opaque,
      child: this,
    );
  }

  /// 双击事件
  ///
  /// [onDoubleTap] 双击回调函数
  /// [behavior] 手势检测行为，默认为 [HitTestBehavior.opaque]
  ///
  /// 示例:
  /// ```dart
  /// Container().onDoubleTap(() => print('双击了'));
  /// ```
  Widget onDoubleTap(
    VoidCallback? onDoubleTap, {
    HitTestBehavior? behavior,
  }) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      behavior: behavior ?? HitTestBehavior.opaque,
      child: this,
    );
  }

  /// 长按事件
  ///
  /// [onLongPress] 长按回调函数
  /// [behavior] 手势检测行为，默认为 [HitTestBehavior.opaque]
  ///
  /// 示例:
  /// ```dart
  /// Container().onLongPress(() => print('长按了'));
  /// ```
  Widget onLongPress(
    VoidCallback? onLongPress, {
    HitTestBehavior? behavior,
  }) {
    return GestureDetector(
      onLongPress: onLongPress,
      behavior: behavior ?? HitTestBehavior.opaque,
      child: this,
    );
  }

  /// 按下事件
  ///
  /// [onTapDown] 按下回调函数
  /// [behavior] 手势检测行为，默认为 [HitTestBehavior.opaque]
  ///
  /// 示例:
  /// ```dart
  /// Container().onTapDown((details) => print('按下了: ${details.localPosition}'));
  /// ```
  Widget onTapDown(
    GestureTapDownCallback? onTapDown, {
    HitTestBehavior? behavior,
  }) {
    return GestureDetector(
      onTapDown: onTapDown,
      behavior: behavior ?? HitTestBehavior.opaque,
      child: this,
    );
  }

  /// 抬起事件
  ///
  /// [onTapUp] 抬起回调函数
  /// [behavior] 手势检测行为，默认为 [HitTestBehavior.opaque]
  ///
  /// 示例:
  /// ```dart
  /// Container().onTapUp((details) => print('抬起了: ${details.localPosition}'));
  /// ```
  Widget onTapUp(
    GestureTapUpCallback? onTapUp, {
    HitTestBehavior? behavior,
  }) {
    return GestureDetector(
      onTapUp: onTapUp,
      behavior: behavior ?? HitTestBehavior.opaque,
      child: this,
    );
  }

  /// 取消事件
  ///
  /// [onTapCancel] 取消回调函数
  /// [behavior] 手势检测行为，默认为 [HitTestBehavior.opaque]
  ///
  /// 示例:
  /// ```dart
  /// Container().onTapCancel(() => print('取消了'));
  /// ```
  Widget onTapCancel(
    VoidCallback? onTapCancel, {
    HitTestBehavior? behavior,
  }) {
    return GestureDetector(
      onTapCancel: onTapCancel,
      behavior: behavior ?? HitTestBehavior.opaque,
      child: this,
    );
  }

  /// 综合手势事件
  ///
  /// 支持多种手势事件的组合使用
  ///
  /// [onTap] 点击回调
  /// [onDoubleTap] 双击回调
  /// [onLongPress] 长按回调
  /// [onTapDown] 按下回调
  /// [onTapUp] 抬起回调
  /// [onTapCancel] 取消回调
  /// [onPanStart] 拖拽开始回调
  /// [onPanUpdate] 拖拽更新回调
  /// [onPanEnd] 拖拽结束回调
  /// [behavior] 手势检测行为，默认为 [HitTestBehavior.opaque]
  ///
  /// 示例:
  /// ```dart
  /// Container().gestures(
  ///   onTap: () => print('点击'),
  ///   onLongPress: () => print('长按'),
  ///   onPanUpdate: (details) => print('拖拽: ${details.delta}'),
  /// );
  /// ```
  Widget gestures({
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onLongPress,
    GestureTapDownCallback? onTapDown,
    GestureTapUpCallback? onTapUp,
    VoidCallback? onTapCancel,
    GestureDragStartCallback? onPanStart,
    GestureDragUpdateCallback? onPanUpdate,
    GestureDragEndCallback? onPanEnd,
    HitTestBehavior? behavior,
  }) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      behavior: behavior ?? HitTestBehavior.opaque,
      child: this,
    );
  }

  /// 垂直拖拽事件
  ///
  /// [onVerticalDragStart] 垂直拖拽开始回调
  /// [onVerticalDragUpdate] 垂直拖拽更新回调
  /// [onVerticalDragEnd] 垂直拖拽结束回调
  /// [behavior] 手势检测行为，默认为 [HitTestBehavior.opaque]
  ///
  /// 示例:
  /// ```dart
  /// Container().onVerticalDrag(
  ///   onVerticalDragUpdate: (details) => print('垂直拖拽: ${details.delta.dy}'),
  /// );
  /// ```
  Widget onVerticalDrag({
    GestureDragStartCallback? onVerticalDragStart,
    GestureDragUpdateCallback? onVerticalDragUpdate,
    GestureDragEndCallback? onVerticalDragEnd,
    HitTestBehavior? behavior,
  }) {
    return GestureDetector(
      onVerticalDragStart: onVerticalDragStart,
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd,
      behavior: behavior ?? HitTestBehavior.opaque,
      child: this,
    );
  }

  /// 水平拖拽事件
  ///
  /// [onHorizontalDragStart] 水平拖拽开始回调
  /// [onHorizontalDragUpdate] 水平拖拽更新回调
  /// [onHorizontalDragEnd] 水平拖拽结束回调
  /// [behavior] 手势检测行为，默认为 [HitTestBehavior.opaque]
  ///
  /// 示例:
  /// ```dart
  /// Container().onHorizontalDrag(
  ///   onHorizontalDragUpdate: (details) => print('水平拖拽: ${details.delta.dx}'),
  /// );
  /// ```
  Widget onHorizontalDrag({
    GestureDragStartCallback? onHorizontalDragStart,
    GestureDragUpdateCallback? onHorizontalDragUpdate,
    GestureDragEndCallback? onHorizontalDragEnd,
    HitTestBehavior? behavior,
  }) {
    return GestureDetector(
      onHorizontalDragStart: onHorizontalDragStart,
      onHorizontalDragUpdate: onHorizontalDragUpdate,
      onHorizontalDragEnd: onHorizontalDragEnd,
      behavior: behavior ?? HitTestBehavior.opaque,
      child: this,
    );
  }

  /// 缩放手势事件
  ///
  /// [onScaleStart] 缩放开始回调
  /// [onScaleUpdate] 缩放更新回调
  /// [onScaleEnd] 缩放结束回调
  /// [behavior] 手势检测行为，默认为 [HitTestBehavior.opaque]
  ///
  /// 示例:
  /// ```dart
  /// Container().onScale(
  ///   onScaleUpdate: (details) => print('缩放: ${details.scale}'),
  /// );
  /// ```
  Widget onScale({
    GestureScaleStartCallback? onScaleStart,
    GestureScaleUpdateCallback? onScaleUpdate,
    GestureScaleEndCallback? onScaleEnd,
    HitTestBehavior? behavior,
  }) {
    return GestureDetector(
      onScaleStart: onScaleStart,
      onScaleUpdate: onScaleUpdate,
      onScaleEnd: onScaleEnd,
      behavior: behavior ?? HitTestBehavior.opaque,
      child: this,
    );
  }
}