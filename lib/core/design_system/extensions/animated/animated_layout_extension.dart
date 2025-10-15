import 'package:flutter/material.dart';
import 'animation_extension.dart';

/// Widget 布局动画扩展
extension AnimatedLayoutExtension on Widget {
  /// 带动画的内边距
  /// 
  /// 为 Widget 添加内边距，支持动画效果
  /// 
  /// 参数：
  /// - [all] 所有方向的内边距
  /// - [horizontal] 水平方向的内边距
  /// - [vertical] 垂直方向的内边距
  /// - [top] 顶部内边距
  /// - [bottom] 底部内边距
  /// - [left] 左侧内边距
  /// - [right] 右侧内边距
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello')
  ///   .animate(Duration(milliseconds: 300))
  ///   .animatedPadding(all: 20)
  /// ```
  /// 
  /// 返回带有内边距动画的 Widget
  Widget animatedPadding({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    final padding = EdgeInsets.only(
      top: top ?? vertical ?? all ?? 0.0,
      bottom: bottom ?? vertical ?? all ?? 0.0,
      left: left ?? horizontal ?? all ?? 0.0,
      right: right ?? horizontal ?? all ?? 0.0,
    );
    
    return AnimatedPadding(
      padding: padding,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: this,
    );
  }
  
  /// 带动画的方向性内边距
  /// 
  /// 为 Widget 添加方向性内边距，支持动画效果
  /// 
  /// 参数：
  /// - [all] 所有方向的内边距
  /// - [horizontal] 水平方向的内边距
  /// - [vertical] 垂直方向的内边距
  /// - [top] 顶部内边距
  /// - [bottom] 底部内边距
  /// - [start] 起始方向内边距（LTR 中为左侧，RTL 中为右侧）
  /// - [end] 结束方向内边距（LTR 中为右侧，RTL 中为左侧）
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello')
  ///   .animate(Duration(milliseconds: 300))
  ///   .animatedPaddingDirectional(start: 20, end: 10)
  /// ```
  /// 
  /// 返回带有方向性内边距动画的 Widget
  Widget animatedPaddingDirectional({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? start,
    double? end,
  }) {
    final padding = EdgeInsetsDirectional.only(
      top: top ?? vertical ?? all ?? 0.0,
      bottom: bottom ?? vertical ?? all ?? 0.0,
      start: start ?? horizontal ?? all ?? 0.0,
      end: end ?? horizontal ?? all ?? 0.0,
    );
    
    return AnimatedPadding(
      padding: padding,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: this,
    );
  }
  
  /// 带动画的外边距
  /// 
  /// 为 Widget 添加外边距，支持动画效果
  /// 
  /// 参数：
  /// - [all] 所有方向的外边距
  /// - [horizontal] 水平方向的外边距
  /// - [vertical] 垂直方向的外边距
  /// - [top] 顶部外边距
  /// - [bottom] 底部外边距
  /// - [left] 左侧外边距
  /// - [right] 右侧外边距
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello')
  ///   .animate(Duration(milliseconds: 300))
  ///   .animatedMargin(all: 15)
  /// ```
  /// 
  /// 返回带有外边距动画的 Widget
  Widget animatedMargin({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    final margin = EdgeInsets.only(
      top: top ?? vertical ?? all ?? 0.0,
      bottom: bottom ?? vertical ?? all ?? 0.0,
      left: left ?? horizontal ?? all ?? 0.0,
      right: right ?? horizontal ?? all ?? 0.0,
    );
    
    return AnimatedContainer(
      margin: margin,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: this,
    );
  }
  
  /// 带动画的尺寸约束
  /// 
  /// 为 Widget 添加尺寸约束，支持动画效果
  /// 
  /// 参数：
  /// - [width] 固定宽度
  /// - [height] 固定高度
  /// - [minWidth] 最小宽度
  /// - [maxWidth] 最大宽度
  /// - [minHeight] 最小高度
  /// - [maxHeight] 最大高度
  /// 
  /// 示例：
  /// ```dart
  /// Container()
  ///   .animate(Duration(milliseconds: 500))
  ///   .animatedConstraints(width: 200, height: 100)
  /// ```
  /// 
  /// 返回带有尺寸约束动画的 Widget
  Widget animatedConstraints({
    double? width,
    double? height,
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    final constraints = BoxConstraints(
      minWidth: minWidth ?? (width ?? 0.0),
      maxWidth: maxWidth ?? (width ?? double.infinity),
      minHeight: minHeight ?? (height ?? 0.0),
      maxHeight: maxHeight ?? (height ?? double.infinity),
    );
    
    return AnimatedContainer(
      constraints: constraints,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: this,
    );
  }
  
  /// 带动画的定位
  /// 
  /// 为 Widget 添加绝对定位，支持动画效果
  /// 注意：此方法只能在 Stack 内部使用
  /// 
  /// 参数：
  /// - [left] 距离左边的距离
  /// - [top] 距离顶部的距离
  /// - [right] 距离右边的距离
  /// - [bottom] 距离底部的距离
  /// - [width] 固定宽度
  /// - [height] 固定高度
  /// 
  /// 示例：
  /// ```dart
  /// Stack(
  ///   children: [
  ///     Container()
  ///       .animate(Duration(milliseconds: 400))
  ///       .animatedPositioned(left: 50, top: 100),
  ///   ],
  /// )
  /// ```
  /// 
  /// 返回带有定位动画的 Widget
  Widget animatedPositioned({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) {
    return AnimatedPositioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: this,
    );
  }
  
  /// 带动画的方向性定位
  /// 
  /// 为 Widget 添加方向性绝对定位，支持动画效果
  /// 注意：此方法只能在 Stack 内部使用
  /// 
  /// 参数：
  /// - [start] 距离起始方向的距离（LTR 中为左侧，RTL 中为右侧）
  /// - [end] 距离结束方向的距离（LTR 中为右侧，RTL 中为左侧）
  /// - [top] 距离顶部的距离
  /// - [bottom] 距离底部的距离
  /// - [width] 固定宽度
  /// - [height] 固定高度
  /// 
  /// 示例：
  /// ```dart
  /// Stack(
  ///   children: [
  ///     Container()
  ///       .animate(Duration(milliseconds: 400))
  ///       .animatedPositionedDirectional(start: 20, top: 50),
  ///   ],
  /// )
  /// ```
  /// 
  /// 返回带有方向性定位动画的 Widget
  Widget animatedPositionedDirectional({
    double? start,
    double? end,
    double? top,
    double? bottom,
    double? width,
    double? height,
  }) {
    return AnimatedPositionedDirectional(
      start: start,
      end: end,
      top: top,
      bottom: bottom,
      width: width,
      height: height,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: this,
    );
  }
  
  /// 带动画的对齐
  /// 
  /// 为 Widget 添加对齐方式，支持动画效果
  /// 
  /// 参数：
  /// - [alignment] 对齐方式，默认为 Alignment.center
  /// - [widthFactor] 宽度因子
  /// - [heightFactor] 高度因子
  /// 
  /// 示例：
  /// ```dart
  /// Text('Hello')
  ///   .animate(Duration(milliseconds: 300))
  ///   .animatedAlign(alignment: Alignment.topRight)
  /// ```
  /// 
  /// 返回带有对齐动画的 Widget
  Widget animatedAlign({
    AlignmentGeometry alignment = Alignment.center,
    double? widthFactor,
    double? heightFactor,
  }) {
    return AnimatedAlign(
      alignment: alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: this,
    );
  }
}