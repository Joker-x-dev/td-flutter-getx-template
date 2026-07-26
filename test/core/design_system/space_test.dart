import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/design_system/widgets/space.dart';

import '../../support/test_environment.dart';

/// 语义间距组件尺寸测试。
void main() {
  setUp(initializeCoreTestEnvironment);
  tearDown(resetCoreTestEnvironment);

  testWidgets('水平与垂直间距组件输出对应 SizedBox 尺寸', (WidgetTester tester) async {
    const List<Widget> spaces = <Widget>[
      SpaceHorizontalXSmall(),
      SpaceHorizontalSmall(),
      SpaceHorizontalMedium(),
      SpaceHorizontalLarge(),
      SpaceHorizontalXLarge(),
      SpaceHorizontalXXLarge(),
      SpaceVerticalXSmall(),
      SpaceVerticalSmall(),
      SpaceVerticalMedium(),
      SpaceVerticalLarge(),
      SpaceVerticalXLarge(),
      SpaceVerticalXXLarge(),
    ];
    await tester.pumpWidget(
      buildCoreTestApp(home: const Wrap(children: spaces)),
    );

    expect(
      spaces.take(6).map((Widget space) {
        return tester.getSize(find.byWidget(space)).width;
      }),
      <double>[4, 8, 12, 16, 24, 32],
    );
    expect(
      spaces.skip(6).map((Widget space) {
        return tester.getSize(find.byWidget(space)).height;
      }),
      <double>[4, 8, 12, 16, 24, 32],
    );
  });
}
