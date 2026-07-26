import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/ui/adaptive/adaptive_config.dart';
import 'package:flutter_kit/core/ui/adaptive/adaptive_extension.dart';

/// 响应式断点边界和取值回退测试。
void main() {
  test('断点边界按 320、600、840 dp 切换', () {
    expect(BreakpointType.fromWidth(319.9), BreakpointType.xs);
    expect(BreakpointType.fromWidth(320), BreakpointType.sm);
    expect(BreakpointType.fromWidth(599.9), BreakpointType.sm);
    expect(BreakpointType.fromWidth(600), BreakpointType.md);
    expect(BreakpointType.fromWidth(839.9), BreakpointType.md);
    expect(BreakpointType.fromWidth(840), BreakpointType.lg);
  });

  test('取值优先当前断点并依次向小断点和大断点回退', () {
    expect(BreakpointType.md.bp(xs: 1, md: 3, lg: 4), 3);
    expect(BreakpointType.md.bp(xs: 1, lg: 4), 1);
    expect(BreakpointType.xs.bp(md: 3, lg: 4), 3);
  });

  test('全部断点为空时使用默认值或抛出参数异常', () {
    expect(BreakpointType.lg.bp<int>(defaultValue: 9), 9);
    expect(() => BreakpointType.sm.bp<int>(), throwsA(isA<ArgumentError>()));
  });

  testWidgets('BuildContext 暴露当前断点和配置对象解析能力', (WidgetTester tester) async {
    late BuildContext testContext;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(700, 900)),
        child: Builder(
          builder: (BuildContext context) {
            testContext = context;
            return const SizedBox();
          },
        ),
      ),
    );

    expect(testContext.currentBreakpoint, BreakpointType.md);
    expect(testContext.isMD, isTrue);
    expect(testContext.isXS, isFalse);
    expect(testContext.isSM, isFalse);
    expect(testContext.isLG, isFalse);
    expect(testContext.bp(xs: 'xs', md: 'md'), 'md');
    expect(
      testContext.bpByOptions(
        const BreakpointValueOptions<String>(sm: 'small', lg: 'large'),
      ),
      'small',
    );
  });
}
