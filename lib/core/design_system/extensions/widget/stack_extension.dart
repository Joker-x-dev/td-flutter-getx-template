/// Stack 布局扩展
///
/// 为 List<Widget> 提供便捷的 Stack 布局转换方法
/// 支持层叠布局的各种配置选项

import 'package:flutter/material.dart';

/// Stack 布局扩展
///
/// 为 Widget 列表提供转换为 Stack 布局的便捷方法
extension StackExtension on List<Widget> {
  /// 将 Widget 列表转换为 Stack 布局
  ///
  /// Stack 是一个层叠布局容器，子组件可以重叠显示
  /// 后添加的子组件会显示在前面添加的子组件之上
  ///
  /// [key] Stack 的唯一标识符
  /// [alignment] 子组件在 Stack 中的对齐方式，默认为左上角对齐
  /// [textDirection] 文本方向，影响对齐方式的计算
  /// [fit] 子组件的适应方式，默认为 loose（子组件可以小于 Stack）
  /// [clipBehavior] 裁剪行为，默认为 hardEdge（硬边缘裁剪）
  ///
  /// 返回配置好的 Stack 组件
  ///
  /// 示例:
  /// ```dart
  /// // 创建层叠布局
  /// [
  ///   Container(
  ///     width: 200,
  ///     height: 200,
  ///     color: Colors.blue,
  ///   ),
  ///   Container(
  ///     width: 100,
  ///     height: 100,
  ///     color: Colors.red,
  ///   ).positioned(
  ///     top: 50,
  ///     left: 50,
  ///   ),
  /// ].toStack()
  ///
  /// // 居中对齐的层叠布局
  /// [
  ///   Icon(Icons.star, size: 100, color: Colors.yellow),
  ///   Icon(Icons.favorite, size: 50, color: Colors.red),
  /// ].toStack(
  ///   alignment: Alignment.center,
  ///   fit: StackFit.expand,
  /// )
  /// ```
  Widget toStack({
    Key? key,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    TextDirection? textDirection,
    StackFit fit = StackFit.loose,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return Stack(
      key: key,
      alignment: alignment,
      textDirection: textDirection,
      fit: fit,
      clipBehavior: clipBehavior,
      children: this,
    );
  }

  /// 将 Widget 列表转换为居中对齐的 Stack 布局
  ///
  /// 这是一个便捷方法，所有子组件都会在 Stack 中居中对齐
  /// 适用于需要层叠显示且居中对齐的场景
  ///
  /// [key] Stack 的唯一标识符
  /// [fit] 子组件的适应方式，默认为 loose
  /// [clipBehavior] 裁剪行为，默认为 hardEdge
  ///
  /// 返回居中对齐的 Stack 组件
  ///
  /// 示例:
  /// ```dart
  /// // 创建居中的图标层叠
  /// [
  ///   Icon(Icons.circle, size: 100, color: Colors.blue),
  ///   Icon(Icons.star, size: 50, color: Colors.white),
  /// ].toCenterStack()
  ///
  /// // 创建居中的加载指示器
  /// [
  ///   Container(
  ///     width: 200,
  ///     height: 200,
  ///     decoration: BoxDecoration(
  ///       color: Colors.black54,
  ///       borderRadius: BorderRadius.circular(10),
  ///     ),
  ///   ),
  ///   CircularProgressIndicator(),
  /// ].toCenterStack()
  /// ```
  Widget toCenterStack({
    Key? key,
    StackFit fit = StackFit.loose,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return Stack(
      key: key,
      alignment: Alignment.center,
      fit: fit,
      clipBehavior: clipBehavior,
      children: this,
    );
  }

  /// 将 Widget 列表转换为扩展填充的 Stack 布局
  ///
  /// 这是一个便捷方法，所有子组件都会扩展填充整个 Stack 区域
  /// 适用于需要子组件填满整个容器的场景
  ///
  /// [key] Stack 的唯一标识符
  /// [alignment] 子组件在 Stack 中的对齐方式，默认为左上角对齐
  /// [clipBehavior] 裁剪行为，默认为 hardEdge
  ///
  /// 返回扩展填充的 Stack 组件
  ///
  /// 示例:
  /// ```dart
  /// // 创建全屏背景和内容
  /// [
  ///   Image.asset('assets/background.jpg', fit: BoxFit.cover),
  ///   Container(
  ///     color: Colors.black26,
  ///     child: Center(child: Text('内容')),
  ///   ),
  /// ].toExpandedStack()
  ///
  /// // 创建卡片背景和内容
  /// [
  ///   Container(color: Colors.white),
  ///   Padding(
  ///     padding: EdgeInsets.all(16),
  ///     child: Column(children: [/* 内容 */]),
  ///   ),
  /// ].toExpandedStack(alignment: Alignment.topLeft)
  /// ```
  Widget toExpandedStack({
    Key? key,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return Stack(
      key: key,
      alignment: alignment,
      fit: StackFit.expand,
      clipBehavior: clipBehavior,
      children: this,
    );
  }

  /// 将 Widget 列表转换为带裁剪的 Stack 布局
  ///
  /// 这是一个便捷方法，Stack 会裁剪超出边界的子组件
  /// 适用于需要严格控制显示区域的场景
  ///
  /// [key] Stack 的唯一标识符
  /// [alignment] 子组件在 Stack 中的对齐方式，默认为左上角对齐
  /// [fit] 子组件的适应方式，默认为 loose
  /// [clipBehavior] 裁剪行为，默认为 antiAlias（抗锯齿裁剪）
  ///
  /// 返回带裁剪的 Stack 组件
  ///
  /// 示例:
  /// ```dart
  /// // 创建圆形头像层叠
  /// [
  ///   ClipOval(
  ///     child: Image.network('https://example.com/avatar.jpg'),
  ///   ),
  ///   Container(
  ///     width: 20,
  ///     height: 20,
  ///     decoration: BoxDecoration(
  ///       color: Colors.green,
  ///       shape: BoxShape.circle,
  ///     ),
  ///   ).positioned(
  ///     bottom: 0,
  ///     right: 0,
  ///   ),
  /// ].toClippedStack()
  ///
  /// // 创建卡片内容裁剪
  /// [
  ///   Container(
  ///     width: 200,
  ///     height: 150,
  ///     color: Colors.blue,
  ///   ),
  ///   Container(
  ///     width: 50,
  ///     height: 50,
  ///     color: Colors.red,
  ///   ).positioned(
  ///     top: -10,
  ///     left: -10,
  ///   ),
  /// ].toClippedStack()
  /// ```
  Widget toClippedStack({
    Key? key,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    StackFit fit = StackFit.loose,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return Stack(
      key: key,
      alignment: alignment,
      fit: fit,
      clipBehavior: clipBehavior,
      children: this,
    );
  }
}