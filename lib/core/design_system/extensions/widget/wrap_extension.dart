/// Wrap 布局扩展
///
/// 为 List<Widget> 提供便捷的 Wrap 布局转换方法
/// 支持自动换行的流式布局配置选项

import 'package:flutter/material.dart';

/// Wrap 布局扩展
///
/// 为 Widget 列表提供转换为 Wrap 布局的便捷方法
extension WrapExtension on List<Widget> {
  /// 将 Widget 列表转换为 Wrap 布局
  ///
  /// Wrap 是一个流式布局容器，当子组件在主轴方向上空间不足时会自动换行
  /// 类似于 Row 和 Column 的结合体，支持水平和垂直方向的自动换行
  ///
  /// [key] Wrap 的唯一标识符
  /// [direction] 主轴方向，默认为水平方向
  /// [alignment] 主轴对齐方式，默认为起始位置对齐
  /// [spacing] 主轴方向上子组件之间的间距，默认为 0
  /// [runAlignment] 交叉轴方向上行与行之间的对齐方式，默认为起始位置对齐
  /// [runSpacing] 交叉轴方向上行与行之间的间距，默认为 0
  /// [crossAxisAlignment] 交叉轴方向上子组件的对齐方式，默认为起始位置对齐
  /// [textDirection] 文本方向，影响对齐方式的计算
  /// [verticalDirection] 垂直方向，影响垂直对齐的计算
  /// [clipBehavior] 裁剪行为，默认为不裁剪
  ///
  /// 返回配置好的 Wrap 组件
  ///
  /// 示例:
  /// ```dart
  /// // 基础的标签布局
  /// [
  ///   Chip(label: Text('Flutter')),
  ///   Chip(label: Text('Dart')),
  ///   Chip(label: Text('Mobile')),
  ///   Chip(label: Text('Development')),
  /// ].toWrap(
  ///   spacing: 8.0,
  ///   runSpacing: 4.0,
  /// )
  ///
  /// // 垂直方向的流式布局
  /// [
  ///   Container(width: 50, height: 50, color: Colors.red),
  ///   Container(width: 50, height: 80, color: Colors.blue),
  ///   Container(width: 50, height: 60, color: Colors.green),
  /// ].toWrap(
  ///   direction: Axis.vertical,
  ///   alignment: WrapAlignment.center,
  ///   spacing: 10.0,
  /// )
  ///
  /// // 居中对齐的按钮组
  /// [
  ///   ElevatedButton(onPressed: () {}, child: Text('按钮1')),
  ///   ElevatedButton(onPressed: () {}, child: Text('按钮2')),
  ///   ElevatedButton(onPressed: () {}, child: Text('按钮3')),
  /// ].toWrap(
  ///   alignment: WrapAlignment.center,
  ///   runAlignment: WrapAlignment.center,
  ///   spacing: 12.0,
  ///   runSpacing: 8.0,
  /// )
  /// ```
  Widget toWrap({
    Key? key,
    Axis direction = Axis.horizontal,
    WrapAlignment alignment = WrapAlignment.start,
    double spacing = 0.0,
    WrapAlignment runAlignment = WrapAlignment.start,
    double runSpacing = 0.0,
    WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.start,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    Clip clipBehavior = Clip.none,
  }) {
    return Wrap(
      key: key,
      direction: direction,
      alignment: alignment,
      spacing: spacing,
      runAlignment: runAlignment,
      runSpacing: runSpacing,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      clipBehavior: clipBehavior,
      children: this,
    );
  }

  /// 将 Widget 列表转换为带间距的 Wrap 布局
  ///
  /// 这是一个便捷方法，为子组件之间添加统一的间距
  /// 适用于需要在子组件之间保持一致间距的场景
  ///
  /// [spacing] 主轴方向上子组件之间的间距，默认为 8.0
  /// [runSpacing] 交叉轴方向上行与行之间的间距，默认为 8.0
  /// [key] Wrap 的唯一标识符
  /// [direction] 主轴方向，默认为水平方向
  /// [alignment] 主轴对齐方式，默认为起始位置对齐
  /// [runAlignment] 交叉轴方向上行与行之间的对齐方式，默认为起始位置对齐
  ///
  /// 返回带间距的 Wrap 组件
  ///
  /// 示例:
  /// ```dart
  /// // 创建带间距的标签组
  /// [
  ///   Chip(label: Text('标签1')),
  ///   Chip(label: Text('标签2')),
  ///   Chip(label: Text('标签3')),
  ///   Chip(label: Text('标签4')),
  /// ].toSpacedWrap()
  ///
  /// // 自定义间距的按钮组
  /// [
  ///   OutlinedButton(onPressed: () {}, child: Text('选项1')),
  ///   OutlinedButton(onPressed: () {}, child: Text('选项2')),
  ///   OutlinedButton(onPressed: () {}, child: Text('选项3')),
  /// ].toSpacedWrap(
  ///   spacing: 12.0,
  ///   runSpacing: 6.0,
  /// )
  ///
  /// // 垂直方向的间距布局
  /// [
  ///   Container(width: 60, height: 40, color: Colors.red),
  ///   Container(width: 60, height: 40, color: Colors.blue),
  ///   Container(width: 60, height: 40, color: Colors.green),
  /// ].toSpacedWrap(
  ///   direction: Axis.vertical,
  ///   spacing: 10.0,
  /// )
  /// ```
  Widget toSpacedWrap({
    double spacing = 8.0,
    double runSpacing = 8.0,
    Key? key,
    Axis direction = Axis.horizontal,
    WrapAlignment alignment = WrapAlignment.start,
    WrapAlignment runAlignment = WrapAlignment.start,
  }) {
    return Wrap(
      key: key,
      direction: direction,
      alignment: alignment,
      spacing: spacing,
      runAlignment: runAlignment,
      runSpacing: runSpacing,
      children: this,
    );
  }

