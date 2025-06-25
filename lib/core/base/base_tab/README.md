# Base Tab 标签页基类

提供统一的标签页实现，基于 TDesign 的 TabBar 组件和 PageView 实现页面切换功能。

## 文件说明

### base_tab_logic.dart
标签页逻辑控制器基类，提供：
- 标签页切换控制
- PageView 控制
- 动画状态管理
- 继承自 BaseLogic

状态管理：
- `tabState`: BaseTabState 实例，管理所有标签页相关状态

主要方法：
- `tabChange(int index)`: 处理标签切换
- `pageViewChange(int index)`: 处理页面切换
- `setPageIndex(int index)`: 设置页面索引
- `setPageView(int index)`: 设置页面视图

### base_tab_state.dart
标签页状态管理类，包含：
- `tabController`: TabController 实例
- `pageController`: PageController 实例
- `usePageView`: 是否使用 PageView（默认 true）
- `isAnimating`: 动画状态标记

### base_tab_view.dart
标签页视图基类，提供：
- 统一的标签页结构
- 标签栏样式定制
- PageView 内容管理

主要属性：
- `tabColor`: 标签颜色（默认 0xff171A1D）
- `navHeight`: 导航栏高度（固定为 92）

## 使用示例

### 逻辑控制器实现

```dart
class MyTabLogic extends BaseTabLogic {
  @override
  List<String> get tabList => ['Tab1', 'Tab2', 'Tab3'];

  @override
  void onInit() {
    super.onInit();
    // 初始化逻辑
    // 通过 tabState 访问状态：tabState.tabController
  }
}
```

### 视图实现

```dart
class MyTabView extends BaseTabView<MyTabLogic> {
  @override
  List<Widget> pageViewChildren() {
    return [
      FirstPage(),
      SecondPage(),
      ThirdPage(),
    ];
  }
}
```

## 功能特性

### 1. 标签页管理
- TabController 控制标签切换
- PageView 实现页面切换
- 动画状态管理
- 页面切换回调

### 2. 导航栏集成
- 固定导航栏高度
- TDesign TabBar 集成
- 标签样式定制

### 3. 页面切换
- 支持滑动切换
- 标签点击切换
- 切换动画效果
- 状态同步管理

## 注意事项

1. 控制器管理
   - 正确初始化 TabController
   - 及时释放控制器资源
   - 处理页面切换事件
   - 管理动画状态

2. 视图配置
   - 正确配置导航栏高度
   - 自定义标签样式
   - 处理页面切换

3. 性能优化
   - 合理使用 PageView
   - 控制页面预加载
   - 优化切换动画
   - 避免不必要的重建

4. 用户体验
   - 流畅的切换动画
   - 统一的视觉风格
   - 响应式的布局适配