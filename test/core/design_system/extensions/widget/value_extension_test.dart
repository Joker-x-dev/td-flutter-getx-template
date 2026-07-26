import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/design_system/extensions/widget/icon_extension.dart';
import 'package:flutter_kit/core/design_system/extensions/widget/text_extension.dart';
import 'package:flutter_kit/core/design_system/extensions/widget/text_span_extension.dart';
import 'package:flutter_kit/core/design_system/extensions/widget/transform_extension.dart';

/// 文本、图标与变换扩展测试。

void main() {
  test('Text copyWith 保留原字段并允许覆盖全部公共字段', () {
    const source = Text(
      '原文',
      style: TextStyle(color: Colors.red, fontSize: 12),
      strutStyle: StrutStyle(fontSize: 11),
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
      locale: Locale('zh', 'CN'),
      softWrap: true,
      overflow: TextOverflow.clip,
      textScaler: TextScaler.linear(1.1),
      maxLines: 1,
      semanticsLabel: '原语义',
      textWidthBasis: TextWidthBasis.parent,
    );

    final unchanged = source.copyWith();
    expect(unchanged.data, '原文');
    expect(unchanged.style, source.style);
    expect(unchanged.strutStyle, source.strutStyle);
    expect(unchanged.textAlign, TextAlign.left);
    expect(unchanged.textDirection, TextDirection.ltr);
    expect(unchanged.locale, const Locale('zh', 'CN'));
    expect(unchanged.softWrap, isTrue);
    expect(unchanged.overflow, TextOverflow.clip);
    expect(unchanged.textScaler, const TextScaler.linear(1.1));
    expect(unchanged.maxLines, 1);
    expect(unchanged.semanticsLabel, '原语义');
    expect(unchanged.textWidthBasis, TextWidthBasis.parent);

    final changed = source.copyWith(
      data: '新文',
      textAlign: TextAlign.end,
      textDirection: TextDirection.rtl,
      locale: const Locale('en', 'US'),
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      textScaler: const TextScaler.linear(2),
      maxLines: 2,
      semanticsLabel: '新语义',
      textWidthBasis: TextWidthBasis.longestLine,
    );
    expect(changed.data, '新文');
    expect(changed.textAlign, TextAlign.end);
    expect(changed.textDirection, TextDirection.rtl);
    expect(changed.locale, const Locale('en', 'US'));
    expect(changed.softWrap, isFalse);
    expect(changed.overflow, TextOverflow.ellipsis);
    expect(changed.maxLines, 2);
  });

  test('Text 样式链只修改目标字段', () {
    const source = Text('标题', style: TextStyle(color: Colors.black));
    final style = source.textStyle(
      const TextStyle(
        color: Colors.blue,
        backgroundColor: Colors.yellow,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
        letterSpacing: 2,
        wordSpacing: 3,
        height: 1.4,
        decoration: TextDecoration.underline,
      ),
    );
    expect(style.style?.color, Colors.blue);
    expect(style.style?.backgroundColor, Colors.yellow);
    expect(style.style?.fontSize, 18);
    expect(style.style?.fontWeight, FontWeight.w600);

    expect(source.textScale(const TextScaler.linear(1.5)).textScaler, const TextScaler.linear(1.5));
    expect(source.bold().style?.fontWeight, FontWeight.bold);
    expect(source.italic().style?.fontStyle, FontStyle.italic);
    expect(source.fontWeight(FontWeight.w300).style?.fontWeight, FontWeight.w300);
    expect(source.fontSize(20).style?.fontSize, 20);
    expect(source.fontFamily('Roboto').style?.fontFamily, 'Roboto');
    expect(source.letterSpacing(4).style?.letterSpacing, 4);
    expect(source.wordSpacing(5).style?.wordSpacing, 5);
    expect(source.textColor(Colors.green).style?.color, Colors.green);
    expect(source.textAlignment(TextAlign.center).textAlign, TextAlign.center);
    expect(source.withTextDirection(TextDirection.rtl).textDirection, TextDirection.rtl);
    expect(TextExtension(source).textDirection(TextDirection.rtl).textDirection, TextDirection.rtl);
    expect(source.textBaseline(TextBaseline.ideographic).style?.textBaseline, TextBaseline.ideographic);
    expect(source.withTextWidthBasis(TextWidthBasis.longestLine).textWidthBasis, TextWidthBasis.longestLine);
    expect(
      TextExtension(source).textWidthBasis(TextWidthBasis.longestLine).textWidthBasis,
      TextWidthBasis.longestLine,
    );

    final shadow = source.textShadow(
      color: Colors.purple,
      blurRadius: 6,
      offset: const Offset(2, 3),
    );
    expect(shadow.style?.shadows?.single.color, Colors.purple);
    expect(shadow.style?.shadows?.single.blurRadius, 6);
    final elevation = source.textElevation(8, angle: math.pi / 2, opacityRatio: 0.5);
    expect(elevation.style?.shadows?.single.blurRadius, 8);
    expect(elevation.style?.shadows?.single.offset.dx, closeTo(8, 0.0001));
  });

  test('TextSpan 扩展保留内容、子节点和识别器', () {
    final recognizer = TapGestureRecognizer();
    addTearDown(recognizer.dispose);
    final source = TextSpan(
      text: '片段',
      children: const <InlineSpan>[TextSpan(text: '子项')],
      style: const TextStyle(color: Colors.black),
      recognizer: recognizer,
      semanticsLabel: '语义',
    );
    final copied = source.copyWith();
    expect(copied.text, '片段');
    expect(copied.children, source.children);
    expect(copied.recognizer, same(recognizer));
    expect(copied.semanticsLabel, '语义');

    expect(source.textStyle(const TextStyle(fontSize: 18)).style?.fontSize, 18);
    expect(const TextSpan(text: '空').textStyle(const TextStyle(fontSize: 16)).style?.fontSize, 16);
    expect(source.bold().style?.fontWeight, FontWeight.bold);
    expect(source.italic().style?.fontStyle, FontStyle.italic);
    expect(source.fontWeight(FontWeight.w500).style?.fontWeight, FontWeight.w500);
    expect(source.fontSize(22).style?.fontSize, 22);
    expect(source.fontFamily('Mono').style?.fontFamily, 'Mono');
    expect(source.letterSpacing(2).style?.letterSpacing, 2);
    expect(source.wordSpacing(3).style?.wordSpacing, 3);
    expect(source.textColor(Colors.orange).style?.color, Colors.orange);
    expect(source.textBaseline(TextBaseline.alphabetic).style?.textBaseline, TextBaseline.alphabetic);
    expect(source.textShadow(blurRadius: 4).style?.shadows?.single.blurRadius, 4);
    expect(source.textElevation(5).style?.shadows?.single.blurRadius, 5);
  });

  test('Icon 扩展覆盖目标字段并保留其他字段', () {
    const source = Icon(
      Icons.arrow_forward,
      size: 18,
      color: Colors.red,
      semanticLabel: '箭头',
      textDirection: TextDirection.ltr,
    );
    final resized = source.iconSize(30);
    expect(resized.size, 30);
    expect(resized.color, Colors.red);
    expect(source.iconColor(Colors.blue).color, Colors.blue);
    expect(source.withSemanticLabel('下一步').semanticLabel, '下一步');
    expect(source.withTextDirection(TextDirection.rtl).textDirection, TextDirection.rtl);
    final copied = source.copyWith(
      size: 24,
      color: Colors.green,
      semanticLabel: '完成',
      textDirection: TextDirection.rtl,
    );
    expect(copied.size, 24);
    expect(copied.color, Colors.green);
    expect(copied.semanticLabel, '完成');
    expect(copied.textDirection, TextDirection.rtl);
    final unchanged = source.copyWith();
    expect(unchanged.size, 18);
    expect(unchanged.color, Colors.red);
    expect(unchanged.semanticLabel, '箭头');
    expect(unchanged.textDirection, TextDirection.ltr);
  });

  test('Transform 扩展生成精确矩阵并保留命中参数', () {
    const child = SizedBox();
    final rotated = child.rotate(math.pi / 4) as Transform;
    final degrees = child.rotateDegrees(45) as Transform;
    expect(rotated.transform.storage, orderedEquals(degrees.transform.storage));

    final scaled = child.scale(2, transformHitTests: false) as Transform;
    expect(scaled.transformHitTests, isFalse);
    expect(scaled.transform.storage[0], 2);
    final scaledXY = child.scaleXY(2, 3) as Transform;
    expect(scaledXY.transform.storage[0], 2);
    expect(scaledXY.transform.storage[5], 3);

    expect((child.translate(const Offset(4, 5)) as Transform).transform.storage[12], 4);
    expect((child.translateXY(6, 7) as Transform).transform.storage[13], 7);
    expect((child.translateX(8) as Transform).transform.storage[12], 8);
    expect((child.translateY(9) as Transform).transform.storage[13], 9);
    expect(child.transform(Matrix4.identity()), isA<Transform>());
    expect(child.skew(0.1, 0.2), isA<Transform>());
    expect(child.skewX(0.3), isA<Transform>());
    expect(child.skewY(0.4), isA<Transform>());
    expect((child.flipHorizontal() as Transform).transform.storage[0], -1);
    expect((child.flipVertical() as Transform).transform.storage[5], -1);

    final first = Matrix4.translationValues(10, 0, 0);
    final second = Matrix4.diagonal3Values(2, 3, 1);
    final combined = child.multiTransform(<Matrix4>[first, second]) as Transform;
    final expected = Matrix4.identity()..multiply(first)..multiply(second);
    expect(combined.transform.storage, orderedEquals(expected.storage));
  });
}
