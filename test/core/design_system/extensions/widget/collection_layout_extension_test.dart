import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/design_system/extensions/widget/column_extension.dart';
import 'package:flutter_kit/core/design_system/extensions/widget/row_extension.dart';
import 'package:flutter_kit/core/design_system/extensions/widget/stack_extension.dart';
import 'package:flutter_kit/core/design_system/extensions/widget/wrap_extension.dart';

import '../../../../support/extension_test_harness.dart';

/// 集合布局链式扩展测试。

void main() {
  group('Row 扩展', () {
    testWidgets('基础参数、间距和自定义分隔符按契约传递', (tester) async {
      const children = <Widget>[Text('甲'), Text('乙'), Text('丙')];
      await pumpExtensionTestApp(
        tester,
        children.toRow(
          key: const ValueKey<String>('row'),
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.rtl,
          verticalDirection: VerticalDirection.up,
          spacing: 12,
        ),
      );

      final row = tester.widget<Row>(find.byKey(const ValueKey('row')));
      expect(row.mainAxisAlignment, MainAxisAlignment.end);
      expect(row.mainAxisSize, MainAxisSize.min);
      expect(row.crossAxisAlignment, CrossAxisAlignment.start);
      expect(row.textDirection, TextDirection.rtl);
      expect(row.verticalDirection, VerticalDirection.up);
      expect(row.children, hasLength(5));
      expect((row.children[1] as SizedBox).width, 12);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: children.toRow(
            spacing: 8,
            separator: const Divider(key: ValueKey<String>('separator')),
          ),
        ),
      );
      final separated = tester.widget<Row>(find.byType(Row));
      expect(separated.children, hasLength(5));
      expect(separated.children.whereType<KeyedSubtree>(), hasLength(2));
      expect(find.byKey(const ValueKey('separator')), findsNWidgets(2));
    });

    testWidgets('空列表和单元素不插入间距', (tester) async {
      await pumpExtensionTestApp(tester, <Widget>[].toRow(spacing: 8));
      expect(tester.widget<Row>(find.byType(Row)).children, isEmpty);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: <Widget>[const Text('唯一')].toRow(
            spacing: 8,
            separator: const Divider(),
          ),
        ),
      );
      expect(tester.widget<Row>(find.byType(Row)).children, hasLength(1));
    });

    testWidgets('快捷方法映射到对应主轴和交叉轴对齐', (tester) async {
      final cases = <Widget Function()>[
        () => <Widget>[const Text('项')].toRowCenter(),
        () => <Widget>[const Text('项')].toRowBetween(),
        () => <Widget>[const Text('项')].toRowAround(),
        () => <Widget>[const Text('项')].toRowEvenly(),
        () => <Widget>[const Text('项')].toRowTop(),
        () => <Widget>[const Text('项')].toRowBottom(),
        () => <Widget>[const SizedBox(width: 4)].toRowStretch(),
      ];
      const mainAlignments = <MainAxisAlignment>[
        MainAxisAlignment.center,
        MainAxisAlignment.spaceBetween,
        MainAxisAlignment.spaceAround,
        MainAxisAlignment.spaceEvenly,
        MainAxisAlignment.start,
        MainAxisAlignment.start,
        MainAxisAlignment.start,
      ];
      const crossAlignments = <CrossAxisAlignment>[
        CrossAxisAlignment.center,
        CrossAxisAlignment.center,
        CrossAxisAlignment.center,
        CrossAxisAlignment.center,
        CrossAxisAlignment.start,
        CrossAxisAlignment.end,
        CrossAxisAlignment.stretch,
      ];

      for (var index = 0; index < cases.length; index++) {
        await tester.pumpWidget(
          Directionality(textDirection: TextDirection.ltr, child: cases[index]()),
        );
        final row = tester.widget<Row>(find.byType(Row));
        expect(row.mainAxisAlignment, mainAlignments[index]);
        expect(row.crossAxisAlignment, crossAlignments[index]);
      }
    });
  });

  group('Column 扩展', () {
    testWidgets('间距、分隔符和快捷对齐均正确', (tester) async {
      const children = <Widget>[Text('甲'), Text('乙'), Text('丙')];
      await pumpExtensionTestApp(tester, children.toColumn(spacing: 10));
      final column = tester.widget<Column>(find.byType(Column).last);
      expect(column.children, hasLength(5));
      expect((column.children[1] as SizedBox).height, 10);

      final cases = <Widget Function()>[
        () => children.toColumnCenter(),
        () => children.toColumnBetween(),
        () => children.toColumnAround(),
        () => children.toColumnEvenly(),
        () => children.toColumnStart(),
        () => children.toColumnEnd(),
        () => children.toColumnStretch(),
      ];
      const mainAlignments = <MainAxisAlignment>[
        MainAxisAlignment.center,
        MainAxisAlignment.spaceBetween,
        MainAxisAlignment.spaceAround,
        MainAxisAlignment.spaceEvenly,
        MainAxisAlignment.start,
        MainAxisAlignment.start,
        MainAxisAlignment.start,
      ];
      const crossAlignments = <CrossAxisAlignment>[
        CrossAxisAlignment.center,
        CrossAxisAlignment.center,
        CrossAxisAlignment.center,
        CrossAxisAlignment.center,
        CrossAxisAlignment.start,
        CrossAxisAlignment.end,
        CrossAxisAlignment.stretch,
      ];
      for (var index = 0; index < cases.length; index++) {
        await tester.pumpWidget(
          Directionality(textDirection: TextDirection.ltr, child: cases[index]()),
        );
        final value = tester.widget<Column>(find.byType(Column));
        expect(value.mainAxisAlignment, mainAlignments[index]);
        expect(value.crossAxisAlignment, crossAlignments[index]);
      }

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: children.toColumn(
            spacing: 4,
            separator: const Divider(key: ValueKey<String>('column-separator')),
          ),
        ),
      );
      final separated = tester.widget<Column>(find.byType(Column));
      expect(separated.children, hasLength(5));
      expect(separated.children.whereType<KeyedSubtree>(), hasLength(2));
      expect(find.byKey(const ValueKey('column-separator')), findsNWidgets(2));
    });
  });

  group('Wrap 与 Stack 扩展', () {
    testWidgets('Wrap 变体设置方向、对齐和间距', (tester) async {
      const children = <Widget>[Text('甲'), Text('乙')];
      final widgets = <Widget>[
        children.toWrap(
          direction: Axis.vertical,
          alignment: WrapAlignment.end,
          spacing: 7,
          runSpacing: 9,
        ),
        children.toSpacedWrap(spacing: 11, runSpacing: 13),
        children.toCenteredWrap(spacing: 3),
        children.toVerticalWrap(spacing: 5),
      ];
      final expectedDirections = <Axis>[
        Axis.vertical,
        Axis.horizontal,
        Axis.horizontal,
        Axis.vertical,
      ];
      for (var index = 0; index < widgets.length; index++) {
        await tester.pumpWidget(
          Directionality(textDirection: TextDirection.ltr, child: widgets[index]),
        );
        final wrap = tester.widget<Wrap>(find.byType(Wrap));
        expect(wrap.direction, expectedDirections[index]);
        expect(wrap.children, hasLength(2));
      }
    });

    testWidgets('Stack 变体设置对齐、尺寸和裁剪', (tester) async {
      const children = <Widget>[SizedBox(width: 10, height: 10)];
      final widgets = <Widget>[
        children.toStack(
          alignment: Alignment.bottomRight,
          fit: StackFit.loose,
          clipBehavior: Clip.none,
        ),
        children.toCenterStack(),
        children.toExpandedStack(),
        children.toClippedStack(clipBehavior: Clip.antiAlias),
      ];
      for (final widget in widgets) {
        await tester.pumpWidget(
          Directionality(textDirection: TextDirection.ltr, child: widget),
        );
        expect(find.byType(Stack), findsOneWidget);
      }
      await tester.pumpWidget(
        Directionality(textDirection: TextDirection.ltr, child: widgets.last),
      );
      expect(tester.widget<Stack>(find.byType(Stack)).clipBehavior, Clip.antiAlias);
    });
  });
}
