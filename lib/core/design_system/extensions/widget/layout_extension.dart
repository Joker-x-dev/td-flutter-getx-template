import 'package:flutter/material.dart';

/// Widget 布局相关扩展
/// 提供对齐、弹性布局、定位、安全区域等布局方法
///
/// @author
extension LayoutExtension on Widget {
  /// 设置 Widget 的对齐方式
  ///
  /// [alignment] 对齐方式
  /// [widthFactor] 宽度因子
  /// [heightFactor] 高度因子
  ///
  /// 示例:
  /// ```dart
  /// Container().alignment(Alignment.center)
  /// ```
  Widget alignment(
    AlignmentGeometry alignment, {
    double? widthFactor,
    double? heightFactor,
  }) {
    return Align(
      alignment: alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: this,
    );
  }

  /// 居中对齐 Widget
  ///
  /// [widthFactor] 宽度因子
  /// [heightFactor] 高度因子
  ///
  /// 示例:
  /// ```dart
  /// Container().center()
  /// ```
  Widget center({double? widthFactor, double? heightFactor}) {
    return Center(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: this,
    );
  }

  /// 设置 Widget 为可扩展（Expanded）
  ///
  /// [flex] 弹性系数
  ///
  /// 示例:
  /// ```dart
  /// Container().expanded(flex: 2)
  /// ```
  Widget expanded({int flex = 1}) {
    return Expanded(flex: flex, child: this);
  }