  /// 将 Widget 列表转换为居中对齐的 Wrap 布局
  ///
  /// 这是一个便捷方法，所有子组件都会在主轴和交叉轴方向上居中对齐
  /// 适用于需要居中显示的标签、按钮组等场景
  ///
  /// [spacing] 主轴方向上子组件之间的间距，默认为 8.0
  /// [runSpacing] 交叉轴方向上行与行之间的间距，默认为 8.0
  /// [key] Wrap 的唯一标识符
  /// [direction] 主轴方向，默认为水平方向
  /// [crossAxisAlignment] 交叉轴方向上子组件的对齐方式，默认为居中对齐
  ///
  /// 返回居中对齐的 Wrap 组件
  ///
  /// 示例:
  /// ```dart
  /// // 创建居中的标签组
  /// [
  ///   Chip(label: Text('热门')),
  ///   Chip(label: Text('推荐')),
  ///   Chip(label: Text('最新')),
  /// ].toCenteredWrap()
  ///
  /// // 居中的操作按钮组
  /// [
  ///   ElevatedButton(onPressed: () {}, child: Text('确定')),
  ///   OutlinedButton(onPressed: () {}, child: Text('取消')),
  ///   TextButton(onPressed: () {}, child: Text('重置')),
  /// ].toCenteredWrap(
  ///   spacing: 16.0,
  ///   runSpacing: 12.0,
  /// )
  ///
  /// // 垂直居中的图标组
  /// [
  ///   Icon(Icons.home, size: 32),
  ///   Icon(Icons.search, size: 32),
  ///   Icon(Icons.favorite, size: 32),
  ///   Icon(Icons.person, size: 32),
  /// ].toCenteredWrap(
  ///   direction: Axis.vertical,
  ///   spacing: 20.0,
  /// )
  /// ```
  Widget toCenteredWrap({
    double spacing = 8.0,
    double runSpacing = 8.0,
    Key? key,
    Axis direction = Axis.horizontal,
    WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.center,
  }) {
    return Wrap(
      key: key,
      direction: direction,
      alignment: WrapAlignment.center,
      spacing: spacing,
      runAlignment: WrapAlignment.center,
      runSpacing: runSpacing,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  /// 将 Widget 列表转换为垂直方向的 Wrap 布局
  ///
  /// 这是一个便捷方法，主轴方向设置为垂直，适用于垂直流式布局
  /// 当垂直空间不足时会自动换列显示
  ///
  /// [spacing] 垂直方向上子组件之间的间距，默认为 8.0
  /// [runSpacing] 水平方向上列与列之间的间距，默认为 8.0
  /// [key] Wrap 的唯一标识符
  /// [alignment] 垂直方向上的对齐方式，默认为起始位置对齐
  /// [runAlignment] 水平方向上列与列之间的对齐方式，默认为起始位置对齐
  /// [crossAxisAlignment] 水平方向上子组件的对齐方式，默认为起始位置对齐
  ///
  /// 返回垂直方向的 Wrap 组件
  ///
  /// 示例:
  /// ```dart
  /// // 创建垂直的菜单项
  /// [
  ///   ListTile(leading: Icon(Icons.home), title: Text('首页')),
  ///   ListTile(leading: Icon(Icons.settings), title: Text('设置')),
  ///   ListTile(leading: Icon(Icons.help), title: Text('帮助')),
  ///   ListTile(leading: Icon(Icons.info), title: Text('关于')),
  /// ].toVerticalWrap()
  ///
  /// // 垂直的卡片布局
  /// [
  ///   Card(child: Container(width: 120, height: 80, child: Text('卡片1'))),
  ///   Card(child: Container(width: 120, height: 100, child: Text('卡片2'))),
  ///   Card(child: Container(width: 120, height: 90, child: Text('卡片3'))),
  /// ].toVerticalWrap(
  ///   spacing: 12.0,
  ///   runSpacing: 16.0,
  ///   alignment: WrapAlignment.center,
  /// )
  ///
  /// // 垂直的按钮列表
  /// [
  ///   ElevatedButton(onPressed: () {}, child: Text('操作1')),
  ///   ElevatedButton(onPressed: () {}, child: Text('操作2')),
  ///   ElevatedButton(onPressed: () {}, child: Text('操作3')),
  /// ].toVerticalWrap(
  ///   spacing: 8.0,
  ///   crossAxisAlignment: WrapCrossAlignment.center,
  /// )
  /// ```
  Widget toVerticalWrap({
    double spacing = 8.0,
    double runSpacing = 8.0,
    Key? key,
    WrapAlignment alignment = WrapAlignment.start,
    WrapAlignment runAlignment = WrapAlignment.start,
    WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.start,
  }) {
    return Wrap(
      key: key,
      direction: Axis.vertical,
      alignment: alignment,
      spacing: spacing,
      runAlignment: runAlignment,
      runSpacing: runSpacing,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }
}