# 动画链式扩展

动画扩展位于 `lib/core/design_system/extensions/animated/`，并从 `extensions.dart` 统一导出。它们为常用布局、装饰、透明度、变换、交互、文本和图标提供隐式动画或内部 `StatefulWidget` 包装。未显式配置时统一使用 300ms 与 `Curves.linear`。

## 分类与 API

| 分类 | 常用 API | 动画实现 |
| --- | --- | --- |
| 动画上下文 | `animate(duration:, curve:)` | 通过内部 InheritedWidget 传递时长与曲线 |
| 布局 | `animatedPadding`、`animatedMargin`、`animatedConstraints` | `AnimatedPadding`、`AnimatedContainer`、约束 Tween |
| 装饰 | `animatedDecoration`、`animatedBorderRadius`、`animatedBackgroundColor`、`animatedElevation` | `DecorationTween`、`AnimatedContainer`、`AnimatedPhysicalModel` |
| 变换 | `animatedTransform`、`animatedScale`、`animatedRotate`、`animatedTranslate` | `TweenAnimationBuilder`、`AnimatedScale` |
| 视觉效果 | `animatedOpacity`、`animatedFadeIn`、`animatedFadeOut`、`animatedVisibility` | `AnimatedOpacity`、Tween |
| 手势 | `animatedTap`、`animatedRipple`、`animatedTapScale`、`animatedHover` | 内部 StatefulWidget、`AnimationController`、InkWell |
| 图标 | `animatedIcon`、`animatedIconColor`、`animatedIconSize` | 自定义隐式动画 Icon |
| 文本 | `animatedText`、`animatedTextColor`、`animatedTextSize`、`animatedTextStyle` | 自定义隐式动画 Text |

## 组合方式

`animate()` 是所有动画链式扩展的配置提供者。通过 `extensions.dart` 使用时采用命名参数，便于只覆盖时长或曲线：

```dart
widget.animate(
  duration: const Duration(milliseconds: 220),
  curve: Curves.easeOut,
);
```

直接导入 `animation_extension.dart` 的旧代码仍可使用位置参数 `widget.animate(duration)`，新代码统一从 `extensions.dart` 导入并使用命名参数。

动画扩展支持配置位于动画调用前后两种链式顺序，最终读取到的时长与曲线一致：

```dart
widget
    .animate(duration: const Duration(milliseconds: 220))
    .animatedPadding(all: spacePaddingLarge);

widget
    .animatedPadding(all: spacePaddingLarge)
    .animate(duration: const Duration(milliseconds: 220));
```

链条未调用 `animate()` 时使用默认配置，不要求额外包裹动画上下文。

```dart
/// 根据选中状态动画化卡片的背景、边距和缩放。
Widget buildSelectableCard(bool selected, AppTheme theme) {
  return const Text('选择主题')
      // 内边距扩展使用命名尺寸参数，状态变化时会补间到新值。
      .animatedPadding(
        all: selected ? spacePaddingLarge : spacePaddingSmall,
      )
      .animatedDecoration(
        BoxDecoration(
          color: selected ? theme.primaryLight : theme.backgroundContainer,
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
      )
      // 链条末尾的动画配置会被前面的动画扩展读取。
      .animate(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
}
```

## 交互动画示例

```dart
/// 为完整操作区域提供按下缩放反馈。
Widget buildAnimatedAction(VoidCallback onTap, AppTheme theme) {
  return const Text('保存')
      .padAll(spacePaddingLarge)
      .backgroundColor(theme.primary)
      .clipRadius(radiusDefault)
      // 内部组件持有 AnimationController，并在松手时触发业务回调。
      .animatedTapScale(onTap, duration: const Duration(milliseconds: 100));
}
```

## 文本与图标示例

```dart
/// 主题状态变化时平滑过渡标题颜色与字号。
Widget buildAnimatedTitle(bool active, AppTheme theme) {
  return Text(active ? '已启用' : '未启用')
      // Text 扩展只替换文本样式相关字段，不改变语义内容。
      .animatedTextColor(
        active ? theme.primary : theme.textSecondary,
        duration: const Duration(milliseconds: 180),
      )
      .animatedTextSize(
        active ? 18 : 14,
        duration: const Duration(milliseconds: 180),
      );
}
```

文本样式扩展只对 `Text` 接收者生效，图标样式扩展只对 `Icon` 接收者生效；类型不匹配时原样返回接收者，不会丢失语义、富文本或图标字段。颜色、字号和样式扩展可以连续组合，并共同参与重建后的补间动画。

## 时长、曲线和重建

隐式动画依靠父组件传入新属性值触发；状态不变时不会开始动画。优先让小范围 `Obx` 或 `ValueListenableBuilder` 包住需要变化的控件，避免把整个长列表放进一个响应式 build。`animatedTapScale`、`animatedHover` 等内部有 `AnimationController`，列表滚动时必须保持 item 的 key 和数据身份稳定，避免频繁销毁重建。

## 适用边界

- 适合状态切换、轻量反馈、主题颜色变化和简单出现/消失。
- 连续手势驱动、复杂编排、跨页面 Hero 或需要精确时间线时使用 Flutter `AnimationController`、`AnimatedBuilder`、`Hero` 或专用状态管理。
- 大面积 blur、频繁 transform 和大量同步隐式动画会增加合成压力；列表内应限制动画数量与时长。
- `animatedOverflowBox` 使用有限的父约束参与补间，避免默认无穷约束产生 `NaN` 或无限布局；确需无界布局时应直接使用 Flutter 原生布局组件并明确约束。

## 关联阅读

- [Widget 链式扩展](./widget-extensions.md)
- [设计系统](./design-system.md)
- [主题系统](./theme.md)
