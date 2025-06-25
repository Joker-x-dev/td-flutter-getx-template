# API请求处理器

API请求处理器（ApiHandler）是一个用于简化网络请求状态处理的工具类。它提供了统一的请求生命周期回调，使网络请求的处理更加简洁和统一。

## 主要功能

1. 统一的请求状态处理
   - 请求开始（onStart）
   - 请求成功（onSuccess）
   - 请求错误（onError）

2. 自动的错误处理
   - 支持错误Toast提示
   - 支持错误对话框
   - 支持自定义错误信息
   - 网络异常捕获
   - 业务错误处理

3. 类型安全
   - 泛型支持
   - 基于BaseResponse的响应封装

4. 加载状态管理
   - 自动显示/隐藏加载对话框
   - 可配置是否显示加载对话框
   - 统一的加载对话框样式

## 使用方法

### 简化用法（推荐）

最简单的使用方式，只需要关注成功的情况：

```dart
ApiHandler.handle(
  await api.getData(),
  (data) {
    // 处理成功数据
    handleData(data);
  }
);
```

默认会：
- 显示加载对话框（loading = true）
- 显示错误Toast（showErrorToast = true）
- 自动处理错误情况

如果需要修改默认行为：

```dart
ApiHandler.handle(
  await api.getData(),
  (data) {
    // 处理成功数据
    handleData(data);
  },
  loading: false, // 不显示加载对话框
  showErrorToast: false, // 不显示错误Toast
);
```

### 完整用法

如果需要完整控制请求的各个状态，可以使用完整版API：

```dart
await ApiHandler.handleFull(
  api: api.getData(),
  loading: true,
  showErrorToast: true,
  showErrorDialog: false,
  onStart: () {
    // 处理开始状态
    setState(() => isStarted = true);
  },
  onSuccess: (data) {
    // 处理成功数据
    handleData(data);
  },
  onError: (message, error) {
    // 处理错误
    handleError(message);
  }
);
```

### 自定义错误提示

```dart
await ApiHandler.handleFull(
  api: api.getData(),
  loading: true,
  showErrorToast: true,
  showErrorDialog: true,
  errorMsg: '获取数据失败，请稍后重试',
  onSuccess: (data) {
    handleData(data);
  }
);
```

## 注意事项

1. 错误处理
   - 支持错误Toast和错误对话框两种提示方式
   - 简化版API中showErrorToast默认为true
   - 完整版API中showErrorToast和showErrorDialog默认为false
   - 可通过errorMsg自定义错误提示文本
   - 使用CommonUtil.isSuccess统一处理成功状态

2. 类型安全
   - 需要确保API返回类型为BaseResponse<T>
   - 泛型T应与API返回的数据类型匹配

3. 生命周期
   - onStart在请求发起前调用（仅完整版API支持）
   - onSuccess在请求成功且code为200时调用
   - onError在请求失败或code非200时调用（仅完整版API支持）
   - loading为true时，自动显示/隐藏加载对话框

4. 加载对话框
   - 简化版API中loading默认为true
   - 完整版API中loading默认为false
   - loading为true时会显示统一样式的加载对话框
   - 加载对话框会在请求结束后自动关闭
   - 加载对话框不可手动关闭，避免用户误操作

## 最佳实践

1. 在ViewModel中使用（简化版）
```dart
class MyViewModel extends BaseViewModel {
  Future<void> loadData() async {
    ApiHandler.handle(
      await api.getData(),
      (data) {
        setData(data);
      }
    );
  }
}
```

2. 处理加载状态（完整版）
```dart
await ApiHandler.handleFull(
  api: api.getData(),
  loading: false,
  showErrorToast: true,
  onStart: () {
    setState(() => isLoading = true);
  },
  onSuccess: (data) {
    setState(() {
      this.data = data;
      isLoading = false;
    });
  },
  onError: (_, __) {
    setState(() => isLoading = false);
  }
);
```

3. 完整错误处理
```dart
await ApiHandler.handleFull(
  api: api.getData(),
  loading: true,
  showErrorToast: true,
  showErrorDialog: true,
  errorMsg: '获取数据失败',
  onError: (message, error) {
    // 额外的错误处理逻辑
    logError(error);
  }
);
```

## 与Retrofit配合使用

当使用Retrofit生成的API时，确保API方法返回`BaseResponse<T>`类型：

```dart
@RestApi(baseUrl: "api/")
abstract class MyApi {
  @GET("/data")
  Future<BaseResponse<MyData>> getData();
}
```

## 错误码处理

使用CommonUtil.isSuccess统一处理成功状态判断：

```dart
// 简化版
ApiHandler.handle(
  await api.getData(),
  (data) {
    if (data != null) {
      // 处理数据
    } else {
      // 处理空数据情况
    }
  }
);

// 完整版
await ApiHandler.handleFull(
  api: api.getData(),
  loading: true,
  showErrorToast: true,
  onSuccess: (data) {
    if (data != null) {
      // 处理数据
    } else {
      // 处理空数据情况
    }
  }
);
``` 