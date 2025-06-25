# Base 基础类库

基础类库提供了应用程序中所有基础组件的父类实现，基于 GetX 框架提供统一的基类定义和行为规范。

## 目录结构

### base/
基础父类目录，包含最基本的视图和控制器父类。

- `base_logic.dart`: 基于 GetX 的逻辑控制器基类，提供状态管理和生命周期管理
- `base_view.dart`: 基于 GetX 的视图基类，提供导航栏、页面结构等基础实现

### base_dialog/
弹出层相关的基类实现。

- `base_dialog.dart`: 底部弹出层基类，提供统一的样式和行为定义，支持自定义内容和交互控制

### base_list/
列表相关的基类实现。

- `base_list_view.dart`: 列表视图基类，集成 EasyRefresh 实现下拉刷新和搜索功能
- `base_list_logic.dart`: 列表逻辑控制器基类，处理分页、搜索和数据加载逻辑
- `base_list_state.dart`: 列表状态管理类，管理列表相关的状态数据

### base_network/
网络请求相关的基类实现。

- `base_network_view.dart`: 网络请求视图基类，处理加载、错误、空数据等状态展示
- `base_network_logic.dart`: 网络请求逻辑控制器基类，统一处理网络请求和状态管理
- `base_network_state.dart`: 网络请求状态管理类，管理网络请求相关的状态

### base_refresh/
下拉刷新相关的基类实现。

- `base_refresh_view.dart`: 刷新视图基类，基于 EasyRefresh 提供统一的下拉刷新实现
- `base_refresh_logic.dart`: 刷新逻辑控制器基类，处理刷新状态和逻辑
- `base_refresh_state.dart`: 刷新状态管理类，管理刷新相关的状态

### base_tab/
标签页相关的基类实现。

- `base_tab_view.dart`: 标签页视图基类，提供标签栏和内容区域的基础实现
- `base_tab_logic.dart`: 标签页逻辑控制器基类，处理页面切换和状态管理
- `base_tab_state.dart`: 标签页状态管理类，管理标签页相关的状态

## 核心功能

### 1. 状态管理
- 使用 GetX 的响应式状态管理
- 统一的网络状态定义（loading/error/emptyData/dataSuccess）
- 页面状态和生命周期管理

### 2. 页面结构
- 统一的导航栏实现（基于 TDesign）
- 可配置的页面布局
- 状态保持支持
- 底部导航和悬浮按钮支持

### 3. 网络请求
- 统一的请求状态处理
- 错误处理机制
- 加载状态管理
- 请求结果处理

### 4. 列表功能
- 分页加载（默认每页 20 条）
- 下拉刷新（基于 EasyRefresh）
- 搜索功能（支持搜索框）
- 空数据处理

## 使用规范

### 1. 逻辑控制器继承关系
```dart
// 基础逻辑控制器
class MyLogic extends BaseLogic {
  @override
  void onInit() {
    super.onInit();
    // 初始化逻辑
  }
}

// 网络请求逻辑控制器
class MyNetworkLogic extends BaseNetworkLogic<T> {
  @override
  Future<void> apiRequest() async {
    // 实现数据加载逻辑
    // 通过 networkState 访问状态
  }
}

// 列表逻辑控制器
class MyListLogic extends BaseListLogic<T> {
  @override
  Future<void> apiRequest() async {
    // 实现列表数据加载
    // 通过 listState 访问状态
  }
}
```

### 2. 视图继承关系
```dart
// 基础视图
class MyView extends BaseView<MyLogic> {
  @override
  Widget body() {
    // 实现页面内容
  }
}

// 列表视图
class MyListView extends BaseListView<MyListLogic, ItemType> {
  @override
  Widget itemWidget(ItemType item) {
    // 实现列表项
    // 通过 controller.listState 访问状态
  }
}
```

## 注意事项

1. 生命周期管理
   - 遵循 GetX 的生命周期规范
   - 正确处理资源释放
   - 注意状态保持的使用

2. 状态管理
   - 合理使用响应式状态
   - 正确处理加载状态
   - 统一的错误处理

3. 网络请求
   - 统一使用基类定义的请求方式
   - 合理处理错误情况
   - 注意请求状态的管理

4. 代码规范
   - 遵循命名规范
   - 实现必要的抽象方法
   - 合理使用继承关系