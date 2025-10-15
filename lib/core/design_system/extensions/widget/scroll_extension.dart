import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Widget 滚动扩展
/// 
/// 提供各种滚动相关的扩展方法，包括：
/// - 基础滚动配置
/// - 不同滚动物理效果
/// - 滚动控制器设置
/// - 自定义滚动配置
/// 
/// 作者: Assistant
/// 创建时间: 2024
extension ScrollExtension on Widget {
  /// 基础滚动容器
  ///
  /// [scrollDirection] 滚动方向，默认为垂直滚动
  /// [reverse] 是否反向滚动，默认为 false
  /// [controller] 滚动控制器
  /// [primary] 是否为主滚动视图
  /// [physics] 滚动物理效果
  /// [shrinkWrap] 是否根据内容调整大小，默认为 false
  /// [padding] 内边距
  ///
  /// 示例:
  /// ```dart
  /// Column(children: widgets).scrollable();
  /// ```
  Widget scrollable({
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
  }) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      padding: padding,
      child: this,
    );
  }

  /// 垂直滚动
  ///
  /// [reverse] 是否反向滚动，默认为 false
  /// [controller] 滚动控制器
  /// [primary] 是否为主滚动视图
  /// [physics] 滚动物理效果
  /// [shrinkWrap] 是否根据内容调整大小，默认为 false
  /// [padding] 内边距
  ///
  /// 示例:
  /// ```dart
  /// Column(children: widgets).verticalScroll();
  /// ```
  Widget verticalScroll({
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      padding: padding,
      child: this,
    );
  }

  /// 水平滚动
  ///
  /// [reverse] 是否反向滚动，默认为 false
  /// [controller] 滚动控制器
  /// [primary] 是否为主滚动视图
  /// [physics] 滚动物理效果
  /// [shrinkWrap] 是否根据内容调整大小，默认为 false
  /// [padding] 内边距
  ///
  /// 示例:
  /// ```dart
  /// Row(children: widgets).horizontalScroll();
  /// ```
  Widget horizontalScroll({
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      padding: padding,
      child: this,
    );
  }

  /// 设置滚动物理效果
  ///
  /// [physics] 滚动物理效果
  /// [scrollDirection] 滚动方向，默认为垂直滚动
  /// [reverse] 是否反向滚动，默认为 false
  /// [controller] 滚动控制器
  /// [primary] 是否为主滚动视图
  /// [shrinkWrap] 是否根据内容调整大小，默认为 false
  /// [padding] 内边距
  ///
  /// 示例:
  /// ```dart
  /// Column(children: widgets).scrollPhysics(BouncingScrollPhysics());
  /// ```
  Widget scrollPhysics(
    ScrollPhysics physics, {
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
  }) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      padding: padding,
      child: this,
    );
  }

  /// 设置滚动控制器
  ///
  /// [controller] 滚动控制器
  /// [scrollDirection] 滚动方向，默认为垂直滚动
  /// [reverse] 是否反向滚动，默认为 false
  /// [primary] 是否为主滚动视图
  /// [physics] 滚动物理效果
  /// [shrinkWrap] 是否根据内容调整大小，默认为 false
  /// [padding] 内边距
  ///
  /// 示例:
  /// ```dart
  /// final controller = ScrollController();
  /// Column(children: widgets).scrollController(controller);
  /// ```
  Widget scrollController(
    ScrollController controller, {
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
  }) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      padding: padding,
      child: this,
    );
  }

  /// 弹性滚动效果（iOS 风格）
  ///
  /// [scrollDirection] 滚动方向，默认为垂直滚动
  /// [reverse] 是否反向滚动，默认为 false
  /// [controller] 滚动控制器
  /// [primary] 是否为主滚动视图
  /// [shrinkWrap] 是否根据内容调整大小，默认为 false
  /// [padding] 内边距
  ///
  /// 示例:
  /// ```dart
  /// Column(children: widgets).bouncingScroll();
  /// ```
  Widget bouncingScroll({
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
  }) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: const BouncingScrollPhysics(),
      padding: padding,
      child: this,
    );
  }

  /// 夹紧滚动效果（Android 风格）
  ///
  /// [scrollDirection] 滚动方向，默认为垂直滚动
  /// [reverse] 是否反向滚动，默认为 false
  /// [controller] 滚动控制器
  /// [primary] 是否为主滚动视图
  /// [shrinkWrap] 是否根据内容调整大小，默认为 false
  /// [padding] 内边距
  ///
  /// 示例:
  /// ```dart
  /// Column(children: widgets).clampingScroll();
  /// ```
  Widget clampingScroll({
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
  }) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: const ClampingScrollPhysics(),
      padding: padding,
      child: this,
    );
  }

  /// 永不滚动效果
  ///
  /// [scrollDirection] 滚动方向，默认为垂直滚动
  /// [reverse] 是否反向滚动，默认为 false
  /// [controller] 滚动控制器
  /// [primary] 是否为主滚动视图
  /// [shrinkWrap] 是否根据内容调整大小，默认为 false
  /// [padding] 内边距
  ///
  /// 示例:
  /// ```dart
  /// Column(children: widgets).neverScroll();
  /// ```
  Widget neverScroll({
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
  }) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding,
      child: this,
    );
  }

  /// 自定义滚动视图
  ///
  /// 提供完整的滚动配置选项
  ///
  /// [scrollDirection] 滚动方向，默认为垂直滚动
  /// [reverse] 是否反向滚动，默认为 false
  /// [controller] 滚动控制器
  /// [primary] 是否为主滚动视图
  /// [physics] 滚动物理效果
  /// [shrinkWrap] 是否根据内容调整大小，默认为 false
  /// [padding] 内边距
  /// [dragStartBehavior] 拖拽开始行为
  /// [clipBehavior] 裁剪行为
  /// [restorationId] 恢复 ID
  /// [keyboardDismissBehavior] 键盘消失行为
  ///
  /// 示例:
  /// ```dart
  /// Column(children: widgets).customScroll(
  ///   physics: BouncingScrollPhysics(),
  ///   padding: EdgeInsets.all(16),
  ///   keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
  /// );
  /// ```
  Widget customScroll({
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    Clip clipBehavior = Clip.hardEdge,
    String? restorationId,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
  }) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      padding: padding,
      dragStartBehavior: dragStartBehavior,
      clipBehavior: clipBehavior,
      restorationId: restorationId,
      keyboardDismissBehavior: keyboardDismissBehavior,
      child: this,
    );
  }
}