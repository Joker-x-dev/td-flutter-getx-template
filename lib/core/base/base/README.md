# Base 基础父类

提供最基本的视图和控制器父类实现，是所有其他基类的基础。

## 文件说明

### base_logic.dart
基础逻辑控制器类，提供：
- GetX 生命周期管理（onInit/onReady/onDetached/onInactive/onPaused/onResumed）
- 参数传递支持（通过 Get.arguments）
- 初始化数据方法（initData）
- 继承自 SuperController

使用示例：
```dart
class MyLogic extends BaseLogic {
  @override
  void onInit() {
    super.onInit();
    // 初始化逻辑
  }

  @override
  void initData() {
    // 数据初始化
  }
}
```

### base_view.dart
基础视图类，提供：
- 页面基础结构定义
- 导航栏配置（基于 TDesign）
- 状态保持支持
- 底部导航和悬浮按钮支持
- 继承自 GetView

主要属性：
- `navTitle`: 导航栏标题
- `navBackBtn`: 是否显示返回按钮
- `navHeight`: 导航栏高度（默认 44）
- `isHiddenNav`: 是否隐藏导航栏
- `keepAlive`: 是否保持页面状态

使用示例：
```dart
class MyView extends BaseView<MyLogic> {
  @override
  Widget body() {
    return Container(
      // 实现页面内容
    );
  }

  @override
  Widget? bottom() {
    // 可选：实现底部导航
    return null;
  }

  @override
  Widget? floatingAction() {
    // 可选：实现悬浮按钮
    return null;
  }
}
```

## 生命周期

### 逻辑控制器生命周期

1. `onInit`: 逻辑控制器初始化时调用
2. `onReady`: 逻辑控制器准备就绪时调用
3. `onDetached`: 逻辑控制器从视图树分离时调用
4. `onInactive`: 逻辑控制器处于非活动状态时调用
5. `onPaused`: 逻辑控制器暂停时调用
6. `onResumed`: 逻辑控制器恢复时调用

### 视图生命周期
- 遵循 Flutter 标准 Widget 生命周期
- 通过 `keepAlive` 属性控制状态保持

## 注意事项

1. 状态管理
   - 使用 GetX 的响应式状态管理
   - 合理处理网络状态变化
   - 注意状态更新时机

2. 导航栏使用
   - 使用 TDesign 的导航栏组件
   - 合理配置导航栏属性
   - 注意返回按钮处理

3. 生命周期处理
   - 正确实现生命周期方法
   - 注意资源释放
   - 合理使用状态保持

4. 页面结构
   - 遵循统一的页面结构
   - 合理使用底部导航
   - 适当使用悬浮按钮