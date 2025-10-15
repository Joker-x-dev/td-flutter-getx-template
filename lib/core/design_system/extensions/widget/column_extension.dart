import 'package:flutter/material.dart';

/// List&lt;Widget&gt; 的 Column 扩展
/// 
/// 提供各种 Column 布局相关的扩展方法，支持链式调用
/// 基于 List&lt;Widget&gt; 扩展，提供更简洁易用的 Column 布局方法
extension ColumnExtension on List<Widget> {
  /// 创建基础 Column 布局
  ///
  /// [key] - 组件的键，用于标识 Widget
  /// [mainAxisAlignment] - 主轴对齐方式，默认为起始对齐
  /// [mainAxisSize] - 主轴尺寸，默认为 max 占满空间
  /// [crossAxisAlignment] - 交叉轴对齐方式，默认为居中
  /// [textDirection] - 文本方向，影响 start/end 对齐方向
  /// [verticalDirection] - 垂直方向，默认向下
  /// [textBaseline] - 文本基线，用于基线对齐
  /// [spacing] - 子元素间距，会创建 SizedBox 作为分隔
  /// [separator] - 自定义分隔 Widget
  ///
  /// 示例:
  /// ```dart
  /// [
  ///   Text('第一行'),
  ///   Text('第二行'),
  ///   Text('第三行'),
  /// ].toColumn(spacing: 10.0);
  /// ```
  Widget toColumn({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    double? spacing,
    Widget? separator,
  }) {
    List<Widget> finalChildren = this;
    
    // 处理间距
    if (spacing != null && spacing > 0 && length > 1) {
      finalChildren = [];
      for (int i = 0; i < length; i++) {
        finalChildren.add(this[i]);
        if (i < length - 1) {
          finalChildren.add(SizedBox(height: spacing));
        }
      }
    }
    
    // 处理自定义分隔符
    if (separator != null && length > 1) {
      finalChildren = [];
      for (int i = 0; i < length; i++) {
        finalChildren.add(this[i]);
        if (i < length - 1) {
          finalChildren.add(separator);
        }
      }
    }
    
    return Column(
      key: key,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: finalChildren,
    );
  }

  /// 创建居中对齐的 Column
  ///
  /// [key] - 组件的键，用于标识 Widget
  /// [mainAxisSize] - 主轴尺寸，默认为 max 占满空间
  /// [textDirection] - 文本方向，影响 start/end 对齐方向
  /// [verticalDirection] - 垂直方向，默认向下
  /// [textBaseline] - 文本基线，用于基线对齐
  /// [spacing] - 子元素间距，会创建 SizedBox 作为分隔
  /// [separator] - 自定义分隔 Widget
  ///
  /// 示例:
  /// ```dart
  /// [
  ///   Icon(Icons.star),
  ///   Text('居中显示'),
  ///   ElevatedButton(onPressed: () {}, child: Text('按钮')),
  /// ].toColumnCenter();
  /// ```
  Widget toColumnCenter({
    Key? key,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    double? spacing,
    Widget? separator,
  }) {
    return toColumn(
      key: key,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: CrossAxisAlignment.center,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      spacing: spacing,
      separator: separator,
    );
  }

  /// 创建两端对齐的 Column
  ///
  /// [key] - 组件的键，用于标识 Widget
  /// [crossAxisAlignment] - 交叉轴对齐方式，默认为居中
  /// [mainAxisSize] - 主轴尺寸，默认为 max 占满空间
  /// [textDirection] - 文本方向，影响 start/end 对齐方向
  /// [verticalDirection] - 垂直方向，默认向下
  /// [textBaseline] - 文本基线，用于基线对齐
  /// [spacing] - 子元素间距，会创建 SizedBox 作为分隔
  /// [separator] - 自定义分隔 Widget
  ///
  /// 示例:
  /// ```dart
  /// [
  ///   Text('顶部内容'),
  ///   Text('底部内容'),
  /// ].toColumnBetween();
  /// ```
  Widget toColumnBetween({
    Key? key,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    double? spacing,
    Widget? separator,
  }) {
    return toColumn(
      key: key,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      spacing: spacing,
      separator: separator,
    );
  }

  /// 创建均匀分布的 Column（边缘有半个间隔）
  ///
  /// [key] - 组件的键，用于标识 Widget
  /// [crossAxisAlignment] - 交叉轴对齐方式，默认为居中
  /// [mainAxisSize] - 主轴尺寸，默认为 max 占满空间
  /// [textDirection] - 文本方向，影响 start/end 对齐方向
  /// [verticalDirection] - 垂直方向，默认向下
  /// [textBaseline] - 文本基线，用于基线对齐
  /// [spacing] - 子元素间距，会创建 SizedBox 作为分隔
  /// [separator] - 自定义分隔 Widget
  ///
  /// 示例:
  /// ```dart
  /// [
  ///   Text('第一个'),
  ///   Text('第二个'),
  ///   Text('第三个'),
  /// ].toColumnAround();
  /// ```
  Widget toColumnAround({
    Key? key,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    double? spacing,
    Widget? separator,
  }) {
    return toColumn(
      key: key,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      spacing: spacing,
      separator: separator,
    );
  }

