# Base List 列表基类

提供统一的列表页面实现，包含列表加载、分页、刷新等常用功能。基于 EasyRefresh 实现下拉刷新和加载更多功能。

## 文件说明

### base_list_logic.dart
列表逻辑控制器基类，提供：
- 分页数据管理
- 刷新和加载更多
- 数据状态管理
- 继承自 BaseNetworkLogic

状态管理：
- `listState`: BaseListState 实例，管理所有列表相关状态

主要方法：
- `refresh()`: 刷新数据
- `loadMore()`: 加载更多数据
- `processDataList(List<T> list)`: 数据处理钩子

### base_list_state.dart
列表状态管理类，包含：
- `pageSize`: 单页数据量（默认 20）
- `currentPage`: 当前页码
- `dataList`: 列表数据（RxList）
- `noMoreData`: 是否还有更多数据
- `easyRefreshController`: EasyRefresh 控制器实例

### base_list_view.dart
列表视图基类，提供：
- 统一的列表页面结构
- 下拉刷新
- 上拉加载更多

主要特性：
- 默认隐藏导航栏
- 使用 EasyRefresh 实现刷新功能
- 支持自定义列表项样式

## 使用示例

### 逻辑控制器实现

```dart
class MyListLogic extends BaseListLogic<ItemType> {
  @override
  Future<void> apiRequest() async {
    // 实现数据加载逻辑
    final response = await api.getList(listState.pageParams);
    requestOk(response);
  }

  @override
  void processDataList(List<ItemType> list) {
    // 可选：处理列表数据
    // 通过 listState 访问状态：listState.dataList
  }
}
```

### 视图实现
```dart
class MyListView extends BaseListView<MyListController, ItemType> {
  @override
  Widget itemWidget(ItemType item, int index) {
    return ListTile(
      // 实现列表项
    );
  }
}
```

## 功能特性

### 1. 分页管理
- 自动维护页码
- 处理无更多数据状态
- 支持自定义页大小
- 统一的分页参数格式

### 2. 刷新功能
- 下拉刷新
- 上拉加载更多
- 自定义刷新样式
- 刷新状态管理

### 3. 数据处理
- 数据加载状态管理
- 空数据处理
- 错误处理
- 数据预处理支持

## 注意事项

1. 分页处理
   - 正确维护页码
   - 处理好加载更多逻辑
   - 注意首次加载和刷新的区别
   - 合理处理无数据状态

2. 刷新控制
   - 避免重复刷新
   - 正确处理刷新状态
   - 注意加载更多时机
   - 优化刷新动画

3. 性能优化
   - 合理使用 ListView.builder
   - 避免不必要的重建
   - 控制数据量大小
   - 实现图片懒加载