  /// 设置 Widget 为弹性（Flexible）
  ///
  /// [flex] 弹性系数
  /// [fit] 适配方式
  ///
  /// 示例:
  /// ```dart
  /// Container().flexible(flex: 1, fit: FlexFit.loose)
  /// ```
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) {
    return Flexible(flex: flex, fit: fit, child: this);
  }

  /// 设置 Widget 的绝对定位
  ///
  /// [left] 左边距
  /// [top] 上边距
  /// [right] 右边距
  /// [bottom] 下边距
  /// [width] 宽度
  /// [height] 高度
  ///
  /// 示例:
  /// ```dart
  /// Container().positioned(
  ///   left: 10,
  ///   top: 20,
  ///   width: 100,
  ///   height: 50,
  /// )
  /// ```
  Widget positioned({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: this,
    );
  }

  /// 设置 Widget 的方向性定位（支持 RTL）
  ///
  /// [start] 起始边距
  /// [top] 上边距
  /// [end] 结束边距
  /// [bottom] 下边距
  /// [width] 宽度
  /// [height] 高度
  ///
  /// 示例:
  /// ```dart
  /// Container().positionedDirectional(
  ///   start: 10,
  ///   top: 20,
  ///   width: 100,
  ///   height: 50,
  /// )
  /// ```
  Widget positionedDirectional({
    double? start,
    double? top,
    double? end,
    double? bottom,
    double? width,
    double? height,
  }) {
    return PositionedDirectional(
      start: start,
      top: top,
      end: end,
      bottom: bottom,
      width: width,
      height: height,
      child: this,
    );
  }

  /// 填充整个父容器
  ///
  /// 示例:
  /// ```dart
  /// Container().positionedFill()
  /// ```
  Widget positionedFill({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return Positioned.fill(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: this,
    );
  }

  /// 设置 Widget 的安全区域
  ///
  /// [left] 是否保留左侧安全区域
  /// [top] 是否保留顶部安全区域
  /// [right] 是否保留右侧安全区域
  /// [bottom] 是否保留底部安全区域
  /// [minimum] 最小边距
  /// [maintainBottomViewPadding] 是否保持底部视图内边距
  ///
  /// 示例:
  /// ```dart
  /// Container().safeArea()
  /// ```
  Widget safeArea({
    bool left = true,
    bool top = true,
    bool right = true,
    bool bottom = true,
    EdgeInsets minimum = EdgeInsets.zero,
    bool maintainBottomViewPadding = false,
  }) {
    return SafeArea(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      minimum: minimum,
      maintainBottomViewPadding: maintainBottomViewPadding,
      child: this,
    );
  }

  /// 设置 Widget 的溢出处理
  ///
  /// [minWidth] 最小宽度
  /// [maxWidth] 最大宽度
  /// [minHeight] 最小高度
  /// [maxHeight] 最大高度
  /// [alignment] 对齐方式
  ///
  /// 示例:
  /// ```dart
  /// Container().overflow(
  ///   minWidth: 0,
  ///   maxWidth: 200,
  ///   minHeight: 0,
  ///   maxHeight: 100,
  /// )
  /// ```
  Widget overflow({
    double minWidth = 0.0,
    double maxWidth = double.infinity,
    double minHeight = 0.0,
    double maxHeight = double.infinity,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return OverflowBox(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
      alignment: alignment,
      child: this,
    );
  }

  /// 设置 Widget 的适配方式
  ///
  /// [fit] 适配方式
  /// [alignment] 对齐方式
  /// [clipBehavior] 裁剪行为
  ///
  /// 示例:
  /// ```dart
  /// Container().fittedBox(fit: BoxFit.contain)
  /// ```
  Widget fittedBox({
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    Clip clipBehavior = Clip.none,
  }) {
    return FittedBox(
      fit: fit,
      alignment: alignment,
      clipBehavior: clipBehavior,
      child: this,
    );
  }

  /// 设置 Widget 的基线对齐
  ///
  /// [baseline] 基线位置
  /// [baselineType] 基线类型
  ///
  /// 示例:
  /// ```dart
  /// Container().baseline(
  ///   baseline: 20,
  ///   baselineType: TextBaseline.alphabetic,
  /// )
  /// ```
  Widget baseline({
    required double baseline,
    required TextBaseline baselineType,
  }) {
    return Baseline(
      baseline: baseline,
      baselineType: baselineType,
      child: this,
    );
  }

  /// 设置 Widget 的语义标签
  ///
  /// [label] 语义标签
  /// [value] 语义值
  /// [hint] 语义提示
  /// [onTap] 点击回调
  /// [onLongPress] 长按回调
  /// [textDirection] 文本方向
  /// [excludeSemantics] 是否排除语义
  /// [explicitChildNodes] 是否显式子节点
  /// [enabled] 是否启用
  /// [checked] 是否选中
  /// [selected] 是否选择
  /// [toggled] 是否切换
  /// [button] 是否为按钮
  /// [slider] 是否为滑块
  /// [keyboardKey] 是否为键盘键
  /// [link] 是否为链接
  /// [header] 是否为标题
  /// [textField] 是否为文本字段
  /// [readOnly] 是否只读
  /// [focusable] 是否可聚焦
  /// [focused] 是否聚焦
  /// [inMutuallyExclusiveGroup] 是否在互斥组中
  /// [obscured] 是否模糊
  /// [multiline] 是否多行
  /// [scopesRoute] 是否作用域路由
  /// [namesRoute] 是否命名路由
  /// [hidden] 是否隐藏
  /// [image] 是否为图像
  /// [liveRegion] 是否为实时区域
  /// [maxValueLength] 最大值长度
  /// [currentValueLength] 当前值长度
  /// [container] 是否为容器
  ///
  /// 示例:
  /// ```dart
  /// Container().semantics(
  ///   label: '按钮',
  ///   button: true,
  /// )
  /// ```
  Widget semantics({
    String? label,
    String? value,
    String? hint,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    TextDirection? textDirection,
    bool excludeSemantics = false,
    bool? explicitChildNodes,
    bool? enabled,
    bool? checked,
    bool? selected,
    bool? toggled,
    bool? button,
    bool? slider,
    bool? keyboardKey,
    bool? link,
    bool? header,
    bool? textField,
    bool? readOnly,
    bool? focusable,
    bool? focused,
    bool? inMutuallyExclusiveGroup,
    bool? obscured,
    bool? multiline,
    bool? scopesRoute,
    bool? namesRoute,
    bool? hidden,
    bool? image,
    bool? liveRegion,
    int? maxValueLength,
    int? currentValueLength,
    bool? container,
  }) {
    return Semantics(
      label: label,
      value: value,
      hint: hint,
      onTap: onTap,
      onLongPress: onLongPress,
      textDirection: textDirection,
      excludeSemantics: excludeSemantics,
      explicitChildNodes: explicitChildNodes ?? false,
      enabled: enabled,
      checked: checked,
      selected: selected,
      toggled: toggled,
      button: button,
      slider: slider,
      keyboardKey: keyboardKey,
      link: link,
      header: header,
      textField: textField,
      readOnly: readOnly,
      focusable: focusable,
      focused: focused,
      inMutuallyExclusiveGroup: inMutuallyExclusiveGroup,
      obscured: obscured,
      multiline: multiline,
      scopesRoute: scopesRoute,
      namesRoute: namesRoute,
      hidden: hidden,
      image: image,
      liveRegion: liveRegion,
      maxValueLength: maxValueLength,
      currentValueLength: currentValueLength,
      container: container ?? false,
      child: this,
    );
  }

  /// 设置 Widget 的可见性
  ///
  /// [visible] 是否可见
  /// [maintainSize] 是否保持尺寸
  /// [maintainAnimation] 是否保持动画
  /// [maintainState] 是否保持状态
  /// [maintainInteractivity] 是否保持交互性
  ///
  /// 示例:
  /// ```dart
  /// Container().visibility(
  ///   visible: false,
  ///   maintainSize: true,
  /// )
  /// ```
  Widget visibility({
    required bool visible,
    bool maintainSize = false,
    bool maintainAnimation = false,
    bool maintainState = false,
    bool maintainInteractivity = false,
  }) {
    return Visibility(
      visible: visible,
      maintainSize: maintainSize,
      maintainAnimation: maintainAnimation,
      maintainState: maintainState,
      maintainInteractivity: maintainInteractivity,
      child: this,
    );
  }

  /// 设置 Widget 为离屏状态
  ///
  /// [offstage] 是否离屏
  ///
  /// 示例:
  /// ```dart
  /// Container().offstage(true)
  /// ```
  Widget offstage([bool offstage = true]) {
    return Offstage(offstage: offstage, child: this);
  }



  /// 忽略语义
  ///
  /// [excluding] 是否排除语义，默认为 true
  /// 返回排除语义的 Widget
  Widget ignoringSemantics({bool excluding = true}) {
    return ExcludeSemantics(
      excluding: excluding,
      child: this,
    );
  }
}
