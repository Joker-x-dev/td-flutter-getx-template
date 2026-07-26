import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/util/log/log_util.dart';
import 'package:flutter_kit/core/util/size/size_util.dart';

import '../../support/test_environment.dart';

/// SizeUtil 屏幕数据和 LogUtil 各日志级别测试。
void main() {
  setUp(initializeCoreTestEnvironment);
  tearDown(resetCoreTestEnvironment);

  testWidgets('读取屏幕、状态栏、导航栏和底部安全区尺寸', (WidgetTester tester) async {
    late List<double> sizes;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          size: Size(390, 844),
          padding: EdgeInsets.only(top: 44, bottom: 34),
        ),
        child: Builder(
          builder: (BuildContext context) {
            ScreenUtil.configure(
              data: MediaQuery.of(context),
              designSize: const Size(390, 844),
              splitScreenMode: true,
              minTextAdapt: true,
            );
            sizes = <double>[
              SizeUtil.getScreenWidth(),
              SizeUtil.getScreenHeight(),
              SizeUtil.getStatusBarHeight(),
              SizeUtil.getNavBarHeight(),
              SizeUtil.getSafeBarHeight(),
            ];
            return const SizedBox();
          },
        ),
      ),
    );

    expect(sizes, <double>[390, 844, 44, kToolbarHeight, 34]);
  });

  test('所有日志级别均可接收消息、异常和堆栈', () {
    final StateError error = StateError('日志异常');
    final StackTrace stackTrace = StackTrace.current;

    expect(() => LogUtil.d('debug', error, stackTrace), returnsNormally);
    expect(() => LogUtil.e('error', error, stackTrace), returnsNormally);
    expect(() => LogUtil.i('info', error, stackTrace), returnsNormally);
    expect(() => LogUtil.w('warning', error, stackTrace), returnsNormally);
    expect(() => LogUtil.v('trace', error, stackTrace), returnsNormally);
  });
}
