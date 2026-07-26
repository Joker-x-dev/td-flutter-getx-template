import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_kit/core/design_system/extensions/extensions.dart';

import '../../../../support/extension_test_harness.dart';

/// 动画视觉效果扩展测试。
void main() {
  testWidgets('透明度、淡入和淡出保留语义配置', (tester) async {
    final Widget child = Column(
      children: <Widget>[
        const SizedBox().animatedOpacity(0.4, alwaysIncludeSemantics: true),
        const SizedBox().animatedFadeIn(alwaysIncludeSemantics: true),
        const SizedBox().animatedFadeOut(),
      ],
    ).animate(duration: const Duration(milliseconds: 80), curve: Curves.linear);

    await pumpExtensionTestApp(tester, child);

    final List<AnimatedOpacity> widgets = tester
        .widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity))
        .toList();
    expect(widgets.map((item) => item.opacity), <double>[0.4, 1, 0]);
    expect(widgets.first.alwaysIncludeSemantics, isTrue);
    expect(widgets[1].alwaysIncludeSemantics, isTrue);
    expect(widgets.every((item) => item.duration.inMilliseconds == 80), isTrue);
  });

  testWidgets('背景模糊同时补间 X 与 Y 参数', (tester) async {
    final Widget child = const SizedBox()
        .animatedBackdropFilter(sigmaX: 8, sigmaY: 4)
        .animate(
          duration: const Duration(milliseconds: 100),
          curve: Curves.linear,
        );

    await pumpExtensionTestApp(tester, child);
    await tester.pump(const Duration(milliseconds: 50));

    final BackdropFilter filter = tester.widget(find.byType(BackdropFilter));
    expect(filter.filter.toString(), contains('ImageFilter.blur'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('有限与无限 OverflowBox 约束均不会产生 NaN', (tester) async {
    final Widget child =
        Column(
          children: <Widget>[
            const SizedBox().animatedOverflowBox(
              minWidth: 10,
              maxWidth: 30,
              minHeight: 20,
              maxHeight: 40,
              alignment: AlignmentDirectional.bottomEnd,
            ),
            const SizedBox().animatedOverflowBox(),
          ],
        ).animate(
          duration: const Duration(milliseconds: 100),
          curve: Curves.linear,
        );

    await pumpExtensionTestApp(tester, child);
    await tester.pump(const Duration(milliseconds: 50));

    final List<OverflowBox> boxes = tester
        .widgetList<OverflowBox>(find.byType(OverflowBox))
        .toList();
    expect(boxes.first.maxWidth, closeTo(20, 0.01));
    expect(boxes.first.maxHeight, closeTo(30, 0.01));
    expect(boxes.first.alignment, AlignmentDirectional.bottomEnd);
    expect(boxes.last.maxWidth, double.infinity);
    expect(boxes.last.maxHeight, double.infinity);
    expect(tester.takeException(), isNull);
  });

  testWidgets('可见性在淡出结束后移除并可再次淡入', (tester) async {
    bool visible = true;
    late StateSetter rebuild;

    await pumpExtensionTestApp(
      tester,
      StatefulBuilder(
        builder: (context, setState) {
          rebuild = setState;
          return const SizedBox(key: ValueKey<String>('可见内容'))
              .animatedVisibility(
                visible,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                maintainInteractivity: true,
              )
              .animate(
                duration: const Duration(milliseconds: 100),
                curve: Curves.linear,
              );
        },
      ),
    );
    expect(
      tester.widget<Visibility>(find.byType(Visibility).last).visible,
      isTrue,
    );

    rebuild(() => visible = false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(
      tester.widget<Visibility>(find.byType(Visibility).last).visible,
      isTrue,
    );

    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1));
    expect(
      tester.widget<Visibility>(find.byType(Visibility).last).visible,
      isFalse,
    );

    rebuild(() => visible = true);
    await tester.pump();
    expect(
      tester.widget<Visibility>(find.byType(Visibility).last).visible,
      isTrue,
    );
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('初始隐藏状态不构建可见子树', (tester) async {
    final Widget child = const SizedBox()
        .animatedVisibility(false)
        .animate(duration: Duration.zero);

    await pumpExtensionTestApp(tester, child);

    expect(
      tester.widget<Visibility>(find.byType(Visibility).last).visible,
      isFalse,
    );
  });

  testWidgets('忽略和吸收指针初始布尔状态准确', (tester) async {
    final Widget child = Column(
      children: <Widget>[
        const SizedBox().animatedIgnorePointer(true),
        const SizedBox().animatedIgnorePointer(false),
        const SizedBox().animatedAbsorbPointer(true),
        const SizedBox().animatedAbsorbPointer(false),
      ],
    ).animate(duration: const Duration(milliseconds: 100));

    await pumpExtensionTestApp(tester, child);

    final List<IgnorePointer> ignores = tester
        .widgetList<IgnorePointer>(find.byType(IgnorePointer))
        .toList();
    final List<AbsorbPointer> absorbs = tester
        .widgetList<AbsorbPointer>(find.byType(AbsorbPointer))
        .toList();
    expect(
      ignores.skip(ignores.length - 2).map((item) => item.ignoring),
      <bool>[true, false],
    );
    expect(
      absorbs.skip(absorbs.length - 2).map((item) => item.absorbing),
      <bool>[true, false],
    );
  });

  testWidgets('着色器与颜色过滤器保留回调、模式和子树', (tester) async {
    /// 创建测试渐变着色器。
    Shader shaderCallback(Rect bounds) => const LinearGradient(
      colors: <Color>[Colors.red, Colors.blue],
    ).createShader(bounds);
    const ColorFilter colorFilter = ColorFilter.mode(
      Colors.green,
      BlendMode.color,
    );
    final Widget child = Column(
      children: <Widget>[
        const SizedBox().animatedShaderMask(
          shaderCallback,
          blendMode: BlendMode.srcIn,
        ),
        const SizedBox().animatedColorFiltered(colorFilter),
      ],
    ).animate(duration: const Duration(milliseconds: 10));

    await pumpExtensionTestApp(tester, child);
    await tester.pump(const Duration(milliseconds: 10));

    final ShaderMask mask = tester.widget(find.byType(ShaderMask));
    final ColorFiltered filtered = tester.widget(find.byType(ColorFiltered));
    expect(mask.shaderCallback, same(shaderCallback));
    expect(mask.blendMode, BlendMode.srcIn);
    expect(filtered.colorFilter, colorFilter);
    expect(
      tester
          .widgetList<Opacity>(find.byType(Opacity))
          .map((item) => item.opacity),
      everyElement(1),
    );
  });
}
