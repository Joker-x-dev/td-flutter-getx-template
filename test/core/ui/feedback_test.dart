import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:flutter_kit/core/model/response/base/base_response.dart';
import 'package:flutter_kit/core/ui/dialog/loading_dialog.dart';
import 'package:flutter_kit/core/util/aletr/alert_util.dart';
import 'package:flutter_kit/core/util/common/common_util.dart';
import 'package:flutter_kit/core/util/toast/toast_util.dart';

import '../../support/test_environment.dart';

/// Loading、Alert 与 Toast 可观察行为测试。
void main() {
  setUp(initializeCoreTestEnvironment);
  tearDown(resetCoreTestEnvironment);

  testWidgets('Toast 展示通知并可主动关闭', (WidgetTester tester) async {
    await tester.pumpWidget(buildCoreTestApp(home: const Scaffold()));
    await tester.pump();

    ToastUtil.success('保存成功');
    await tester.pumpAndSettle();
    expect(find.text('保存成功'), findsOneWidget);
    expect(find.byType(TDNoticeBar), findsOneWidget);

    ToastUtil.hide();
    await tester.pumpAndSettle();
    expect(find.text('保存成功'), findsNothing);
    ToastUtil.hide();
  });

  testWidgets('Toast 普通、警告和错误主题均展示对应文案', (WidgetTester tester) async {
    await tester.pumpWidget(buildCoreTestApp(home: const Scaffold()));
    await tester.pump();

    for (final void Function(String) show in <void Function(String)>[
      ToastUtil.show,
      ToastUtil.warning,
      ToastUtil.error,
    ]) {
      show('通知内容');
      await tester.pumpAndSettle();
      expect(find.text('通知内容'), findsOneWidget);
      ToastUtil.hide();
      await tester.pumpAndSettle();
    }
  });

  testWidgets('Toast 点击通知后主动关闭', (WidgetTester tester) async {
    await tester.pumpWidget(buildCoreTestApp(home: const Scaffold()));

    ToastUtil.show('点击关闭');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(
      () => tester
          .widget<TDNoticeBar>(find.byType(TDNoticeBar))
          .onTap
          ?.call('suffix-icon'),
      returnsNormally,
    );
    await tester.pumpAndSettle();

    expect(find.text('点击关闭'), findsNothing);
  });

  testWidgets('公共反馈支持震动、复制和错误提示', (WidgetTester tester) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (MethodCall call) async => null,
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await tester.pumpWidget(buildCoreTestApp(home: const Scaffold()));

    expect(CommonUtil.vibrate, returnsNormally);
    expect(CommonUtil.exitApp, returnsNormally);
    await CommonUtil.copy('复制内容');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('复制成功'), findsOneWidget);
    ToastUtil.hide();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      CommonUtil.isSuccess(
        BaseResponse<void>(code: 500, message: '原始错误'),
        toast: true,
        dialog: true,
        msg: '统一错误',
      ),
      isFalse,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('统一错误'), findsWidgets);
    expect(find.byType(TDConfirmDialog), findsOneWidget);
    ToastUtil.hide();
    Navigator.of(tester.element(find.byType(TDConfirmDialog))).pop();
    await tester.pump(const Duration(milliseconds: 300));
  });

  testWidgets('Loading 展示遮罩加载并可关闭', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildCoreTestApp(
        home: Scaffold(
          body: TextButton(
            onPressed: LoadingDialog.show,
            child: const Text('加载'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('加载'));
    await tester.pump();
    await tester.pump();
    await tester.pump();
    expect(find.byType(TDLoading), findsOneWidget);

    LoadingDialog.hide();
    await tester.pumpAndSettle();
    expect(find.byType(TDLoading), findsNothing);
  });

  testWidgets('反馈和确认对话框展示传入文案', (WidgetTester tester) async {
    await tester.pumpWidget(buildCoreTestApp(home: const Scaffold()));

    AlertUtil.showFeedbackDialog('反馈内容', title: '反馈标题');
    await tester.pumpAndSettle();
    expect(find.text('反馈标题'), findsOneWidget);
    expect(find.text('反馈内容'), findsOneWidget);
    Navigator.of(tester.element(find.text('反馈内容'))).pop();
    await tester.pumpAndSettle();

    AlertUtil.showConfirmDialog('确认内容');
    await tester.pumpAndSettle();
    expect(find.text('提示'), findsOneWidget);
    expect(find.text('确认内容'), findsOneWidget);
  });

  testWidgets('输入对话框回传输入内容', (WidgetTester tester) async {
    await tester.pumpWidget(buildCoreTestApp(home: const Scaffold()));
    String? result;

    final Future<void> dialog = AlertUtil.showInputDialog(
      '输入内容',
      hintText: '输入提示',
      onConfirm: (String value) => result = value,
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '测试值');
    await tester.tap(find.text('确认'));
    await tester.pump();
    expect(result, '测试值');
    await tester.pump(const Duration(milliseconds: 200));
    Navigator.of(tester.element(find.text('输入内容'))).pop();
    await tester.pumpAndSettle();
    await dialog;
  });

  testWidgets('图片对话框展示标题和内容', (WidgetTester tester) async {
    await tester.pumpWidget(buildCoreTestApp(home: const Scaffold()));

    AlertUtil.showImageDialog(
      '图片内容',
      title: '图片标题',
      image: Image.asset('assets/image/logo.png'),
    );
    await tester.pumpAndSettle();
    expect(find.text('图片标题'), findsOneWidget);
    expect(find.text('图片内容'), findsOneWidget);
  });

  testWidgets('对话框默认标题与输入提示使用本地化文案', (WidgetTester tester) async {
    await tester.pumpWidget(buildCoreTestApp(home: const Scaffold()));

    AlertUtil.showFeedbackDialog('默认反馈');
    await tester.pumpAndSettle();
    expect(find.text('提示'), findsOneWidget);
    CommonUtil.closePop();
    await tester.pumpAndSettle();

    final Future<void> inputDialog = AlertUtil.showInputDialog(
      '默认输入',
      onConfirm: (_) {},
    );
    await tester.pumpAndSettle();
    expect(find.text('请输入内容'), findsOneWidget);
    Get.back<void>();
    await tester.pumpAndSettle();
    await inputDialog;

    AlertUtil.showImageDialog(
      '默认图片',
      image: Image.asset('assets/image/logo.png'),
    );
    await tester.pumpAndSettle();
    expect(find.text('提示'), findsOneWidget);
  });
}
