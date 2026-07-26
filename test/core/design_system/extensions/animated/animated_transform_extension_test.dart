import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_kit/core/design_system/extensions/extensions.dart';

import '../../../../support/extension_test_harness.dart';

/// 动画变换扩展测试。
void main() {
  testWidgets('矩阵变换保留原点、方向性对齐和命中配置', (tester) async {
    final Matrix4 target = Matrix4.translationValues(20, 30, 0);
    final Widget child = const SizedBox()
        .animatedTransform(
          target,
          origin: const Offset(2, 3),
          alignment: AlignmentDirectional.bottomEnd,
          transformHitTests: false,
          filterQuality: FilterQuality.high,
        )
        .animate(
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
        );

    await pumpExtensionTestApp(tester, child, textDirection: TextDirection.rtl);
    await tester.pump(const Duration(milliseconds: 100));

    final Transform transform = tester
        .widgetList<Transform>(find.byType(Transform))
        .firstWhere((item) => item.origin == const Offset(2, 3));
    expect(transform.transform.storage[12], closeTo(10, 0.01));
    expect(transform.transform.storage[13], closeTo(15, 0.01));
    expect(transform.origin, const Offset(2, 3));
    expect(transform.alignment, AlignmentDirectional.bottomEnd);
    expect(transform.transformHitTests, isFalse);
    expect(transform.filterQuality, FilterQuality.high);
  });

  testWidgets('轴向缩放分别应用 scaleX 和 scaleY', (tester) async {
    final Widget child = const SizedBox()
        .animatedScale(
          scale: 9,
          scaleX: 2,
          scaleY: 3,
          alignment: AlignmentDirectional.topStart,
        )
        .animate(duration: Duration.zero);

    await pumpExtensionTestApp(tester, child);
    await tester.pump();

    final Transform transform = tester
        .widgetList<Transform>(find.byType(Transform))
        .firstWhere(
          (item) =>
              item.transform.storage[0] == 2 && item.transform.storage[5] == 3,
        );
    expect(transform.transform.storage[0], 2);
    expect(transform.transform.storage[5], 3);
    expect(transform.alignment, AlignmentDirectional.topStart);
  });

  testWidgets('统一缩放和默认缩放覆盖参数回退', (tester) async {
    final Widget child = Column(
      children: <Widget>[
        const SizedBox().animatedScale(scale: 1.5),
        const SizedBox().animatedScale(),
      ],
    ).animate(duration: Duration.zero);

    await pumpExtensionTestApp(tester, child);
    await tester.pump();

    final List<Transform> transforms = tester
        .widgetList<Transform>(find.byType(Transform))
        .toList();
    expect(
      transforms.any(
        (item) =>
            item.transform.storage[0] == 1.5 &&
            item.transform.storage[5] == 1.5,
      ),
      isTrue,
    );
    expect(
      transforms.any(
        (item) =>
            item.transform.storage[0] == 1 && item.transform.storage[5] == 1,
      ),
      isTrue,
    );
  });

  testWidgets('旋转弧度与角度辅助方法生成目标矩阵', (tester) async {
    final Widget child = Column(
      children: <Widget>[
        const SizedBox().animatedRotate(
          math.pi,
          origin: const Offset(1, 2),
          alignment: Alignment.topLeft,
          transformHitTests: false,
          filterQuality: FilterQuality.low,
        ),
        const SizedBox().animatedRotateDegrees(180),
      ],
    ).animate(duration: Duration.zero);

    await pumpExtensionTestApp(tester, child);
    await tester.pump();

    final List<Transform> transforms = tester
        .widgetList<Transform>(find.byType(Transform))
        .where((item) => (item.transform.storage[0] + 1).abs() < 0.0001)
        .toList();
    expect(transforms, hasLength(2));
    expect(transforms[0].transform.storage[0], closeTo(-1, 0.0001));
    expect(transforms[0].origin, const Offset(1, 2));
    expect(transforms[0].transformHitTests, isFalse);
    expect(transforms[1].transform.storage[0], closeTo(-1, 0.0001));
  });

  testWidgets('平移辅助方法覆盖 XY、单轴和底层入口', (tester) async {
    final Widget child = Column(
      children: <Widget>[
        const SizedBox().animatedTranslate(
          const Offset(1, 2),
          transformHitTests: false,
          filterQuality: FilterQuality.medium,
        ),
        const SizedBox().animatedTranslateXY(x: 3, y: 4),
        const SizedBox().animatedTranslateX(5),
        const SizedBox().animatedTranslateY(6),
      ],
    ).animate(duration: Duration.zero);

    await pumpExtensionTestApp(tester, child);
    await tester.pump();

    final List<Transform> transforms = tester
        .widgetList<Transform>(find.byType(Transform))
        .toList();
    final Set<Offset> offsets = transforms
        .map(
          (item) =>
              Offset(item.transform.storage[12], item.transform.storage[13]),
        )
        .toSet();
    expect(
      offsets,
      containsAll(const <Offset>[
        Offset(1, 2),
        Offset(3, 4),
        Offset(5, 0),
        Offset(0, 6),
      ]),
    );
    final Transform configured = transforms.firstWhere(
      (item) => item.transform.storage[12] == 1,
    );
    expect(configured.transformHitTests, isFalse);
    expect(configured.filterQuality, FilterQuality.medium);
  });

  testWidgets('倾斜与水平垂直翻转生成各自矩阵', (tester) async {
    final Widget child = Column(
      children: <Widget>[
        const SizedBox().animatedSkew(
          skewX: 0.2,
          skewY: 0.3,
          origin: const Offset(1, 1),
          alignment: Alignment.bottomRight,
          transformHitTests: false,
          filterQuality: FilterQuality.high,
        ),
        const SizedBox().animatedFlipHorizontal(),
        const SizedBox().animatedFlipVertical(),
      ],
    ).animate(duration: Duration.zero);

    await pumpExtensionTestApp(tester, child);
    await tester.pump();

    final List<Transform> transforms = tester
        .widgetList<Transform>(find.byType(Transform))
        .toList();
    expect(
      transforms.any(
        (item) =>
            (item.transform.storage[4] - 0.2).abs() < 0.0001 &&
            (item.transform.storage[1] - 0.3).abs() < 0.0001,
      ),
      isTrue,
    );
    expect(
      transforms.any(
        (item) =>
            item.transform.storage[0] == -1 && item.transform.storage[5] == 1,
      ),
      isTrue,
    );
    expect(
      transforms.any(
        (item) =>
            item.transform.storage[0] == 1 && item.transform.storage[5] == -1,
      ),
      isTrue,
    );
  });
}
