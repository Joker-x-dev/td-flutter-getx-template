# Tab 父类

`BaseTabLogic`、`BaseTabState` 与 `BaseTabView<T>` 位于 `lib/core/base/base_tab/`。它使用 `TDTabBar` 展示分类，用 `PageView` 承载内容，并让点击标签与左右滑动保持同步。

## 初始化与释放

`BaseTabLogic` 混入 `GetTickerProviderStateMixin`。`onInit()` 根据 `tabList.length` 创建 `TabController`；当 `usePageView` 为 `true` 时再创建 `PageController`。`onClose()` 同时释放 `TabController` 与 `PageController`，避免 ticker 和滚动控制器泄漏。复杂页面如自行替换控制器，仍由 Logic 生命周期统一释放。

## API

| 成员 | 默认值 | 作用 |
| --- | --- | --- |
| `tabList` | 必须实现 | Tab 标题列表，不能为空才能创建控制器 |
| `tabState.usePageView` | `true` | 是否创建 PageController |
| `tabState.isAnimating` | `false` | 标记由点击触发的 PageView 动画 |
| `tabChange(index)` | — | Tab 点击后切换 TabController 并动画跳页 |
| `pageViewChange(index)` | — | PageView 滑动完成后同步 TabController |
| `tabColor` | `appTheme.textPrimary` | Tab 文本与指示器颜色 |
| `navHeight` | `92` | 导航栏与 TabBar 总高度 |
| `pageViewChildren()` | 空列表 | 子类返回每一个 Tab 的页面 |

`isAnimating` 的存在是为了区分手指滑动和 `animateToPage` 产生的中间回调，避免多页跳转经过中间页时 Tab 短暂跳错。

## 基于 BaseTabDemo 的完整示例

```dart
/// Tab 示例页 Logic，标题来自本地化资源。
class BaseTabDemoLogic extends BaseTabLogic {
  @override
  List<String> get tabList => const ['推荐', '热门', '收藏'];
}

/// Tab 与 PageView 联动页面。
class BaseTabDemoView extends BaseTabView<BaseTabDemoLogic> {
  BaseTabDemoView({super.key, super.logic});

  @override
  String? get navTitle => '标签页';

  @override
  List<Widget> pageViewChildren() {
    return const [
      // 子项数量与 tabList 必须保持一致。
      Center(child: Text('推荐内容')),
      Center(child: Text('热门内容')),
      Center(child: Text('收藏内容')),
    ];
  }
}

/// Preview 中手动执行初始化，确保 TabController 已创建。
@ResponsivePreview()
Widget previewBaseTabDemoView() {
  final BaseTabDemoLogic logic = BaseTabDemoLogic()..onInit();
  return BaseTabDemoView(logic: logic);
}
```

## 不使用 PageView

当内容是单个区域、Tab 点击只改变筛选条件时，可将 `tabState.usePageView` 设为 `false`，并重写 `body()` 以订阅当前 Tab。此时仍可复用 `tabsWidget()`，但必须自行处理 `tabChange()` 后的内容刷新。

```dart
/// 不使用 PageView 的筛选页 Logic。
class FilterTabLogic extends BaseTabLogic {
  @override
  List<String> get tabList => const ['全部', '已完成'];

  @override
  void tabChange(int index) {
    super.tabChange(index);
    // 根据 index 更新筛选条件并重新加载数据。
  }
}
```

## 注意事项

- `tabList` 不能为空，且 `pageViewChildren()` 数量必须与其一致。
- 若预览直接注入 Logic，需要执行 `onInit()`；正常路由由 GetX 生命周期自动调用。
- 避免在每次 `build()` 新建 `TabController` 或 `PageController`，控制器的生命周期应归 Logic。

## 关联阅读

- [基础父类](./base.md)
- [Widget Preview](../扩展/widget-preview.md)
