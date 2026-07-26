import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/design_system/extensions/widget/gesture_extension.dart';

import '../../../../support/extension_test_harness.dart';

/// 手势链式扩展测试。

void main() {
  testWidgets('点击、双击、长按和按压阶段回调可观察', (tester) async {
    var taps = 0;
    var doubleTaps = 0;
    var longPresses = 0;
    var downs = 0;
    var ups = 0;
    var cancels = 0;

    final widgets = <Widget>[
      _target('tap').onTap(() => taps++),
      _target('double').onDoubleTap(() => doubleTaps++),
      _target('long').onLongPress(() => longPresses++),
      _target('down').onTapDown((_) => downs++),
      _target('up').onTapUp((_) => ups++),
      _target('cancel').onTapCancel(() => cancels++),
    ];
    await pumpExtensionTestApp(
      tester,
      Column(mainAxisSize: MainAxisSize.min, children: widgets),
    );

    await tester.tap(find.text('tap'));
    await tester.pump();
    await tester.tap(find.text('double'));
    await tester.pump(const Duration(milliseconds: 40));
    await tester.tap(find.text('double'));
    await tester.pumpAndSettle();
    await tester.longPress(find.text('long'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('down'));
    await tester.tap(find.text('up'));

    final cancelGesture = await tester.startGesture(tester.getCenter(find.text('cancel')));
    await cancelGesture.moveBy(const Offset(200, 0));
    await cancelGesture.up();
    await tester.pumpAndSettle();

    expect(taps, 1);
    expect(doubleTaps, 1);
    expect(longPresses, 1);
    expect(downs, 1);
    expect(ups, 1);
    expect(cancels, 1);
  });

  testWidgets('综合手势透传点击和拖拽生命周期', (tester) async {
    var taps = 0;
    var starts = 0;
    var updates = 0;
    var ends = 0;
    await pumpExtensionTestApp(
      tester,
      _target('综合').gestures(
        onTap: () => taps++,
        onPanStart: (_) => starts++,
        onPanUpdate: (_) => updates++,
        onPanEnd: (_) => ends++,
        behavior: HitTestBehavior.translucent,
      ),
    );
    expect(tester.widget<GestureDetector>(find.byType(GestureDetector).last).behavior, HitTestBehavior.translucent);
    await tester.tap(find.text('综合'));
    await tester.drag(find.text('综合'), const Offset(40, 30));
    await tester.pumpAndSettle();
    expect(taps, 1);
    expect(starts, 1);
    expect(updates, greaterThan(0));
    expect(ends, 1);
  });

  testWidgets('横向、纵向和缩放手势返回正确参数', (tester) async {
    var verticalDelta = 0.0;
    var horizontalDelta = 0.0;
    var scaleStarts = 0;
    var scaleUpdates = 0;
    var scaleEnds = 0;
    await pumpExtensionTestApp(
      tester,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _target('纵向').onVerticalDrag(
            onVerticalDragUpdate: (details) => verticalDelta += details.delta.dy,
          ),
          _target('横向').onHorizontalDrag(
            onHorizontalDragUpdate: (details) => horizontalDelta += details.delta.dx,
          ),
          _target('缩放').onScale(
            onScaleStart: (_) => scaleStarts++,
            onScaleUpdate: (_) => scaleUpdates++,
            onScaleEnd: (_) => scaleEnds++,
          ),
        ],
      ),
    );

    await tester.drag(find.text('纵向'), const Offset(0, 50));
    await tester.drag(find.text('横向'), const Offset(60, 0));
    final first = await tester.createGesture(pointer: 1);
    final second = await tester.createGesture(pointer: 2);
    final center = tester.getCenter(find.text('缩放'));
    await first.down(center - const Offset(10, 0));
    await second.down(center + const Offset(10, 0));
    await first.moveTo(center - const Offset(20, 0));
    await second.moveTo(center + const Offset(20, 0));
    await first.up();
    await second.up();
    await tester.pumpAndSettle();

    expect(verticalDelta, greaterThan(0));
    expect(horizontalDelta, greaterThan(0));
    expect(scaleStarts, greaterThan(0));
    expect(scaleUpdates, greaterThan(0));
    expect(scaleEnds, scaleStarts);
  });

  testWidgets('空回调和默认命中行为不抛异常', (tester) async {
    final widgets = <Widget>[
      _target('1').onTap(null),
      _target('2').onDoubleTap(null),
      _target('3').onLongPress(null),
      _target('4').onTapDown(null),
      _target('5').onTapUp(null),
      _target('6').onTapCancel(null),
      _target('7').gestures(),
      _target('8').onVerticalDrag(),
      _target('9').onHorizontalDrag(),
      _target('10').onScale(),
    ];
    await pumpExtensionTestApp(
      tester,
      SingleChildScrollView(child: Column(children: widgets)),
    );
    final detectors = tester.widgetList<GestureDetector>(find.byType(GestureDetector));
    expect(detectors.every((detector) => detector.behavior == HitTestBehavior.opaque), isTrue);
    expect(tester.takeException(), isNull);
  });
}

/// 构建固定命中区域。
///
/// [label] 区域文本。
Widget _target(String label) {
  return SizedBox(width: 120, height: 40, child: Center(child: Text(label)));
}
