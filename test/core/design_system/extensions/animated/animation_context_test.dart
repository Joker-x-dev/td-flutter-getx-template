import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_kit/core/design_system/extensions/animated/animated_widget_extension.dart'
    as compatibility;
import 'package:flutter_kit/core/design_system/extensions/animated/animation_extension.dart'
    as legacy;
import 'package:flutter_kit/core/design_system/extensions/extensions.dart'
    as canonical;

import '../../../../support/extension_test_harness.dart';

/// 链式动画配置协议与兼容入口测试。
void main() {
  group('动画配置作用域', () {
    test('相同配置不通知，时长或曲线变化时通知', () {
      const canonical.ExtensionAnimationConfig baseConfig =
          canonical.ExtensionAnimationConfig(
            duration: Duration(milliseconds: 120),
            curve: Curves.linear,
          );
      const canonical.ExtensionAnimationScope baseScope =
          canonical.ExtensionAnimationScope(
            config: baseConfig,
            child: SizedBox(),
          );

      expect(
        baseScope.updateShouldNotify(
          const canonical.ExtensionAnimationScope(
            config: baseConfig,
            child: SizedBox(),
          ),
        ),
        isFalse,
      );
      expect(
        baseScope.updateShouldNotify(
          const canonical.ExtensionAnimationScope(
            config: canonical.ExtensionAnimationConfig(
              duration: Duration(milliseconds: 121),
              curve: Curves.linear,
            ),
            child: SizedBox(),
          ),
        ),
        isTrue,
      );
      expect(
        baseScope.updateShouldNotify(
          const canonical.ExtensionAnimationScope(
            config: canonical.ExtensionAnimationConfig(
              duration: Duration(milliseconds: 120),
              curve: Curves.easeIn,
            ),
            child: SizedBox(),
          ),
        ),
        isTrue,
      );
    });

    testWidgets('规范链顺序向全部动画构建器传递配置', (tester) async {
      final Widget child =
          canonical.ExtensionAnimationContext(
            canonical.AnimatedLayoutExtension(
              canonical.AnimatedDecorationExtension(
                const SizedBox(key: ValueKey<String>('内容')),
              ).animatedBackgroundColor(Colors.blue),
            ).animatedPadding(all: 12),
          ).animate(
            duration: const Duration(milliseconds: 640),
            curve: Curves.easeIn,
          );

      await pumpExtensionTestApp(tester, child);

      final AnimatedPadding padding = tester.widget(
        find.byType(AnimatedPadding),
      );
      final AnimatedContainer decoration = tester.widget(
        find.byType(AnimatedContainer).first,
      );
      expect(padding.duration, const Duration(milliseconds: 640));
      expect(padding.curve, Curves.easeIn);
      expect(decoration.duration, const Duration(milliseconds: 640));
      expect(decoration.curve, Curves.easeIn);
      expect(find.byKey(const ValueKey<String>('内容')), findsOneWidget);
    });

    testWidgets('旧链顺序和位置参数入口保持兼容', (tester) async {
      final Widget legacyScope = legacy.AnimationExtension(
        const SizedBox(key: ValueKey<String>('旧入口')),
      ).animate(const Duration(milliseconds: 510), curve: Curves.bounceIn);
      final Widget child = canonical.AnimatedLayoutExtension(
        legacyScope,
      ).animatedPadding(all: 9);

      await pumpExtensionTestApp(tester, child);

      final AnimatedPadding padding = tester.widget(
        find.byType(AnimatedPadding),
      );
      expect(padding.duration, const Duration(milliseconds: 510));
      expect(padding.curve, Curves.bounceIn);
      expect(find.byKey(const ValueKey<String>('旧入口')), findsOneWidget);
    });

    testWidgets('重复配置只保留最后一次配置', (tester) async {
      final Widget firstScope = canonical.ExtensionAnimationContext(
        const SizedBox(),
      ).animate(duration: const Duration(milliseconds: 100));
      final Widget replacedScope =
          canonical.ExtensionAnimationContext(firstScope).animate(
            duration: const Duration(milliseconds: 700),
            curve: Curves.fastOutSlowIn,
          );
      final Widget child = canonical.AnimatedLayoutExtension(
        replacedScope,
      ).animatedPadding(all: 4);

      await pumpExtensionTestApp(tester, child);

      final AnimatedPadding padding = tester.widget(
        find.byType(AnimatedPadding),
      );
      expect(padding.duration, const Duration(milliseconds: 700));
      expect(padding.curve, Curves.fastOutSlowIn);
    });

    testWidgets('缺少动画配置时给出明确错误', (tester) async {
      final Widget child = canonical.AnimatedLayoutExtension(
        const SizedBox(),
      ).animatedPadding(all: 8);

      await pumpExtensionTestApp(tester, child);

      final Object? error = tester.takeException();
      expect(error, isA<FlutterError>());
      expect(error.toString(), contains('动画扩展缺少配置'));
    });
  });

  group('通用动画兼容层', () {
    testWidgets('命名参数兼容入口支持装饰约束变换和边距', (tester) async {
      Widget child = const SizedBox(key: ValueKey<String>('兼容内容'));
      child = compatibility.AnimatedWidgetExtension(
        child,
      ).animatedDecoration(const BoxDecoration(color: Colors.red));
      child = compatibility.AnimatedWidgetExtension(child).animatedConstraints(
        const BoxConstraints.tightFor(width: 40, height: 30),
      );
      child = compatibility.AnimatedWidgetExtension(
        child,
      ).animatedTransform(Matrix4.translationValues(5, 6, 0));
      child = compatibility.AnimatedWidgetExtension(
        child,
      ).animatedPadding(const EdgeInsets.all(7));
      child = compatibility.AnimatedWidgetExtension(
        child,
      ).animatedMargin(const EdgeInsets.all(8));
      child = compatibility.AnimatedWidgetExtension(child).animate(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOut,
      );

      await pumpExtensionTestApp(tester, child);
      await tester.pump(const Duration(milliseconds: 420));

      expect(find.byKey(const ValueKey<String>('兼容内容')), findsOneWidget);
      expect(find.byType(AnimatedContainer), findsNWidgets(3));
      expect(find.byType(AnimatedPadding), findsOneWidget);
      expect(find.byType(TweenAnimationBuilder<Matrix4>), findsOneWidget);
    });

    testWidgets('兼容装饰支持前景位置且旧顺序可消费配置', (tester) async {
      final Widget scope = compatibility.AnimatedWidgetExtension(
        const SizedBox(),
      ).animate(duration: const Duration(milliseconds: 230));
      final Widget child = compatibility.AnimatedWidgetExtension(scope)
          .animatedDecoration(
            const BoxDecoration(color: Colors.green),
            position: DecorationPosition.foreground,
          );

      await pumpExtensionTestApp(tester, child);

      final AnimatedContainer container = tester.widget(
        find.byType(AnimatedContainer),
      );
      expect(container.decoration, isNull);
      expect(container.foregroundDecoration, isA<BoxDecoration>());
      expect(container.duration, const Duration(milliseconds: 230));
    });
  });
}
