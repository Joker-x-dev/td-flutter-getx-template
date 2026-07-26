import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/design_system/extensions/widget/decoration_extension.dart';
import 'package:flutter_kit/core/design_system/extensions/widget/effect_extension.dart';
import 'package:flutter_kit/core/design_system/extensions/widget/gesture_extension.dart';

import '../../../../support/extension_test_harness.dart';

/// 装饰与视觉效果链式扩展测试。

void main() {
  test('Decoration 扩展完整构建颜色、图片和渐变', () {
    const Widget child = SizedBox();
    final image = const DecorationImage(
      image: NetworkImage('https://example.invalid/a.png'),
    );
    const linear = LinearGradient(colors: <Color>[Colors.red, Colors.blue]);
    expect(_box(child.backgroundColor(Colors.red)).color, Colors.red);
    expect(_box(child.backgroundImage(image)).image, same(image));
    expect(_box(child.backgroundGradient(linear)).gradient, same(linear));

    final linearBox = _box(
      child.backgroundLinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: const <Color>[Colors.red, Colors.green],
        stops: const <double>[0, 1],
        tileMode: TileMode.mirror,
      ),
    );
    expect(linearBox.gradient, isA<LinearGradient>());
    final radialBox = _box(
      child.backgroundRadialGradient(
        center: Alignment.topCenter,
        radius: 0.8,
        colors: const <Color>[Colors.white, Colors.black],
        focal: Alignment.center,
        focalRadius: 0.1,
      ),
    );
    expect(radialBox.gradient, isA<RadialGradient>());
    final sweepBox = _box(
      child.backgroundSweepGradient(
        startAngle: 0.2,
        endAngle: 2,
        colors: const <Color>[Colors.red, Colors.blue],
      ),
    );
    expect(sweepBox.gradient, isA<SweepGradient>());
    expect(
      _box(child.backgroundBlendMode(BlendMode.multiply)).backgroundBlendMode,
      BlendMode.multiply,
    );
  });

  test('Decoration 边角、边框、阴影和综合配置保持参数', () {
    const Widget child = SizedBox();
    final radius =
        _box(child.borderRadius(all: 4, topLeft: 8)).borderRadius
            as BorderRadius;
    expect(radius.topLeft, const Radius.circular(8));
    expect(radius.bottomRight, const Radius.circular(4));
    expect(
      _box(child.borderRadiusDirectional(all: 6)).borderRadius,
      isA<BorderRadiusDirectional>(),
    );

    final border =
        _box(child.border(all: 2, left: 3, color: Colors.red)).border as Border;
    expect(border.left.width, 3);
    expect(border.right.width, 2);
    final noBorder = _box(child.border()).border as Border;
    expect(noBorder.left, BorderSide.none);

    const shadows = <BoxShadow>[BoxShadow(color: Colors.black, blurRadius: 4)];
    expect(_box(child.boxShadow(shadows)).boxShadow, shadows);
    final material =
        child.elevation(
              5,
              borderRadius: BorderRadius.circular(8),
              shadowColor: Colors.purple,
            )
            as Material;
    expect(material.elevation, 5);
    expect(material.shadowColor, Colors.purple);

    final decorated =
        child.decorated(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10),
              boxShadow: shadows,
              backgroundBlendMode: BlendMode.screen,
              position: DecorationPosition.foreground,
            )
            as DecoratedBox;
    expect((decorated.decoration as BoxDecoration).color, Colors.orange);
    expect(decorated.position, DecorationPosition.foreground);
  });

  test('拟物效果覆盖颜色通道上限、下限和常规分支', () {
    const Widget child = SizedBox();
    for (final curve in <double>[-10, 0, 10]) {
      final box =
          child.neumorphism(
                elevation: -8,
                backgroundColor: const Color(0xFF808080),
                curve: curve,
              )
              as DecoratedBox;
      final decoration = box.decoration as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());
      expect(decoration.boxShadow, hasLength(2));
      expect(decoration.boxShadow?.first.blurRadius, 8);
    }
  });

  test('Effect 基础包装保持参数并限制透明度', () {
    const Widget child = SizedBox();
    expect((child.opacity(-1) as Opacity).opacity, 0);
    expect(
      (child.opacity(2, alwaysIncludeSemantics: true) as Opacity).opacity,
      1,
    );
    expect(
      child.backgroundBlur(sigmaX: 3, sigmaY: 4, tileMode: TileMode.mirror),
      isA<BackdropFilter>(),
    );
    expect(child.blur(sigmaX: 5, sigmaY: 6), isA<ImageFiltered>());

    final glow =
        child.glow(
              color: Colors.blue,
              blurRadius: 7,
              spreadRadius: 2,
              offset: const Offset(1, 2),
            )
            as Container;
    expect((glow.decoration as BoxDecoration).boxShadow?.single.blurRadius, 7);
    final multi =
        child.multiGlow(
              colors: const <Color>[Colors.red, Colors.green, Colors.blue],
            )
            as Container;
    expect((multi.decoration as BoxDecoration).boxShadow, hasLength(3));
    expect((child.neon(strokeWidth: 3) as Stack).children, hasLength(2));
    expect(
      (child.gradientMask(
                const LinearGradient(colors: <Color>[Colors.red, Colors.blue]),
              )
              as ShaderMask)
          .blendMode,
      BlendMode.srcIn,
    );
    expect(child.rainbowMask(blendMode: BlendMode.modulate), isA<ShaderMask>());
  });

  testWidgets('Ripple 启用时转发祖先点击，禁用时不创建 InkWell', (tester) async {
    var taps = 0;
    await pumpExtensionTestApp(
      tester,
      const SizedBox(width: 80, height: 40, child: Text('点击'))
          .ripple(
            splashColor: Colors.red,
            highlightColor: Colors.blue,
            radius: 20,
            customBorder: const StadiumBorder(),
          )
          .onTap(() => taps++),
    );
    final inkWell = tester.widget<InkWell>(find.byType(InkWell));
    expect(inkWell.splashColor, Colors.red);
    expect(inkWell.radius, 20);
    await tester.tap(find.text('点击'));
    await tester.pump();
    expect(taps, 1);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: const Text('关闭').ripple(enable: false),
      ),
    );
    expect(find.byType(InkWell), findsNothing);
    expect(find.text('关闭'), findsOneWidget);
  });

  testWidgets('循环动效在运行和释放阶段无 Ticker 泄漏', (tester) async {
    final effects = <Widget>[
      const Text('闪烁').shimmer(
        duration: const Duration(milliseconds: 100),
        minOpacity: 0.2,
        maxOpacity: 0.8,
      ),
      const Text('脉冲').pulse(
        duration: const Duration(milliseconds: 100),
        minScale: 0.8,
        maxScale: 1.2,
      ),
      const Text('呼吸').breathe(
        duration: const Duration(milliseconds: 100),
        minOpacity: 0.3,
        maxOpacity: 0.9,
      ),
      const Text(
        '抖动',
      ).shake(duration: const Duration(milliseconds: 100), offset: 6),
    ];
    await pumpExtensionTestApp(
      tester,
      Column(mainAxisSize: MainAxisSize.min, children: effects),
    );
    await tester.pump(const Duration(milliseconds: 50));
    expect(
      find.byWidgetPredicate((widget) {
        return widget is Opacity &&
            widget.child is Text &&
            (widget.child! as Text).data == '闪烁';
      }),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate((widget) {
        return widget is Opacity &&
            widget.child is Text &&
            (widget.child! as Text).data == '呼吸';
      }),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate((widget) {
        return widget is Transform &&
            widget.child is Text &&
            (widget.child! as Text).data == '脉冲';
      }),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate((widget) {
        return widget is Transform &&
            widget.child is Text &&
            (widget.child! as Text).data == '抖动';
      }),
      findsOneWidget,
    );
    await disposeExtensionTestApp(tester);
  });
}

/// 读取装饰扩展生成的 BoxDecoration。
///
/// [widget] DecoratedBox Widget。
BoxDecoration _box(Widget widget) {
  return (widget as DecoratedBox).decoration as BoxDecoration;
}
