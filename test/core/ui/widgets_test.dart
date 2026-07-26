import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:flutter_kit/core/model/entity/goods/goods.dart';
import 'package:flutter_kit/core/ui/preview/app_preview.dart';
import 'package:flutter_kit/core/ui/widgets/goods_detail_content.dart';
import 'package:flutter_kit/core/ui/widgets/goods_list_card.dart';

import '../../support/test_environment.dart';

/// 公共商品组件与 Preview Scope 可观察行为测试。
void main() {
  setUp(initializeCoreTestEnvironment);
  tearDown(resetCoreTestEnvironment);

  testWidgets('商品列表卡片展示标题、副标题、价格和销量', (WidgetTester tester) async {
    const Goods goods = Goods(
      title: '测试商品',
      subTitle: '商品副标题',
      price: 19,
      sold: 2,
    );
    await tester.pumpWidget(
      buildCoreTestApp(
        home: const Scaffold(body: GoodsListCard(goods: goods)),
      ),
    );

    expect(find.text('测试商品'), findsOneWidget);
    expect(find.text('商品副标题'), findsOneWidget);
    expect(find.text('¥19.00'), findsOneWidget);
    expect(find.text('已售 2 件'), findsOneWidget);
  });

  testWidgets('商品详情在无图片时展示占位并构建完整摘要', (WidgetTester tester) async {
    const Goods goods = Goods(
      title: '详情商品',
      subTitle: '详情副标题',
      price: 88,
      sold: 6,
      pics: <String>['', '  '],
    );
    await tester.pumpWidget(
      buildCoreTestApp(
        home: const Scaffold(
          body: SingleChildScrollView(child: GoodsDetailContent(goods: goods)),
        ),
      ),
    );

    expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    expect(find.text('详情商品'), findsOneWidget);
    expect(find.text('详情副标题'), findsOneWidget);
    expect(find.text('¥88.00'), findsOneWidget);
    expect(find.text('已售 6 件'), findsOneWidget);
    expect(find.text('商品详情'), findsOneWidget);
  });

  testWidgets('商品详情使用主图回退并展示详情图片', (WidgetTester tester) async {
    const Goods goods = Goods(
      title: '主图商品',
      mainPic: 'assets/image/logo.png',
      contentPics: <String>['assets/image/logo.png'],
    );
    await tester.pumpWidget(
      buildCoreTestApp(
        home: const Scaffold(
          body: SingleChildScrollView(child: GoodsDetailContent(goods: goods)),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(PageView), findsOneWidget);
    expect(find.byType(TDImage), findsNWidgets(2));
  });

  testWidgets('商品详情多图轮播同步页码指示器', (WidgetTester tester) async {
    const Goods goods = Goods(
      title: '轮播商品',
      pics: <String>['assets/image/logo.png', 'assets/image/logo.png'],
    );
    await tester.pumpWidget(
      buildCoreTestApp(
        home: const Scaffold(body: GoodsDetailContent(goods: goods)),
      ),
    );
    await tester.pump();

    expect(find.byType(AnimatedContainer), findsNWidgets(2));
    expect(
      tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .map((AnimatedContainer widget) => widget.constraints?.maxWidth),
      containsAll(<double>[8, 16]),
    );

    await tester.drag(find.byType(PageView), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.byType(TDImage), findsWidgets);
  });

  test('商品卡片 Preview 返回公共商品组件', () {
    expect(previewGoodsListCard(), isA<GoodsListCard>());
  });

  testWidgets('Preview Scope 加载主题并保留子组件', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildCoreTestApp(home: const AppPreviewScope(child: Text('预览内容'))),
    );
    await tester.pumpAndSettle();

    expect(find.text('预览内容'), findsOneWidget);
    expect(Theme.of(tester.element(find.text('预览内容'))).extension, isNotNull);
  });

  testWidgets('Preview Scope 按系统深色模式构建主题', (WidgetTester tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(platformBrightness: Brightness.dark),
        child: buildCoreTestApp(
          home: const AppPreviewScope(child: Text('深色预览')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      Theme.of(tester.element(find.text('深色预览'))).brightness,
      Brightness.dark,
    );
  });

  testWidgets('Preview Scope 主题资源加载失败时回退默认主题', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildCoreTestApp(
        home: DefaultAssetBundle(
          bundle: _FailingAssetBundle(),
          child: const AppPreviewScope(child: Text('回退预览')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('回退预览'), findsOneWidget);
    expect(Theme.of(tester.element(find.text('回退预览'))).extension, isNotNull);
  });

  testWidgets('组件和页面 Preview 包装提供主题与应用壳', (WidgetTester tester) async {
    final previewTheme = buildAppPreviewTheme();
    expect(previewTheme.materialLight!.brightness, Brightness.light);
    expect(previewTheme.materialDark!.brightness, Brightness.dark);

    await tester.pumpWidget(
      MaterialApp(home: wrapAppComponentPreview(const Text('组件预览'))),
    );
    await tester.pumpAndSettle();
    expect(find.text('组件预览'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(home: wrapAppScreenPreview(const Text('页面预览'))),
    );
    await tester.pumpAndSettle();
    expect(find.text('页面预览'), findsOneWidget);
  });
}

/// 始终抛出资源读取异常的测试资源包。
class _FailingAssetBundle extends CachingAssetBundle {
  /// 读取资源时抛出异常。
  @override
  Future<ByteData> load(String key) async {
    throw FlutterError('资源加载失败: $key');
  }
}
