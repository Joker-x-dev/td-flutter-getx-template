# Base Network 网络请求基类

提供统一的网络请求处理实现，包含加载状态、错误处理等通用功能。

## 文件说明

### base_network_logic.dart
网络请求逻辑控制器基类，提供：
- 网络请求状态管理
- 错误处理机制
- 请求生命周期回调
- 统一的请求方法
- 继承自 BaseLogic

状态管理：
- `networkState`: BaseNetworkState 实例，管理所有网络请求相关状态

主要特性：
- `apiRequest`: 子类需要实现的 API 请求方法

生命周期方法：
- `beforeRequest`: 请求前的回调
- `requestOk`: 请求成功的回调
- `requestError`: 请求失败的回调

### base_network_state.dart
网络请求状态管理类，包含：
- `requestErrorToast`: 是否显示请求错误提示（默认 true）
- `firstLoad`: 是否在初始化时自动加载（默认 true）
- `requestSetStatus`: 是否在请求前设置加载状态（默认 true）

### base_network_view.dart
网络请求视图基类，提供：
- 统一的状态展示
- 加载动画
- 错误重试
- 空数据处理

主要特性：
- `showAnimation`: 是否显示状态切换动画（默认 true）
- `keepAlive`: 是否保持页面状态（默认 true）

状态组件：
- `loadWidget`: 加载状态组件（使用 TDLoading）
- `emptyWidget`: 空数据状态组件
- `failWidget`: 错误状态组件

## 使用示例

### 逻辑控制器实现

```dart
class MyNetworkLogic extends BaseNetworkLogic<ResponseType> {
  @override
  Future<void> apiRequest() async {
    // 实现 API 请求逻辑
    final response = await api.getData();
    requestOk(response);
  }

  @override
  void requestOk(ResponseType data) {
    // 处理请求成功的数据
    // 通过 networkState 访问状态
  }

  @override
  void requestError() {
    // 处理请求失败的情况
  }
}
```

### 视图实现
```dart
class MyNetworkView extends BaseCommonView<MyNetworkController> {
  @override
  Widget bodyContent(MyNetworkController controller) {
    return Container(
      // 实现具体内容
    );
  }

  @override
  Widget emptyWidget() {
    // 自定义空数据展示
    return TDEmpty(...);
  }

  @override
  Widget failWidget(MyNetworkController controller) {
    // 自定义错误状态展示
    return TDEmpty(...);
  }
}
```

## 状态管理

### 网络状态
基于 SuperController 的 RxStatus 状态管理：

```dart
class RxStatus {
  final bool isLoading;     // 加载状态
  final bool isError;       // 错误状态
  final bool isSuccess;     // 成功状态
  final bool isEmpty;       // 空数据状态
  final bool isLoadingMore; // 加载更多状态
  final String? errorMessage; // 错误信息

  // 工厂方法
  factory RxStatus.loading();     // 创建加载状态
  factory RxStatus.loadingMore(); // 创建加载更多状态
  factory RxStatus.success();     // 创建成功状态
  factory RxStatus.error([String? message]); // 创建错误状态
  factory RxStatus.empty();       // 创建空数据状态
}
```

### 状态切换方法
基于 StateMixin 的状态管理：

- `change(T? newState, {RxStatus? status})`: 更新状态和数据
- `value = newValue`: 直接设置数据值
- `append(Future<T> Function() body)`: 异步请求并自动处理状态

状态创建方法：
- `RxStatus.loading()`: 设置加载状态
- `RxStatus.error(message)`: 设置错误状态
- `RxStatus.success()`: 设置成功状态
- `RxStatus.empty()`: 设置空数据状态
- `RxStatus.loadingMore()`: 设置加载更多状态

## 注意事项

1. 错误处理
   - 使用 `handleRequestError` 统一处理请求错误
   - 合理配置 `requestErrorToast` 控制错误提示
   - 在 `requestError` 中处理特殊错误情况

2. 状态管理
   - 正确使用状态切换方法
   - 注意状态切换的时机
   - 合理处理边界情况

3. 视图展示
   - 根据需求自定义状态组件
   - 合理使用动画效果
   - 注意用户体验

4. 性能优化
   - 合理使用 `keepAlive`
   - 避免不必要的状态更新
   - 注意内存管理