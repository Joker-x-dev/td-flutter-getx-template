import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/design_system/extensions/widget/grid_view_extension.dart';
import 'package:flutter_kit/core/design_system/extensions/widget/list_view_extension.dart';
import 'package:flutter_kit/core/design_system/extensions/widget/scroll_extension.dart';

import '../../../../support/extension_test_harness.dart';

/// 列表、网格与滚动链式扩展测试。

void main() {
  testWidgets('数据列表按 index 和 item 构建并传递滚动参数', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    final data = <String>['甲', '乙', '丙'];
    await pumpExtensionTestApp(
      tester,
      data.toListView(
        key: const ValueKey<String>('list'),
        itemBuilder: (_, index, item) => Text('$index:$item'),
        controller: controller,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemExtent: 30,
        scrollCacheExtent: const ScrollCacheExtent.pixels(120),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        clipBehavior: Clip.antiAlias,
      ),
    );
    expect(find.text('0:甲'), findsOneWidget);
    expect(find.text('2:丙'), findsOneWidget);
    final list = tester.widget<ListView>(find.byKey(const ValueKey('list')));
    expect(list.controller, same(controller));
    expect(list.physics, isA<ClampingScrollPhysics>());
    expect(list.scrollCacheExtent, const ScrollCacheExtent.pixels(120));
    expect(list.keyboardDismissBehavior, ScrollViewKeyboardDismissBehavior.onDrag);
    expect(list.clipBehavior, Clip.antiAlias);
    final legacyCache = data.toListView(
      itemBuilder: (_, index, item) => Text('$index$item'),
      cacheExtent: 24,
    ) as ListView;
    expect(legacyCache.scrollCacheExtent, const ScrollCacheExtent.pixels(24));
  });

  testWidgets('分隔列表按边界构建两个分隔符', (tester) async {
    final data = <String>['甲', '乙', '丙'];
    await pumpExtensionTestApp(
      tester,
      data.toListViewSeparated(
        itemBuilder: (_, index, item) => Text('$index$item'),
        separatorBuilder: (_, index) => Text('分隔$index'),
        shrinkWrap: true,
        cacheExtent: 80,
      ),
    );
    expect(find.text('分隔0'), findsOneWidget);
    expect(find.text('分隔1'), findsOneWidget);
    expect(find.text('分隔2'), findsNothing);
    expect(
      tester.widget<ListView>(find.byType(ListView)).scrollCacheExtent,
      const ScrollCacheExtent.pixels(80),
    );
  });

  testWidgets('Builder 的 itemCount 参数限制构建数量', (tester) async {
    final data = <int>[1, 2, 3, 4];
    await pumpExtensionTestApp(
      tester,
      data.toListViewBuilder(
        itemCount: 2,
        semanticChildCount: 2,
        itemBuilder: (_, index) => Text('索引$index'),
        shrinkWrap: true,
      ),
    );
    expect(find.text('索引0'), findsOneWidget);
    expect(find.text('索引1'), findsOneWidget);
    expect(find.text('索引2'), findsNothing);
    expect(tester.widget<ListView>(find.byType(ListView)).semanticChildCount, 2);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: data.toListViewBuilder(
          itemBuilder: (_, index) => Text('默认$index'),
          cacheExtent: 32,
        ),
      ),
    );
    final defaultList = tester.widget<ListView>(find.byType(ListView));
    expect(defaultList.semanticChildCount, data.length);
    expect(defaultList.scrollCacheExtent, const ScrollCacheExtent.pixels(32));
  });

  testWidgets('数字列表覆盖空值、正数和默认弹性物理效果', (tester) async {
    await pumpExtensionTestApp(
      tester,
      3.toListView(
        itemBuilder: (_, index) => Text('数字$index'),
        shrinkWrap: true,
        scrollCacheExtent: const ScrollCacheExtent.pixels(64),
      ),
    );
    expect(find.text('数字2'), findsOneWidget);
    final list = tester.widget<ListView>(find.byType(ListView));
    expect(list.physics, isA<BouncingScrollPhysics>());
    expect(list.scrollCacheExtent, const ScrollCacheExtent.pixels(64));

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: 1.toListView(
          itemBuilder: (_, index) => Text('缓存$index'),
          cacheExtent: 16,
        ),
      ),
    );
    expect(
      tester.widget<ListView>(find.byType(ListView)).scrollCacheExtent,
      const ScrollCacheExtent.pixels(16),
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: 0.toListView(itemBuilder: (_, index) => Text('$index')),
      ),
    );
    expect(find.byType(Text), findsNothing);
  });

  testWidgets('GridView 固定列数并保持数据映射', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await pumpExtensionTestApp(
      tester,
      <String>['A', 'B', 'C'].toGridView(
        crossAxisCount: 2,
        itemBuilder: (_, index, item) => Text('$index$item'),
        mainAxisSpacing: 6,
        crossAxisSpacing: 8,
        childAspectRatio: 1.5,
        mainAxisExtent: 40,
        padding: const EdgeInsets.all(4),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        controller: controller,
        reverse: true,
      ),
    );
    expect(find.text('0A'), findsOneWidget);
    expect(find.text('2C'), findsOneWidget);
    final grid = tester.widget<GridView>(find.byType(GridView));
    final delegate = grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegate.crossAxisCount, 2);
    expect(delegate.mainAxisSpacing, 6);
    expect(delegate.crossAxisSpacing, 8);
    expect(delegate.mainAxisExtent, 40);
    expect(grid.controller, same(controller));
    expect(grid.reverse, isTrue);
  });

  test('Scroll 快捷方法传递方向、控制器和物理效果', () {
    const Widget child = SizedBox();
    final controller = ScrollController();
    addTearDown(controller.dispose);
    expect((child.scrollable(scrollDirection: Axis.horizontal, reverse: true) as SingleChildScrollView).scrollDirection, Axis.horizontal);
    expect((child.verticalScroll() as SingleChildScrollView).scrollDirection, Axis.vertical);
    expect((child.horizontalScroll() as SingleChildScrollView).scrollDirection, Axis.horizontal);
    expect((child.scrollPhysics(const ClampingScrollPhysics()) as SingleChildScrollView).physics, isA<ClampingScrollPhysics>());
    expect((child.scrollController(controller) as SingleChildScrollView).controller, same(controller));
    expect((child.bouncingScroll() as SingleChildScrollView).physics, isA<BouncingScrollPhysics>());
    expect((child.clampingScroll() as SingleChildScrollView).physics, isA<ClampingScrollPhysics>());
    expect((child.neverScroll() as SingleChildScrollView).physics, isA<NeverScrollableScrollPhysics>());
    final custom = child.customScroll(
      scrollDirection: Axis.horizontal,
      dragStartBehavior: DragStartBehavior.down,
      clipBehavior: Clip.antiAlias,
      restorationId: 'scroll',
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    ) as SingleChildScrollView;
    expect(custom.dragStartBehavior, DragStartBehavior.down);
    expect(custom.clipBehavior, Clip.antiAlias);
    expect(custom.restorationId, 'scroll');
  });
}
