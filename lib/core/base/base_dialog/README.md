# Base Dialog 弹出层基类

提供统一的底部弹出层实现，基于 GetX 的 bottomSheet 实现，支持自定义内容和交互控制。

## 文件说明

### base_dialog.dart
底部弹出层基类，提供：
- 统一的弹窗样式定义
- 导航栏配置
- 交互行为控制
- 内容布局管理

主要属性：
- `title`: 弹窗标题
- `close`: 是否显示关闭按钮（默认 true）
- `line`: 是否显示导航栏分割线（默认 true）
- `isDismissible`: 是否允许点击外部关闭
- `enableDrag`: 是否允许向下滑动关闭
- `enablePhysicalBack`: 是否允许物理返回按钮关闭

主要方法：
- `show()`: 显示弹窗
- `body()`: 子类实现的内容区域
- `bottom()`: 可选的底部内容
- `init()`: 弹窗初始化钩子

## 使用示例

### 基本实现
```dart
class MyDialog extends BaseDialog {
  @override
  String get title => '弹窗标题';

  @override
  List<Widget> body() {
    return [
      Text('弹窗内容'),
      // 其他内容组件
    ];
  }

  @override
  Widget? bottom() {
    // 可选：返回底部内容
    return null;
  }

  @override
  void init() {
    // 可选：初始化逻辑
  }
}
```

### 显示弹窗
```dart
// 显示弹窗
await MyDialog().show();
```

## 功能特性

### 1. 样式定制
- 圆角边框（顶部圆角 12）
- 白色背景
- 统一的导航栏样式
- 可选的分割线

### 2. 交互控制
- 点击外部关闭
- 下滑关闭
- 物理返回键控制
- 关闭按钮控制

### 3. 布局结构
- 导航栏（TDNavBar）
- 内容区域（可滚动）
- 底部区域（可选）
- 安全区域适配

### 4. 导航栏配置
- 标题显示
- 关闭按钮
- 分割线
- 高度设置（56）

## 注意事项

1. 显示控制
   - 使用 await 等待弹窗关闭
   - 处理弹窗返回值
   - 控制弹窗状态
   - 管理多个弹窗

2. 布局处理
   - 注意内容溢出
   - 处理键盘遮挡
   - 适配不同屏幕
   - 考虑安全区域

3. 交互优化
   - 合理设置交互选项
   - 处理返回键事件
   - 优化关闭动画
   - 提供交互反馈

4. 性能考虑
   - 延迟加载内容
   - 控制重建范围
   - 及时释放资源
   - 优化动画性能 