  /// 创建均匀分布包括边缘的 Column
  ///
  /// [key] - 组件的键，用于标识 Widget
  /// [crossAxisAlignment] - 交叉轴对齐方式，默认为居中
  /// [mainAxisSize] - 主轴尺寸，默认为 max 占满空间
  /// [textDirection] - 文本方向，影响 start/end 对齐方向
  /// [verticalDirection] - 垂直方向，默认向下
  /// [textBaseline] - 文本基线，用于基线对齐
  /// [spacing] - 子元素间距，会创建 SizedBox 作为分隔
  /// [separator] - 自定义分隔 Widget
  ///
  /// 示例:
  /// ```dart
  /// [
  ///   Icon(Icons.home),
  ///   Icon(Icons.search),
  ///   Icon(Icons.settings),
  /// ].toColumnEvenly();
  /// ```
  Widget toColumnEvenly({
    Key? key,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    double? spacing,
    Widget? separator,
  }) {
    return toColumn(
      key: key,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      spacing: spacing,
      separator: separator,
    );
  }

  /// 创建靠左对齐的 Column
  ///
  /// [key] - 组件的键，用于标识 Widget
  /// [mainAxisAlignment] - 主轴对齐方式，默认为起始对齐
  /// [mainAxisSize] - 主轴尺寸，默认为 max 占满空间
  /// [textDirection] - 文本方向，影响 start/end 对齐方向
  /// [verticalDirection] - 垂直方向，默认向下
  /// [textBaseline] - 文本基线，用于基线对齐
  /// [spacing] - 子元素间距，会创建 SizedBox 作为分隔
  /// [separator] - 自定义分隔 Widget
  ///
  /// 示例:
  /// ```dart
  /// [
  ///   Text('左对齐文本1'),
  ///   Text('左对齐文本2'),
  ///   Text('左对齐文本3'),
  /// ].toColumnStart();
  /// ```
  Widget toColumnStart({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    double? spacing,
    Widget? separator,
  }) {
    return toColumn(
      key: key,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      spacing: spacing,
      separator: separator,
    );
  }

  /// 创建靠右对齐的 Column
  ///
  /// [key] - 组件的键，用于标识 Widget
  /// [mainAxisAlignment] - 主轴对齐方式，默认为起始对齐
  /// [mainAxisSize] - 主轴尺寸，默认为 max 占满空间
  /// [textDirection] - 文本方向，影响 start/end 对齐方向
  /// [verticalDirection] - 垂直方向，默认向下
  /// [textBaseline] - 文本基线，用于基线对齐
  /// [spacing] - 子元素间距，会创建 SizedBox 作为分隔
  /// [separator] - 自定义分隔 Widget
  ///
  /// 示例:
  /// ```dart
  /// [
  ///   Text('右对齐文本1'),
  ///   Text('右对齐文本2'),
  ///   Text('右对齐文本3'),
  /// ].toColumnEnd();
  /// ```
  Widget toColumnEnd({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    double? spacing,
    Widget? separator,
  }) {
    return toColumn(
      key: key,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: CrossAxisAlignment.end,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      spacing: spacing,
      separator: separator,
    );
  }

  /// 创建填充式的 Column（子元素拉伸填充宽度）
  ///
  /// [key] - 组件的键，用于标识 Widget
  /// [mainAxisAlignment] - 主轴对齐方式，默认为起始对齐
  /// [mainAxisSize] - 主轴尺寸，默认为 max 占满空间
  /// [textDirection] - 文本方向，影响 start/end 对齐方向
  /// [verticalDirection] - 垂直方向，默认向下
  /// [textBaseline] - 文本基线，用于基线对齐
  /// [spacing] - 子元素间距，会创建 SizedBox 作为分隔
  /// [separator] - 自定义分隔 Widget
  ///
  /// 示例:
  /// ```dart
  /// [
  ///   Container(height: 50, color: Colors.red),
  ///   Container(height: 50, color: Colors.blue),
  ///   Container(height: 50, color: Colors.green),
  /// ].toColumnStretch();
  /// ```
  Widget toColumnStretch({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    double? spacing,
    Widget? separator,
  }) {
    return toColumn(
      key: key,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      spacing: spacing,
      separator: separator,
    );
  }
}