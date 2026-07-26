import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_kit/core/design_system/extensions/extensions.dart';

import '../../../../support/extension_test_harness.dart';

/// 动画文本与图标扩展测试。
void main() {
  group('动画文本', () {
    testWidgets('创建文本保留展示、语义和布局字段', (tester) async {
      final Widget child = const SizedBox().animatedText(
        '动画文本',
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeIn,
        style: const TextStyle(color: Colors.red, fontSize: 18),
        textAlign: TextAlign.end,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        semanticsLabel: '语义文本',
      );

      await pumpExtensionTestApp(tester, child);

      final Text text = tester.widget<Text>(find.text('动画文本'));
      expect(text.style?.color, Colors.red);
      expect(text.style?.fontSize, 18);
      expect(text.textAlign, TextAlign.end);
      expect(text.maxLines, 2);
      expect(text.overflow, TextOverflow.ellipsis);
      expect(text.semanticsLabel, '语义文本');
      expect(_diagnosticsForImplicitWidget(tester), contains('动画文本'));
    });

    testWidgets('颜色、字号和样式链式调用合并目标样式', (tester) async {
      final Widget child =
          const Text('链式文本', style: TextStyle(fontWeight: FontWeight.w400))
              .animatedTextColor(Colors.blue)
              .animatedTextSize(24)
              .animatedTextStyle(
                const TextStyle(
                  letterSpacing: 2,
                  decoration: TextDecoration.underline,
                ),
              );

      await pumpExtensionTestApp(tester, child);

      final Text text = tester.widget<Text>(find.text('链式文本'));
      expect(text.style?.color, Colors.blue);
      expect(text.style?.fontSize, 24);
      expect(text.style?.fontWeight, FontWeight.w400);
      expect(text.style?.letterSpacing, 2);
      expect(text.style?.decoration, TextDecoration.underline);
    });

    testWidgets('重建时在中点补间文本颜色和字号', (tester) async {
      Color color = Colors.red;
      double size = 10;
      late StateSetter rebuild;

      await pumpExtensionTestApp(
        tester,
        StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return const Text('补间文本')
                .animatedTextColor(
                  color,
                  duration: const Duration(milliseconds: 100),
                )
                .animatedTextSize(
                  size,
                  duration: const Duration(milliseconds: 100),
                );
          },
        ),
      );

      rebuild(() {
        color = Colors.blue;
        size = 30;
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      final Text text = tester.widget<Text>(find.text('补间文本'));
      expect(text.style?.fontSize, closeTo(20, 0.1));
      expect(text.style?.color, Color.lerp(Colors.red, Colors.blue, 0.5));
    });

    testWidgets('富文本复制全部公共字段并覆盖富文本分支', (tester) async {
      const Text source = Text.rich(
        TextSpan(
          text: '富文本',
          children: <InlineSpan>[TextSpan(text: '内容')],
        ),
        strutStyle: StrutStyle(height: 1.2),
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        locale: Locale('zh', 'CN'),
        softWrap: false,
        overflow: TextOverflow.fade,
        textScaler: TextScaler.linear(1.2),
        maxLines: 3,
        semanticsLabel: '富文本语义',
        semanticsIdentifier: 'rich-text',
        textWidthBasis: TextWidthBasis.longestLine,
        selectionColor: Colors.yellow,
      );
      final Widget child = source.animatedTextStyle(
        const TextStyle(color: Colors.green),
      );

      await pumpExtensionTestApp(tester, child);

      final Text text = tester.widget<Text>(find.byType(Text).last);
      expect(text.textSpan, same(source.textSpan));
      expect(text.strutStyle, source.strutStyle);
      expect(text.textDirection, TextDirection.rtl);
      expect(text.locale, const Locale('zh', 'CN'));
      expect(text.softWrap, isFalse);
      expect(text.textScaler, const TextScaler.linear(1.2));
      expect(text.semanticsIdentifier, 'rich-text');
      expect(text.selectionColor, Colors.yellow);
      expect(text.style?.color, Colors.green);
    });

    test('非文本接收者保持原对象', () {
      const Widget source = SizedBox();
      expect(source.animatedTextColor(Colors.red), same(source));
      expect(source.animatedTextSize(20), same(source));
      expect(source.animatedTextStyle(const TextStyle()), same(source));
    });

    test('颜色与字号覆盖直接入口和反向链式入口', () {
      final Widget directSize = const Text('直接字号').animatedTextSize(18);
      final Widget chainedColor = const Text(
        '链式颜色',
      ).animatedTextSize(18).animatedTextColor(Colors.red);
      final Widget generatedChain = const SizedBox()
          .animatedText('生成文本')
          .animatedTextColor(Colors.blue);

      expect(directSize, isA<ImplicitlyAnimatedWidget>());
      expect(chainedColor, isA<ImplicitlyAnimatedWidget>());
      expect(generatedChain, isA<ImplicitlyAnimatedWidget>());
    });
  });

  group('动画图标', () {
    testWidgets('创建图标保留基础参数和诊断属性', (tester) async {
      final Widget child = const SizedBox().animatedIcon(
        Icons.favorite,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        color: Colors.red,
        size: 26,
        semanticLabel: '收藏',
        textDirection: TextDirection.rtl,
      );

      await pumpExtensionTestApp(tester, child);

      final Icon icon = tester.widget<Icon>(find.byIcon(Icons.favorite));
      expect(icon.color, Colors.red);
      expect(icon.size, 26);
      expect(icon.semanticLabel, '收藏');
      expect(icon.textDirection, TextDirection.rtl);
      expect(_diagnosticsForImplicitWidget(tester), contains('IconData'));
    });

    testWidgets('颜色尺寸链保留 Icon 其余公共字段', (tester) async {
      const Icon source = Icon(
        Icons.star,
        size: 20,
        fill: 0.5,
        weight: 400,
        grade: 10,
        opticalSize: 24,
        color: Colors.red,
        shadows: <Shadow>[Shadow(blurRadius: 2)],
        semanticLabel: '星标',
        textDirection: TextDirection.rtl,
        applyTextScaling: true,
        blendMode: BlendMode.srcIn,
        fontWeight: FontWeight.w600,
      );
      final Widget child = source
          .animatedIconColor(Colors.blue)
          .animatedIconSize(32);

      await pumpExtensionTestApp(tester, child);

      final Icon icon = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(icon.color, Colors.blue);
      expect(icon.size, 32);
      expect(icon.fill, 0.5);
      expect(icon.weight, 400);
      expect(icon.grade, 10);
      expect(icon.opticalSize, 24);
      expect(icon.shadows, source.shadows);
      expect(icon.applyTextScaling, isTrue);
      expect(icon.blendMode, BlendMode.srcIn);
      expect(icon.fontWeight, FontWeight.w600);
    });

    testWidgets('重建时在中点补间图标颜色和尺寸', (tester) async {
      Color color = Colors.red;
      double size = 10;
      late StateSetter rebuild;

      await pumpExtensionTestApp(
        tester,
        StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return const Icon(Icons.home)
                .animatedIconColor(
                  color,
                  duration: const Duration(milliseconds: 100),
                )
                .animatedIconSize(
                  size,
                  duration: const Duration(milliseconds: 100),
                );
          },
        ),
      );

      rebuild(() {
        color = Colors.blue;
        size = 30;
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      final Icon icon = tester.widget<Icon>(find.byIcon(Icons.home));
      expect(icon.size, closeTo(20, 0.1));
      expect(icon.color, Color.lerp(Colors.red, Colors.blue, 0.5));
    });

    testWidgets('可空颜色尺寸覆盖无补间分支', (tester) async {
      final Widget child = const Icon(
        Icons.info,
      ).animatedIcon(Icons.info, color: null, size: null);

      await pumpExtensionTestApp(tester, child);

      final Icon icon = tester.widget<Icon>(find.byIcon(Icons.info));
      expect(icon.color, isNull);
      expect(icon.size, isNull);
    });

    test('非图标接收者保持原对象', () {
      const Widget source = SizedBox();
      expect(source.animatedIconColor(Colors.red), same(source));
      expect(source.animatedIconSize(20), same(source));
    });

    test('颜色与尺寸覆盖直接入口和反向链式入口', () {
      final Widget directSize = const Icon(Icons.add).animatedIconSize(18);
      final Widget chainedColor = const Icon(
        Icons.add,
      ).animatedIconSize(18).animatedIconColor(Colors.red);

      expect(directSize, isA<ImplicitlyAnimatedWidget>());
      expect(chainedColor, isA<ImplicitlyAnimatedWidget>());
    });
  });
}

/// 返回首个扩展隐式动画组件的诊断文本。
///
/// [tester] Widget 测试控制器。
String _diagnosticsForImplicitWidget(WidgetTester tester) {
  final Finder finder = find.byWidgetPredicate(
    (Widget item) => item is ImplicitlyAnimatedWidget,
  );
  final ImplicitlyAnimatedWidget widget = tester.widget(finder.last);
  final State<StatefulWidget> state = tester.state(finder.last);
  return '${widget.toDiagnosticsNode().toStringDeep()}'
      '${state.toDiagnosticsNode().toStringDeep()}';
}
