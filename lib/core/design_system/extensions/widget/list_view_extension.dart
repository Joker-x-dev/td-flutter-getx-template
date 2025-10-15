import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// List 的 ListView 扩展
///
/// 提供基于数据源的 ListView 创建方法，支持获取 index 和 item
/// 适用于需要循环显示数据的场景，如商品列表、用户列表等
///
/// 核心特性:
/// - 完整的 ListView 参数支持
/// - 类型安全的数据访问
/// - 获取索引和数据项
/// - 链式调用支持
/// - 性能优化（懒加载）
/// - 详细的中文注释
///
/// 使用场景:
/// - 商品列表展示
/// - 用户信息列表
/// - 设置选项列表
/// - 任何需要循环显示数据的场景
/// 支持通过数据源和 builder 函数创建 ListView，可以轻松获取 index 和 item

/// 基于 List 的数据驱动 ListView 扩展
///
/// 提供多种基于数据的 ListView 创建方式，支持获取 index 和 item
extension DataListViewExtension<T> on List<T> {
  /// 将数据列表转换为 ListView
  ///
  /// [itemBuilder] 构建每个列表项的函数，接收 context、index 和 item 参数
  /// [scrollDirection] 滚动方向，默认为垂直
  /// [reverse] 是否反向滚动，默认为 false
  /// [controller] 滚动控制器
  /// [primary] 是否为主滚动视图
  /// [physics] 滚动物理效果，默认为 iOS 风格的弹性滚动
  /// [shrinkWrap] 是否根据内容收缩包装
  /// [padding] 内边距
  /// [itemExtent] 每个项目的固定高度
  /// [prototypeItem] 原型项目，用于确定项目大小
  /// [addAutomaticKeepAlives] 是否自动保持子组件活跃状态
  /// [addRepaintBoundaries] 是否添加重绘边界
  /// [addSemanticIndexes] 是否添加语义索引
  /// [cacheExtent] 缓存范围
  /// [dragStartBehavior] 拖拽开始行为
  /// [keyboardDismissBehavior] 键盘消失行为
  /// [restorationId] 恢复 ID
  /// [clipBehavior] 裁剪行为
  ///
  /// 示例:
  /// ```dart
  /// // 基础用法
  /// final users = ['Alice', 'Bob', 'Charlie'];
  /// Widget userList = users.toListView(
  ///   itemBuilder: (context, index, user) => ListTile(
  ///     title: Text(user),
  ///     subtitle: Text('用户 $index'),
  ///   ),
  /// );
  ///
  /// // 复杂数据类型
  /// final products = [Product(name: 'iPhone'), Product(name: 'iPad')];
  /// Widget productList = products.toListView(
  ///   itemBuilder: (context, index, product) => ListTile(
  ///     title: Text(product.name),
  ///     leading: CircleAvatar(child: Text('${index + 1}')),
  ///   ),
  /// );
  /// ```
  Widget toListView({
    required Widget Function(BuildContext context, int index, T item)
    itemBuilder,
    Key? key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics = const BouncingScrollPhysics(),
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    double? itemExtent,
    Widget? prototypeItem,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return ListView.builder(
      key: key,
      itemCount: length,
      itemBuilder: (context, index) => itemBuilder(context, index, this[index]),
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemExtent: itemExtent,
      prototypeItem: prototypeItem,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      cacheExtent: cacheExtent,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
    );
  }

  /// 将数据列表转换为带分隔符的 ListView
  ///
  /// [itemBuilder] 构建每个列表项的函数，接收 context、index 和 item 参数
  /// [separatorBuilder] 构建分隔符的函数，接收 context 和 index 参数
  /// [scrollDirection] 滚动方向，默认为垂直
  /// [reverse] 是否反向滚动，默认为 false
  /// [controller] 滚动控制器
  /// [primary] 是否为主滚动视图
  /// [physics] 滚动物理效果，默认为 iOS 风格的弹性滚动
  /// [shrinkWrap] 是否根据内容收缩包装
  /// [padding] 内边距
  /// [addAutomaticKeepAlives] 是否自动保持子组件活跃状态
  /// [addRepaintBoundaries] 是否添加重绘边界
  /// [addSemanticIndexes] 是否添加语义索引
  /// [cacheExtent] 缓存范围
  /// [dragStartBehavior] 拖拽开始行为
  /// [keyboardDismissBehavior] 键盘消失行为
  /// [restorationId] 恢复 ID
  /// [clipBehavior] 裁剪行为
  ///
  /// 示例:
  /// ```dart
  /// // 基础分隔符
  /// final items = ['Item 1', 'Item 2', 'Item 3'];
  /// Widget separatedList = items.toListViewSeparated(
  ///   itemBuilder: (context, index, item) => ListTile(title: Text(item)),
  ///   separatorBuilder: (context, index) => Divider(),
  /// );
  ///
  /// // 自定义分隔符
  /// Widget customList = items.toListViewSeparated(
  ///   itemBuilder: (context, index, item) => Card(
  ///     child: ListTile(title: Text(item)),
  ///   ),
  ///   separatorBuilder: (context, index) => SizedBox(height: 8),
  /// );
  /// ```
  Widget toListViewSeparated({
    required Widget Function(BuildContext context, int index, T item)
    itemBuilder,
    Key? key,
    required Widget Function(BuildContext context, int index) separatorBuilder,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics = const BouncingScrollPhysics(),
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return ListView.separated(
      key: key,
      itemCount: length,
      itemBuilder: (context, index) => itemBuilder(context, index, this[index]),
      separatorBuilder: separatorBuilder,
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      cacheExtent: cacheExtent,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
    );
  }

  /// 将数据列表转换为 ListView.builder
  ///
  /// 这个方法提供了更灵活的构建方式，允许在 itemBuilder 中手动访问数据项
  ///
  /// [itemBuilder] 构建每个列表项的函数，接收 context 和 index 参数
  /// [scrollDirection] 滚动方向，默认为垂直
  /// [reverse] 是否反向滚动，默认为 false
  /// [controller] 滚动控制器
  /// [primary] 是否为主滚动视图
  /// [physics] 滚动物理效果，默认为 iOS 风格的弹性滚动
  /// [shrinkWrap] 是否根据内容收缩包装
  /// [padding] 内边距
  /// [itemExtent] 每个项目的固定高度
  /// [prototypeItem] 原型项目，用于确定项目大小
  /// [addAutomaticKeepAlives] 是否自动保持子组件活跃状态
  /// [addRepaintBoundaries] 是否添加重绘边界
  /// [addSemanticIndexes] 是否添加语义索引
  /// [cacheExtent] 缓存范围
  /// [dragStartBehavior] 拖拽开始行为
  /// [keyboardDismissBehavior] 键盘消失行为
  /// [restorationId] 恢复 ID
  /// [clipBehavior] 裁剪行为
  ///
  /// 示例:
  /// ```dart
  /// // 基础用法
  /// final data = ['A', 'B', 'C'];
  /// Widget builderList = data.toListViewBuilder(
  ///   itemBuilder: (context, index) => ListTile(
  ///     title: Text(data[index]),
  ///     subtitle: Text('索引: $index'),
  ///   ),
  /// );
  ///
  /// // 复杂布局
  /// Widget complexList = data.toListViewBuilder(
  ///   itemBuilder: (context, index) => Card(
  ///     child: ListTile(
  ///       title: Text(data[index]),
  ///       trailing: Icon(Icons.arrow_forward),
  ///     ),
  ///   ),
  /// );
  /// ```
  Widget toListViewBuilder({
    required Widget Function(BuildContext context, int index) itemBuilder,
    int? itemCount,
    Key? key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics = const BouncingScrollPhysics(),
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    double? itemExtent,
    Widget? prototypeItem,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return ListView.builder(
      key: key,
      itemCount: length,
      itemBuilder: itemBuilder,
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemExtent: itemExtent,
      prototypeItem: prototypeItem,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      cacheExtent: cacheExtent,
      semanticChildCount: semanticChildCount ?? length,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
    );
  }
}

/// 基于 int 的 ListView 扩展
///
/// 支持基于数字范围生成 ListView
extension IntListViewExtension on int {
  /// 将数字转换为 ListView
  ///
  /// 基于数字范围生成 ListView，从 0 到当前数字（不包含）
  ///
  /// [itemBuilder] 构建每个列表项的函数，接收 context 和 index
  /// [scrollDirection] 滚动方向，默认为垂直
  /// [reverse] 是否反向滚动，默认为 false
  /// [controller] 滚动控制器
  /// [primary] 是否为主滚动视图
  /// [physics] 滚动物理效果，默认为 iOS 风格的弹性滚动
  /// [shrinkWrap] 是否根据内容收缩包装
  /// [padding] 内边距
  /// [itemExtent] 每个子项的固定高度（垂直滚动）或宽度（水平滚动）
  /// [prototypeItem] 原型项，用于确定子项大小
  /// [addAutomaticKeepAlives] 是否自动保持子项活跃状态，默认为 true
  /// [addRepaintBoundaries] 是否添加重绘边界，默认为 true
  /// [addSemanticIndexes] 是否添加语义索引，默认为 true
  /// [cacheExtent] 缓存范围
  /// [dragStartBehavior] 拖拽开始行为，默认为 start
  /// [keyboardDismissBehavior] 键盘消失行为，默认为 manual
  /// [restorationId] 恢复 ID
  /// [clipBehavior] 裁剪行为，默认为 hardEdge
  ///
  /// 示例:
  /// ```dart
  /// // 生成 0-9 的列表
  /// Widget numberList = 10.toListView(
  ///   itemBuilder: (context, index) => ListTile(
  ///     title: Text('Item $index'),
  ///   ),
  /// );
  ///
  /// // 简单的数字列表
  /// Widget simpleList = 5.toListView(
  ///   itemBuilder: (context, index) => Text('$index'),
  /// );
  /// ```
  Widget toListView({
    Key? key,
    required Widget Function(BuildContext context, int index) itemBuilder,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics = const BouncingScrollPhysics(),
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    double? itemExtent,
    Widget? prototypeItem,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return ListView.builder(
      key: key,
      itemCount: this,
      itemBuilder: itemBuilder,
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemExtent: itemExtent,
      prototypeItem: prototypeItem,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      cacheExtent: cacheExtent,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
    );
  }
}
