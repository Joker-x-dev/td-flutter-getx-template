import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget 工具类扩展
/// 提供各种实用的 Widget 包装和功能
extension UtilityExtension on Widget {
  /// 离屏渲染控制
  /// 
  /// [offstage] 是否离屏（true 时不显示但占用布局空间）
  /// 
  /// 示例:
  /// ```dart
  /// Container().offstage(true) // 隐藏但保留布局空间
  /// ```
  Widget offstage(bool offstage) {
    return Offstage(
      offstage: offstage,
      child: this,
    );
  }

  /// 可见性控制
  /// 
  /// [visible] 是否可见
  /// [maintainSize] 隐藏时是否保持尺寸
  /// [maintainAnimation] 隐藏时是否保持动画
  /// [maintainState] 隐藏时是否保持状态
  /// [maintainInteractivity] 隐藏时是否保持交互性
  /// 
  /// 示例:
  /// ```dart
  /// Container().visibility(
  ///   visible: false,
  ///   maintainSize: true,
  /// )
  /// ```
  Widget visibility(
    bool visible, {
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

  /// 卡片包装
  /// 
  /// [color] 卡片颜色
  /// [shadowColor] 阴影颜色
  /// [surfaceTintColor] 表面着色
  /// [elevation] 阴影高度
  /// [shape] 卡片形状
  /// [borderOnForeground] 边框是否在前景
  /// [margin] 外边距
  /// [clipBehavior] 裁剪行为
  /// [semanticContainer] 是否为语义容器
  /// 
  /// 示例:
  /// ```dart
  /// Container().card(
  ///   elevation: 4,
  ///   margin: EdgeInsets.all(8),
  /// )
  /// ```
  Widget card({
    Color? color,
    Color? shadowColor,
    Color? surfaceTintColor,
    double? elevation,
    ShapeBorder? shape,
    bool borderOnForeground = true,
    EdgeInsetsGeometry? margin,
    Clip? clipBehavior,
    bool semanticContainer = true,
  }) {
    return Card(
      color: color,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      elevation: elevation,
      shape: shape,
      borderOnForeground: borderOnForeground,
      margin: margin,
      clipBehavior: clipBehavior,
      semanticContainer: semanticContainer,
      child: this,
    );
  }

  /// 适配盒子
  /// 
  /// [fit] 适配方式
  /// [alignment] 对齐方式
  /// [clipBehavior] 裁剪行为
  /// 
  /// 示例:
  /// ```dart
  /// Image.asset('image.png').fittedBox(
  ///   fit: BoxFit.cover,
  ///   alignment: Alignment.center,
  /// )
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

  /// 按比例占用空间
  /// 
  /// [widthFactor] 宽度因子
  /// [heightFactor] 高度因子
  /// [alignment] 对齐方式
  /// 
  /// 示例:
  /// ```dart
  /// Container().fractionallySizedBox(
  ///   widthFactor: 0.8,
  ///   heightFactor: 0.6,
  /// )
  /// ```
  Widget fractionallySizedBox({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      alignment: alignment,
      child: this,
    );
  }

  /// 限制盒子
  /// 
  /// [maxWidth] 最大宽度
  /// [maxHeight] 最大高度
  /// 
  /// 示例:
  /// ```dart
  /// Container().limitedBox(
  ///   maxWidth: 200,
  ///   maxHeight: 100,
  /// )
  /// ```
  Widget limitedBox({
    double maxWidth = double.infinity,
    double maxHeight = double.infinity,
  }) {
    return LimitedBox(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      child: this,
    );
  }

  /// 溢出盒子
  /// 
  /// [alignment] 对齐方式
  /// [minWidth] 最小宽度
  /// [maxWidth] 最大宽度
  /// [minHeight] 最小高度
  /// [maxHeight] 最大高度
  /// 
  /// 示例:
  /// ```dart
  /// Container().overflowBox(
  ///   maxWidth: 300,
  ///   maxHeight: 200,
  /// )
  /// ```
  Widget overflowBox({
    AlignmentGeometry alignment = Alignment.center,
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return OverflowBox(
      alignment: alignment,
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
      child: this,
    );
  }



  /// 语义标签
  /// 
  /// [label] 语义标签文本
  /// [hint] 语义提示文本
  /// [value] 语义值
  /// [increasedValue] 增加后的值
  /// [decreasedValue] 减少后的值
  /// [onTap] 点击语义动作
  /// [onLongPress] 长按语义动作
  /// [onScrollLeft] 左滚动语义动作
  /// [onScrollRight] 右滚动语义动作
  /// [onScrollUp] 上滚动语义动作
  /// [onScrollDown] 下滚动语义动作
  /// [onIncrease] 增加语义动作
  /// [onDecrease] 减少语义动作
  /// [onCopy] 复制语义动作
  /// [onCut] 剪切语义动作
  /// [onPaste] 粘贴语义动作
  /// [onDismiss] 关闭语义动作
  /// [onDidGainAccessibilityFocus] 获得无障碍焦点回调
  /// [onDidLoseAccessibilityFocus] 失去无障碍焦点回调
  /// [container] 是否为容器
  /// [explicitChildNodes] 是否显式子节点
  /// [excludeSemantics] 是否排除语义
  /// [enabled] 是否启用
  /// [checked] 是否选中
  /// [selected] 是否被选择
  /// [toggled] 是否切换
  /// [button] 是否为按钮
  /// [slider] 是否为滑块
  /// [keyboardKey] 是否为键盘按键
  /// [link] 是否为链接
  /// [header] 是否为标题
  /// [textField] 是否为文本字段
  /// [readOnly] 是否只读
  /// [focusable] 是否可聚焦
  /// [focused] 是否已聚焦
  /// [inMutuallyExclusiveGroup] 是否在互斥组中
  /// [obscured] 是否被遮挡
  /// [multiline] 是否多行
  /// [scopesRoute] 是否作用域路由
  /// [namesRoute] 是否命名路由
  /// [hidden] 是否隐藏
  /// [image] 是否为图像
  /// [liveRegion] 是否为实时区域
  /// [maxValueLength] 最大值长度
  /// [currentValueLength] 当前值长度
  /// [textDirection] 文本方向
  /// 
  /// 示例:
  /// ```dart
  /// Container().semantics(
  ///   label: '这是一个按钮',
  ///   hint: '点击执行操作',
  ///   button: true,
  /// )
  /// ```
  Widget semantics({
    String? label,
    String? hint,
    String? value,
    String? increasedValue,
    String? decreasedValue,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    VoidCallback? onScrollLeft,
    VoidCallback? onScrollRight,
    VoidCallback? onScrollUp,
    VoidCallback? onScrollDown,
    VoidCallback? onIncrease,
    VoidCallback? onDecrease,
    VoidCallback? onCopy,
    VoidCallback? onCut,
    VoidCallback? onPaste,
    VoidCallback? onDismiss,
    VoidCallback? onDidGainAccessibilityFocus,
    VoidCallback? onDidLoseAccessibilityFocus,
    bool container = false,
    bool explicitChildNodes = false,
    bool excludeSemantics = false,
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
    TextDirection? textDirection,

  }) {
    return Semantics(
      label: label,
      hint: hint,
      value: value,
      increasedValue: increasedValue,
      decreasedValue: decreasedValue,
      onTap: onTap,
      onLongPress: onLongPress,
      onScrollLeft: onScrollLeft,
      onScrollRight: onScrollRight,
      onScrollUp: onScrollUp,
      onScrollDown: onScrollDown,
      onIncrease: onIncrease,
      onDecrease: onDecrease,
      onCopy: onCopy,
      onCut: onCut,
      onPaste: onPaste,
      onDismiss: onDismiss,
      onDidGainAccessibilityFocus: onDidGainAccessibilityFocus,
      onDidLoseAccessibilityFocus: onDidLoseAccessibilityFocus,
      container: container,
      explicitChildNodes: explicitChildNodes,
      excludeSemantics: excludeSemantics,
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
      textDirection: textDirection,

      child: this,
    );
  }

  /// 排除语义
  /// 
  /// [excluding] 是否排除
  /// 
  /// 示例:
  /// ```dart
  /// Container().excludeSemantics(true)
  /// ```
  Widget excludeSemantics({bool excluding = true}) {
    return ExcludeSemantics(
      excluding: excluding,
      child: this,
    );
  }

  /// 合并语义
  /// 
  /// [merging] 是否合并
  /// 
  /// 示例:
  /// ```dart
  /// Row(children: [...]).mergeSemantics(true)
  /// ```
  Widget mergeSemantics() {
    return MergeSemantics(
      child: this,
    );
  }

  /// 阻塞语义
  /// 
  /// [blocking] 是否阻塞
  /// 
  /// 示例:
  /// ```dart
  /// Container().blockSemantics(true)
  /// ```
  Widget blockSemantics({bool blocking = true}) {
    return BlockSemantics(
      blocking: blocking,
      child: this,
    );
  }

  /// 忽略指针事件
  /// 
  /// [ignoring] 是否忽略指针事件
  /// 
  /// 示例:
  /// ```dart
  /// Container().ignorePointer(
  ///   ignoring: true,
  /// )
  /// ```
  Widget ignorePointer({
    bool ignoring = true,
  }) {
    return IgnorePointer(
      ignoring: ignoring,
      child: this,
    );
  }

  /// 吸收指针事件
  /// 
  /// [absorbing] 是否吸收指针事件
  /// 
  /// 示例:
  /// ```dart
  /// Container().absorbPointer(
  ///   absorbing: true,
  /// )
  /// ```
  Widget absorbPointer({
    bool absorbing = true,
  }) {
    return AbsorbPointer(
      absorbing: absorbing,
      child: this,
    );
  }

  /// 监听器
  /// 
  /// [onPointerDown] 指针按下回调
  /// [onPointerMove] 指针移动回调
  /// [onPointerUp] 指针抬起回调
  /// [onPointerCancel] 指针取消回调
  /// [behavior] 命中测试行为
  /// 
  /// 示例:
  /// ```dart
  /// Container().listener(
  ///   onPointerDown: (event) => print('Pointer down'),
  ///   onPointerMove: (event) => print('Pointer move'),
  /// )
  /// ```
  Widget listener({
    PointerDownEventListener? onPointerDown,
    PointerMoveEventListener? onPointerMove,
    PointerUpEventListener? onPointerUp,
    PointerCancelEventListener? onPointerCancel,

    HitTestBehavior behavior = HitTestBehavior.deferToChild,
  }) {
    return Listener(
      onPointerDown: onPointerDown,
      onPointerMove: onPointerMove,
      onPointerUp: onPointerUp,
      onPointerCancel: onPointerCancel,
      behavior: behavior,
      child: this,
    );
  }

  /// 鼠标区域
  /// 
  /// [onEnter] 鼠标进入回调
  /// [onExit] 鼠标退出回调
  /// [onHover] 鼠标悬停回调
  /// [cursor] 鼠标光标
  /// [opaque] 是否不透明
  /// [hitTestBehavior] 命中测试行为
  /// 
  /// 示例:
  /// ```dart
  /// Container().mouseRegion(
  ///   onEnter: (event) => print('Mouse enter'),
  ///   onExit: (event) => print('Mouse exit'),
  ///   cursor: SystemMouseCursors.click,
  /// )
  /// ```
  Widget mouseRegion({
    PointerEnterEventListener? onEnter,
    PointerExitEventListener? onExit,
    PointerHoverEventListener? onHover,
    MouseCursor cursor = MouseCursor.defer,
    bool opaque = true,
    HitTestBehavior? hitTestBehavior,
  }) {
    return MouseRegion(
      onEnter: onEnter,
      onExit: onExit,
      onHover: onHover,
      cursor: cursor,
      opaque: opaque,
      hitTestBehavior: hitTestBehavior,
      child: this,
    );
  }

  /// 重新排序
  /// 
  /// [textDirection] 文本方向
  /// 
  /// 示例:
  /// ```dart
  /// Row(children: [...]).reorderableDelayedDragStartListener(
  ///   textDirection: TextDirection.ltr,
  /// )
  /// ```
  Widget reorderableDelayedDragStartListener({
    TextDirection? textDirection,
  }) {
    return Directionality(
      textDirection: textDirection ?? TextDirection.ltr,
      child: this,
    );
  }

  /// 工具提示
  /// 
  /// [message] 提示消息
  /// [height] 高度
  /// [padding] 内边距
  /// [margin] 外边距
  /// [verticalOffset] 垂直偏移
  /// [preferBelow] 是否优先显示在下方
  /// [excludeFromSemantics] 是否从语义中排除
  /// [decoration] 装饰
  /// [textStyle] 文本样式
  /// [textAlign] 文本对齐
  /// [waitDuration] 等待时长
  /// [showDuration] 显示时长
  /// [triggerMode] 触发模式
  /// [enableFeedback] 是否启用反馈
  /// 
  /// 示例:
  /// ```dart
  /// IconButton(
  ///   icon: Icon(Icons.info),
  ///   onPressed: () {},
  /// ).tooltip(
  ///   message: '这是一个信息按钮',
  ///   preferBelow: false,
  /// )
  /// ```
  Widget tooltip({
    required String message,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? verticalOffset,
    bool? preferBelow,
    bool? excludeFromSemantics,
    Decoration? decoration,
    TextStyle? textStyle,
    TextAlign? textAlign,
    Duration? waitDuration,
    Duration? showDuration,
    TooltipTriggerMode? triggerMode,
    bool? enableFeedback,
  }) {
    return Tooltip(
      message: message,
      padding: padding,
      margin: margin,
      verticalOffset: verticalOffset,
      preferBelow: preferBelow,
      excludeFromSemantics: excludeFromSemantics,
      decoration: decoration,
      textStyle: textStyle,
      textAlign: textAlign,
      waitDuration: waitDuration,
      showDuration: showDuration,
      triggerMode: triggerMode,
      enableFeedback: enableFeedback,
      child: this,
    );
  }

  /// 英雄动画
  /// 
  /// [tag] 英雄标签
  /// [createRectTween] 创建矩形补间
  /// [flightShuttleBuilder] 飞行穿梭构建器
  /// [placeholderBuilder] 占位符构建器
  /// [transitionOnUserGestures] 用户手势时是否过渡
  /// 
  /// 示例:
  /// ```dart
  /// Image.asset('image.png').hero(
  ///   tag: 'hero-image',
  ///   transitionOnUserGestures: true,
  /// )
  /// ```
  Widget hero(
    Object tag, {
    CreateRectTween? createRectTween,
    HeroFlightShuttleBuilder? flightShuttleBuilder,
    HeroPlaceholderBuilder? placeholderBuilder,
    bool transitionOnUserGestures = false,
  }) {
    return Hero(
      tag: tag,
      createRectTween: createRectTween,
      flightShuttleBuilder: flightShuttleBuilder,
      placeholderBuilder: placeholderBuilder,
      transitionOnUserGestures: transitionOnUserGestures,
      child: this,
    );
  }

  /// 自动完成
  /// 
  /// [autofillHints] 自动填充提示
  /// 
  /// 示例:
  /// ```dart
  /// TextField().autofill(
  ///   autofillHints: [AutofillHints.email],
  /// )
  /// ```
  Widget autofill({
    Iterable<String>? autofillHints,
  }) {
    return AutofillGroup(
      child: this,
    );
  }

  /// 焦点
  /// 
  /// [focusNode] 焦点节点
  /// [autofocus] 是否自动聚焦
  /// [onFocusChange] 焦点变化回调
  /// [onKey] 按键回调
  /// [onKeyEvent] 按键事件回调
  /// [canRequestFocus] 是否可以请求焦点
  /// [skipTraversal] 是否跳过遍历
  /// [includeSemantics] 是否包含语义
  /// [debugLabel] 调试标签
  /// 
  /// 示例:
  /// ```dart
  /// TextField().focus(
  ///   autofocus: true,
  ///   onFocusChange: (hasFocus) => print('Focus: $hasFocus'),
  /// )
  /// ```
  Widget focus({
    FocusNode? focusNode,
    bool autofocus = false,
    ValueChanged<bool>? onFocusChange,
    FocusOnKeyEventCallback? onKeyEvent,
    bool canRequestFocus = true,
    bool skipTraversal = false,
    bool includeSemantics = true,
    String? debugLabel,
  }) {
    return Focus(
      focusNode: focusNode,
      autofocus: autofocus,
      onFocusChange: onFocusChange,
      onKeyEvent: onKeyEvent,
      canRequestFocus: canRequestFocus,
      skipTraversal: skipTraversal,
      includeSemantics: includeSemantics,
      debugLabel: debugLabel,
      child: this,
    );
  }
}