import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_kit/core/design_system/extensions/extensions.dart';

import '../../../../support/extension_test_harness.dart';

/// 动画装饰扩展测试。
void main() {
  group('动画装饰', () {
    testWidgets('边框、完整装饰和背景颜色读取统一动画配置', (tester) async {
      final BoxBorder border = Border.all(
        color: Colors.purple,
        width: 3,
        style: BorderStyle.solid,
        strokeAlign: BorderSide.strokeAlignOutside,
      );
      final Widget child = const SizedBox()
          .animatedBorder(
            color: Colors.purple,
            width: 3,
            strokeAlign: BorderSide.strokeAlignOutside,
          )
          .animatedDecoration(
            color: Colors.blue,
            gradient: const LinearGradient(
              colors: <Color>[Colors.red, Colors.yellow],
            ),
            border: border,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const <BoxShadow>[BoxShadow(blurRadius: 4)],
          )
          .animatedBackgroundColor(Colors.green)
          .animate(
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOut,
          );

      await pumpExtensionTestApp(tester, child);

      final List<AnimatedContainer> containers = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .toList();
      expect(containers, hasLength(3));
      expect(
        containers.every((item) => item.duration.inMilliseconds == 450),
        isTrue,
      );
      expect(containers.every((item) => item.curve == Curves.easeOut), isTrue);
      expect(
        (containers.first.decoration! as BoxDecoration).color,
        Colors.green,
      );
      expect(
        (containers[1].decoration! as BoxDecoration).gradient,
        isA<LinearGradient>(),
      );
      expect(
        ((containers.last.decoration! as BoxDecoration).border! as Border)
            .top
            .strokeAlign,
        BorderSide.strokeAlignOutside,
      );
    });

    testWidgets('圆形完整装饰支持 shape 分支', (tester) async {
      final Widget child = const SizedBox()
          .animatedDecoration(color: Colors.red, shape: BoxShape.circle)
          .animate();

      await pumpExtensionTestApp(tester, child);

      final AnimatedContainer container = tester.widget(
        find.byType(AnimatedContainer),
      );
      expect((container.decoration! as BoxDecoration).shape, BoxShape.circle);
    });
  });

  group('动画裁剪与阴影', () {
    testWidgets('四类裁剪保留裁剪参数并共享子树', (tester) async {
      final _TestRectClipper rectClipper = _TestRectClipper();
      final _TestPathClipper pathClipper = _TestPathClipper();
      final Widget child = const SizedBox(key: ValueKey<String>('裁剪内容'))
          .animatedClipRRect(
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.hardEdge,
          )
          .animatedClipRect(
            clipper: rectClipper,
            clipBehavior: Clip.antiAliasWithSaveLayer,
          )
          .animatedClipOval(clipper: rectClipper, clipBehavior: Clip.hardEdge)
          .animatedClipPath(
            clipper: pathClipper,
            clipBehavior: Clip.antiAliasWithSaveLayer,
          )
          .animate(duration: const Duration(milliseconds: 100));

      await pumpExtensionTestApp(tester, child);
      await tester.pump(const Duration(milliseconds: 100));

      final ClipRRect rounded = tester.widget(find.byType(ClipRRect));
      final ClipRect rect = tester.widget(find.byType(ClipRect));
      final ClipOval oval = tester.widget(find.byType(ClipOval));
      final ClipPath path = tester.widget(find.byType(ClipPath));
      expect(rounded.borderRadius, BorderRadius.circular(12));
      expect(rounded.clipBehavior, Clip.hardEdge);
      expect(rect.clipper, same(rectClipper));
      expect(rect.clipBehavior, Clip.antiAliasWithSaveLayer);
      expect(oval.clipper, same(rectClipper));
      expect(path.clipper, same(pathClipper));
      expect(find.byKey(const ValueKey<String>('裁剪内容')), findsOneWidget);
    });

    testWidgets('阴影使用 ShapeBorder 裁剪并补间 elevation', (tester) async {
      const ShapeBorder shape = StadiumBorder();
      final Widget child = const SizedBox()
          .animatedElevation(
            elevation: 8,
            shadowColor: Colors.orange,
            shape: shape,
          )
          .animate(
            duration: const Duration(milliseconds: 200),
            curve: Curves.linear,
          );

      await pumpExtensionTestApp(tester, child);
      expect(
        tester.widget<PhysicalShape>(find.byType(PhysicalShape)).elevation,
        0,
      );

      await tester.pump(const Duration(milliseconds: 100));
      expect(
        tester.widget<PhysicalShape>(find.byType(PhysicalShape)).elevation,
        closeTo(4, 0.01),
      );

      await tester.pump(const Duration(milliseconds: 100));
      final PhysicalShape physical = tester.widget(find.byType(PhysicalShape));
      expect(physical.elevation, 8);
      expect(physical.shadowColor, Colors.orange);
      expect(physical.clipper, isA<ShapeBorderClipper>());
    });
  });
}

/// 测试矩形裁剪器。
class _TestRectClipper extends CustomClipper<Rect> {
  /// 返回覆盖完整尺寸的矩形路径范围。
  @override
  Rect getClip(Size size) => Offset.zero & size;

  /// 固定裁剪器不触发重新裁剪。
  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}

/// 测试路径裁剪器。
class _TestPathClipper extends CustomClipper<Path> {
  /// 返回覆盖完整尺寸的矩形路径。
  @override
  Path getClip(Size size) => Path()..addRect(Offset.zero & size);

  /// 固定裁剪器不触发重新裁剪。
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
