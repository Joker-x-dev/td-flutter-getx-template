import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_kit/core/design_system/extensions/extensions.dart';

import '../../../../support/extension_test_harness.dart';

/// 动画布局扩展测试。
void main() {
  group('动画边距与约束', () {
    testWidgets('内边距按具体边、轴向和全量值的优先级计算', (tester) async {
      final Widget child = const SizedBox()
          .animatedPadding(all: 1, horizontal: 2, vertical: 3, top: 4, right: 5)
          .animate(duration: const Duration(milliseconds: 90));

      await pumpExtensionTestApp(tester, child);

      final AnimatedPadding padding = tester.widget(
        find.byType(AnimatedPadding),
      );
      expect(
        padding.padding,
        const EdgeInsets.only(left: 2, top: 4, right: 5, bottom: 3),
      );
    });

    testWidgets('方向性内边距保留 start end 与垂直回退', (tester) async {
      final Widget child = const SizedBox()
          .animatedPaddingDirectional(
            all: 1,
            horizontal: 2,
            vertical: 3,
            start: 4,
            bottom: 5,
          )
          .animate();

      await pumpExtensionTestApp(
        tester,
        child,
        textDirection: TextDirection.rtl,
      );

      final AnimatedPadding padding = tester.widget(
        find.byType(AnimatedPadding),
      );
      expect(
        padding.padding,
        const EdgeInsetsDirectional.only(start: 4, top: 3, end: 2, bottom: 5),
      );
    });

    testWidgets('外边距和尺寸约束生成目标 AnimatedContainer', (tester) async {
      final Widget child = const SizedBox()
          .animatedMargin(
            all: 1,
            horizontal: 2,
            vertical: 3,
            left: 4,
            bottom: 5,
          )
          .animatedConstraints(
            width: 20,
            height: 30,
            minWidth: 10,
            maxHeight: 40,
          )
          .animate(
            duration: const Duration(milliseconds: 321),
            curve: Curves.linear,
          );

      await pumpExtensionTestApp(tester, child);

      final List<AnimatedContainer> containers = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .toList();
      final AnimatedContainer constraints = containers.first;
      final AnimatedContainer margin = containers.last;
      expect(
        constraints.constraints,
        const BoxConstraints(
          minWidth: 10,
          maxWidth: 20,
          minHeight: 30,
          maxHeight: 40,
        ),
      );
      expect(
        margin.margin,
        const EdgeInsets.only(left: 4, top: 3, right: 2, bottom: 5),
      );
      expect(
        containers.every((item) => item.duration.inMilliseconds == 321),
        isTrue,
      );
    });

    testWidgets('空参数使用无约束和零边距', (tester) async {
      final Widget child = const SizedBox()
          .animatedMargin()
          .animatedConstraints()
          .animate();

      await pumpExtensionTestApp(tester, child);

      final List<AnimatedContainer> containers = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .toList();
      expect(containers.first.constraints, const BoxConstraints());
      expect(containers.last.margin, EdgeInsets.zero);
    });
  });

  group('动画定位与对齐', () {
    testWidgets('绝对定位保留全部位置和尺寸参数', (tester) async {
      final Widget positioned = const SizedBox()
          .animatedPositioned(left: 1, top: 2, width: 20, height: 30)
          .animate(duration: const Duration(milliseconds: 111));

      await pumpExtensionTestApp(tester, Stack(children: <Widget>[positioned]));

      final AnimatedPositioned widget = tester.widget(
        find.byType(AnimatedPositioned),
      );
      expect(widget.left, 1);
      expect(widget.top, 2);
      expect(widget.right, isNull);
      expect(widget.bottom, isNull);
      expect(widget.width, 20);
      expect(widget.height, 30);
      expect(widget.duration, const Duration(milliseconds: 111));
    });

    testWidgets('方向性定位在 RTL 下保留 start end', (tester) async {
      final Widget positioned = const SizedBox()
          .animatedPositionedDirectional(
            start: 1,
            top: 3,
            width: 20,
            height: 30,
          )
          .animate();

      await pumpExtensionTestApp(
        tester,
        Stack(children: <Widget>[positioned]),
        textDirection: TextDirection.rtl,
      );

      final AnimatedPositionedDirectional widget = tester.widget(
        find.byType(AnimatedPositionedDirectional),
      );
      expect(widget.start, 1);
      expect(widget.end, isNull);
      expect(widget.top, 3);
      expect(widget.bottom, isNull);
      expect(widget.width, 20);
      expect(widget.height, 30);
    });

    testWidgets('对齐扩展保留方向性对齐和尺寸因子', (tester) async {
      final Widget child = const SizedBox()
          .animatedAlign(
            alignment: AlignmentDirectional.bottomEnd,
            widthFactor: 2,
            heightFactor: 3,
          )
          .animate(curve: Curves.decelerate);

      await pumpExtensionTestApp(tester, child);

      final AnimatedAlign align = tester.widget(find.byType(AnimatedAlign));
      expect(align.alignment, AlignmentDirectional.bottomEnd);
      expect(align.widthFactor, 2);
      expect(align.heightFactor, 3);
      expect(align.curve, Curves.decelerate);
    });
  });
}
