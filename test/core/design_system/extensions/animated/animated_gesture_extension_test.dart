import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_kit/core/design_system/extensions/extensions.dart';

import '../../../../support/extension_test_harness.dart';

/// 动画手势扩展测试。
void main() {
  testWidgets('动画点击覆盖按下、抬起、取消与资源释放', (tester) async {
    int taps = 0;
    final Widget child = const SizedBox(
      key: ValueKey<String>('动画点击'),
      width: 80,
      height: 40,
      child: ColoredBox(color: Colors.transparent),
    ).animatedTap(() => taps++);

    await pumpExtensionTestApp(tester, child);
    final Offset center = tester.getCenter(find.byKey(const ValueKey('动画点击')));
    final TestGesture firstGesture = await tester.startGesture(center);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(_containsScale(tester, 0.95), isTrue);
    await firstGesture.up();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(taps, 1);
    expect(_containsScale(tester, 1), isTrue);

    final TestGesture cancelledGesture = await tester.startGesture(center);
    await tester.pump(const Duration(milliseconds: 30));
    await cancelledGesture.cancel();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(taps, 1);

    await disposeExtensionTestApp(tester);
  });

  testWidgets('水波纹保留颜色、圆角和可空回调', (tester) async {
    int taps = 0;
    final BorderRadius borderRadius = BorderRadius.circular(9);
    final Widget child = Column(
      children: <Widget>[
        const SizedBox(
          width: 80,
          height: 40,
          child: ColoredBox(color: Colors.transparent),
        ).animatedRipple(
          () => taps++,
          splashColor: Colors.red,
          highlightColor: Colors.blue,
          borderRadius: borderRadius,
        ),
        const SizedBox(
          width: 80,
          height: 40,
          child: ColoredBox(color: Colors.transparent),
        ).animatedRipple(null),
      ],
    );

    await pumpExtensionTestApp(tester, child);

    final List<InkWell> inkWells = tester
        .widgetList<InkWell>(find.byType(InkWell))
        .toList();
    expect(inkWells.first.splashColor, Colors.red);
    expect(inkWells.first.highlightColor, Colors.blue);
    expect(inkWells.first.borderRadius, borderRadius);
    expect(inkWells.last.onTap, isNull);
    await tester.tap(find.byType(InkWell).first);
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('组合缩放点击同步重建参数并覆盖取消', (tester) async {
    int taps = 0;
    double scale = 0.9;
    Duration duration = const Duration(milliseconds: 80);
    late StateSetter rebuild;

    await pumpExtensionTestApp(
      tester,
      StatefulBuilder(
        builder: (context, setState) {
          rebuild = setState;
          return const SizedBox(
            key: ValueKey<String>('组合点击'),
            width: 80,
            height: 40,
            child: ColoredBox(color: Colors.transparent),
          ).animatedTapScale(
            () => taps++,
            splashColor: Colors.orange,
            highlightColor: Colors.yellow,
            borderRadius: BorderRadius.circular(5),
            scaleValue: scale,
            duration: duration,
          );
        },
      ),
    );

    rebuild(() {
      scale = 0.8;
      duration = const Duration(milliseconds: 120);
    });
    await tester.pump();

    final Offset center = tester.getCenter(find.byKey(const ValueKey('组合点击')));
    final TestGesture gesture = await tester.startGesture(center);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    expect(_containsScale(tester, 0.8), isTrue);
    await gesture.up();
    await tester.pump(const Duration(milliseconds: 120));
    expect(taps, 1);

    final TestGesture cancelledGesture = await tester.startGesture(center);
    await tester.pump(const Duration(milliseconds: 20));
    await cancelledGesture.cancel();
    await tester.pump(const Duration(milliseconds: 120));
    expect(taps, 1);
    await disposeExtensionTestApp(tester);
  });

  testWidgets('长按与双击分别触发一次回调', (tester) async {
    int longPresses = 0;
    int doubleTaps = 0;
    final Widget child = Column(
      children: <Widget>[
        const SizedBox(
          key: ValueKey<String>('长按'),
          width: 80,
          height: 40,
          child: ColoredBox(color: Colors.transparent),
        ).animatedLongPress(() => longPresses++),
        const SizedBox(
          key: ValueKey<String>('双击'),
          width: 80,
          height: 40,
          child: ColoredBox(color: Colors.transparent),
        ).animatedDoubleTap(() => doubleTaps++),
      ],
    );

    await pumpExtensionTestApp(tester, child);
    await tester.longPress(find.byKey(const ValueKey('长按')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('双击')));
    await tester.pump(const Duration(milliseconds: 40));
    await tester.tap(find.byKey(const ValueKey('双击')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(longPresses, 1);
    expect(doubleTaps, 1);
  });

  testWidgets('悬停进入离开并同步重建后的配置', (tester) async {
    double scale = 1.1;
    Duration duration = const Duration(milliseconds: 80);
    Curve curve = Curves.linear;
    late StateSetter rebuild;

    await pumpExtensionTestApp(
      tester,
      StatefulBuilder(
        builder: (context, setState) {
          rebuild = setState;
          return const SizedBox(
            key: ValueKey<String>('悬停'),
            width: 80,
            height: 40,
            child: ColoredBox(color: Colors.transparent),
          ).animatedHover(scale: scale, duration: duration, curve: curve);
        },
      ),
    );

    rebuild(() {
      scale = 1.2;
      duration = const Duration(milliseconds: 120);
      curve = Curves.easeIn;
    });
    await tester.pump();

    final TestGesture mouse = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byKey(const ValueKey('悬停'))));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    expect(_containsScale(tester, 1.2), isTrue);
    await mouse.moveTo(tester.getCenter(find.byKey(const ValueKey('悬停'))));

    await mouse.moveTo(const Offset(799, 599));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    expect(_containsScale(tester, 1), isTrue);
    await mouse.moveTo(const Offset(798, 598));
    await mouse.removePointer();

    final MouseRegion region = tester.widget(find.byType(MouseRegion).last);
    expect(region.cursor, SystemMouseCursors.click);
    await disposeExtensionTestApp(tester);
  });
}

/// 判断 Widget 树是否包含指定二维缩放值。
///
/// [tester] Widget 测试控制器。
/// [scale] 目标缩放值。
bool _containsScale(WidgetTester tester, double scale) {
  return tester
      .widgetList<Transform>(find.byType(Transform))
      .any(
        (item) =>
            (item.transform.storage[0] - scale).abs() < 0.001 &&
            (item.transform.storage[5] - scale).abs() < 0.001,
      );
}
