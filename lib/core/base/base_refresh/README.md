# Base Refresh 刷新基类

提供统一的下拉刷新实现，基于 EasyRefresh 组件实现页面刷新功能。

## 文件说明

### base_refresh_logic.dart
刷新逻辑控制器基类，提供：
- 刷新状态管理
- 刷新控制器（EasyRefreshController）
- 继承自 BaseNetworkLogic
- 禁用自动状态设置

状态管理：
- `refreshState`: BaseRefreshState 实例，管理刷新相关状态

主要方法：
- `refresh()`: 刷新数据方法

### base_refresh_state.dart
刷新状态管理类，包含：
- `easyRefreshController`: EasyRefresh 控制器实例

### base_refresh_view.dart
刷新视图基类，提供：
- 统一的刷新视图结构
- 默认内边距配置
- 自定义内容布局
- 基于 EasyRefresh 的下拉刷新

主要属性：
- `defaultPadding`: 默认内边距（垂直 14，水平 18）
- `padding`: 是否启用内边距（默认 true）

## 使用示例

### 逻辑控制器实现

```dart
class MyRefreshLogic extends BaseRefreshLogic<ResponseType> {
  @override
  Future<void> apiRequest() async {
    // 实现刷新数据逻辑
    final response = await api.getData();
    requestOk(response);
  }

  @override
  void requestOk(ResponseType data) {
    // 处理刷新成功的数据
    // 通过 refreshState 访问状态：refreshState.easyRefreshController
  }
}
```

### 视图实现

```dart
class MyRefreshView extends BaseRefreshView<MyRefreshLogic> {
  @override
  List<Widget> pageContent(MyRefreshLogic controller) {
    return [
      // 返回页面内容组件列表
      Text('Content 1'),
      Text('Content 2'),
      // ...
    ];
  }

  @override
  bool get padding => false; // 可选：禁用默认内边距
}
```

## 刷新功能

### 1. 刷新配置
- 使用 EasyRefresh 实现下拉刷新
- 自定义刷新头部文案
- 支持刷新状态回调
- 统一的刷新动画

### 2. 刷新头部文案
```dart
const ClassicHeader(
  armedText: '释放刷新',
  readyText: '正在加载...',
  processedText: '加载完成',
  processingText: '正在刷新...',
  messageText: '更新于 %T',
  failedText: '刷新失败',
  noMoreText: '没有更多数据',
  dragText: '拉动刷新',
)
```

### 3. 内容布局
- 使用 ListView 作为内容容器
- 支持自定义内边距
- 可配置是否启用内边距
- 支持多个内容组件

## 注意事项

1. 刷新控制
   - 合理处理刷新状态
   - 避免重复刷新
   - 注意刷新时机
   - 处理刷新失败情况

2. 布局处理
   - 合理使用内边距
   - 注意内容溢出
   - 处理滚动冲突
   - 优化列表性能

3. 状态管理
   - 正确处理加载状态
   - 合理显示刷新提示
   - 处理网络错误
   - 更新界面状态

4. 用户体验
   - 提供加载反馈
   - 优化刷新动画
   - 合理的刷新时机
   - 友好的状态提示