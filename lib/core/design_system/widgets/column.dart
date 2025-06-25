import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

import '../theme/layout.dart';

/// 基于styled_widget的Column扩展
extension StyledColumnExtension on List<Widget> {
  /// 创建居中对齐的Column
  ///
  /// [key] - 组件的键，用于标识Widget
  /// [mainAxisSize] - 主轴尺寸，默认为max占满空间
  /// [textDirection] - 文本方向，影响start/end对齐方向
  /// [verticalDirection] - 垂直方向，默认向下
  /// [textBaseline] - 文本基线，用于基线对齐
  /// [separator] - 自定义分隔Widget
  /// [spacing] - 子元素间距，会创建SizedBox作为分隔
  Widget toColumnCenter({
    Key? key,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    Widget? separator,
    double? spacing,
  }) {
    return toColumn(
      key: key,
      mainAxisAlignment: mainCenter,
      crossAxisAlignment: crossCenter,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      separator: spacing != null ? SizedBox(height: spacing) : separator,
    );
  }

  /// 创建靠左对齐的Column
  ///
  /// [key] - 组件的键，用于标识Widget
  /// [mainAxisAlignment] - 主轴对齐方式，默认为起始对齐
  /// [mainAxisSize] - 主轴尺寸，默认为max占满空间
  /// [textDirection] - 文本方向，影响start/end对齐方向
  /// [verticalDirection] - 垂直方向，默认向下
  /// [textBaseline] - 文本基线，用于基线对齐
  /// [separator] - 自定义分隔Widget
  /// [spacing] - 子元素间距，会创建SizedBox作为分隔
  Widget toColumnStart({
    Key? key,
    MainAxisAlignment mainAxisAlignment = mainStart,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    Widget? separator,
    double? spacing,
  }) {
    return toColumn(
      key: key,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossStart,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      separator: spacing != null ? SizedBox(height: spacing) : separator,
    );
  }

  /// 创建靠右对齐的Column
  ///
  /// [key] - 组件的键，用于标识Widget
  /// [mainAxisAlignment] - 主轴对齐方式，默认为起始对齐
  /// [mainAxisSize] - 主轴尺寸，默认为max占满空间
  /// [textDirection] - 文本方向，影响start/end对齐方向
  /// [verticalDirection] - 垂直方向，默认向下
  /// [textBaseline] - 文本基线，用于基线对齐
  /// [separator] - 自定义分隔Widget
  /// [spacing] - 子元素间距，会创建SizedBox作为分隔
  Widget toColumnEnd({
    Key? key,
    MainAxisAlignment mainAxisAlignment = mainStart,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    Widget? separator,
    double? spacing,
  }) {
    return toColumn(
      key: key,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossEnd,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      separator: spacing != null ? SizedBox(height: spacing) : separator,
    );
  }

  /// 创建两端对齐的Column
  ///
  /// [key] - 组件的键，用于标识Widget
  /// [crossAxisAlignment] - 交叉轴对齐方式，默认为居中
  /// [mainAxisSize] - 主轴尺寸，默认为max占满空间
  /// [textDirection] - 文本方向，影响start/end对齐方向
  /// [verticalDirection] - 垂直方向，默认向下
  /// [textBaseline] - 文本基线，用于基线对齐
  /// [separator] - 自定义分隔Widget
  /// [spacing] - 子元素间距，会创建SizedBox作为分隔
  Widget toColumnBetween({
    Key? key,
    CrossAxisAlignment crossAxisAlignment = crossCenter,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    Widget? separator,
    double? spacing,
  }) {
    return toColumn(
      key: key,
      mainAxisAlignment: mainBetween,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      separator: spacing != null ? SizedBox(height: spacing) : separator,
    );
  }

  /// 创建均匀分布的Column（边缘有半个间隔）
  ///
  /// [key] - 组件的键，用于标识Widget
  /// [crossAxisAlignment] - 交叉轴对齐方式，默认为居中
  /// [mainAxisSize] - 主轴尺寸，默认为max占满空间
  /// [textDirection] - 文本方向，影响start/end对齐方向
  /// [verticalDirection] - 垂直方向，默认向下
  /// [textBaseline] - 文本基线，用于基线对齐
  /// [separator] - 自定义分隔Widget
  /// [spacing] - 子元素间距，会创建SizedBox作为分隔
  Widget toColumnAround({
    Key? key,
    CrossAxisAlignment crossAxisAlignment = crossCenter,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    Widget? separator,
    double? spacing,
  }) {
    return toColumn(
      key: key,
      mainAxisAlignment: mainAround,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      separator: spacing != null ? SizedBox(height: spacing) : separator,
    );
  }

  /// 创建均匀分布包括边缘的Column
  ///
  /// [key] - 组件的键，用于标识Widget
  /// [crossAxisAlignment] - 交叉轴对齐方式，默认为居中
  /// [mainAxisSize] - 主轴尺寸，默认为max占满空间
  /// [textDirection] - 文本方向，影响start/end对齐方向
  /// [verticalDirection] - 垂直方向，默认向下
  /// [textBaseline] - 文本基线，用于基线对齐
  /// [separator] - 自定义分隔Widget
  /// [spacing] - 子元素间距，会创建SizedBox作为分隔
  Widget toColumnEvenly({
    Key? key,
    CrossAxisAlignment crossAxisAlignment = crossCenter,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    Widget? separator,
    double? spacing,
  }) {
    return toColumn(
      key: key,
      mainAxisAlignment: mainEvenly,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      separator: spacing != null ? SizedBox(height: spacing) : separator,
    );
  }

  /// 创建填充式的Column（子元素拉伸填充宽度）
  ///
  /// [key] - 组件的键，用于标识Widget
  /// [mainAxisAlignment] - 主轴对齐方式，默认为起始对齐
  /// [mainAxisSize] - 主轴尺寸，默认为max占满空间
  /// [textDirection] - 文本方向，影响start/end对齐方向
  /// [verticalDirection] - 垂直方向，默认向下
  /// [textBaseline] - 文本基线，用于基线对齐
  /// [separator] - 自定义分隔Widget
  /// [spacing] - 子元素间距，会创建SizedBox作为分隔
  Widget toColumnStretch({
    Key? key,
    MainAxisAlignment mainAxisAlignment = mainStart,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    Widget? separator,
    double? spacing,
  }) {
    return toColumn(
      key: key,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossStretch,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      separator: spacing != null ? SizedBox(height: spacing) : separator,
    );
  }
}
