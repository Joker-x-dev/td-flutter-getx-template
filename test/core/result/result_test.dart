import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' hide ErrorFormatter;
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:flutter_kit/core/config/app_config.dart';
import 'package:flutter_kit/core/model/response/base/base_response.dart';
import 'package:flutter_kit/core/result/error_formatter.dart';
import 'package:flutter_kit/core/result/request_helper.dart';

import '../../support/test_environment.dart';

/// ErrorFormatter 与 RequestHelper 请求生命周期测试。
void main() {
  setUpAll(initializeCoreTestEnvironment);
  tearDownAll(resetCoreTestEnvironment);

  group('ErrorFormatter', () {
    test('识别网络、超时和未知异常', () {
      expect(
        ErrorFormatter.formatError(Exception('SocketException: offline')),
        contains('网络'),
      );
      expect(
        ErrorFormatter.formatError(TimeoutException('timeout')),
        contains('超时'),
      );
      expect(
        ErrorFormatter.formatError(Exception('unknown failure')),
        contains('unknown failure'),
      );
    });

    test('解析错误提取实体和类型不匹配信息', () {
      final String message = ErrorFormatter.formatError(
        Exception("_\$GoodsFromJson: 'String' is not a subtype of type 'int'"),
      );

      expect(message, contains('Goods'));
      expect(message, contains('int'));
      expect(message, contains('String'));
    });

    test('未知异常内容限制最大展示长度', () {
      final String message = ErrorFormatter.formatError(
        Exception(List<String>.filled(150, 'x').join()),
      );

      expect(message.length, lessThan(150));
      expect(message, contains('...'));
    });

    test('识别服务器异常和 fromJson 解析异常', () {
      expect(
        ErrorFormatter.formatError(Exception('HttpException: status code 503')),
        contains('503'),
      );
      expect(
        ErrorFormatter.formatError(
          Exception('Unhandled Exception: Goods.fromJson failed'),
        ),
        contains('解析'),
      );
    });
  });

  group('RequestHelper', () {
    test('execute 返回成功响应数据', () async {
      final int? result = await RequestHelper.repository<int>(
        Future<BaseResponse<int>>.value(BaseResponse<int>(data: 42)),
      ).execute();

      expect(result, 42);
    });

    test('response 返回完整响应', () async {
      final BaseResponse<int> source = BaseResponse<int>(
        data: 7,
        message: 'ok',
      );

      final BaseResponse<int> result = await RequestHelper.repository<int>(
        Future<BaseResponse<int>>.value(source),
      ).response();

      expect(result, same(source));
    });

    test('业务失败触发错误回调并使用服务端文案', () async {
      String? capturedMessage;
      dynamic capturedError;
      final RequestHelper<int> helper =
          RequestHelper.repository<int>(
            Future<BaseResponse<int>>.value(
              BaseResponse<int>(code: 400, message: '业务失败'),
            ),
          ).error((String message, dynamic error) {
            capturedMessage = message;
            capturedError = error;
          });

      await expectLater(helper.execute(), throwsA(isA<Error>()));
      expect(capturedMessage, '业务失败');
      expect(capturedError, isNull);
    });

    test('自定义错误文案覆盖业务响应文案', () async {
      String? capturedMessage;
      final RequestHelper<int> helper =
          RequestHelper.repository<int>(
            Future<BaseResponse<int>>.value(
              BaseResponse<int>(code: 400, message: '服务端文案'),
            ),
          ).errorMsg('自定义文案').error((String message, dynamic error) {
            capturedMessage = message;
          });

      await expectLater(helper.execute(), throwsA(isA<Error>()));
      expect(capturedMessage, '自定义文案');
    });

    test('请求异常格式化后回调并保留原始异常', () async {
      dynamic capturedError;
      final Exception source = Exception('network broken');
      final RequestHelper<int> helper =
          RequestHelper.repository<int>(
            Future<BaseResponse<int>>.error(source),
          ).error((String message, dynamic error) {
            capturedError = error;
          });

      await expectLater(
        helper.execute(),
        throwsA(
          predicate<Object>((Object error) {
            return error.toString().contains('network broken');
          }),
        ),
      );
      expect(capturedError, same(source));
    });

    test('类型错误同样触发格式化与原始错误回调', () async {
      late final Object source;
      try {
        final dynamic value = '错误类型';
        value as int;
      } on Object catch (error) {
        source = error;
      }
      dynamic capturedError;
      String? capturedMessage;
      final RequestHelper<int> helper =
          RequestHelper.repository<int>(
            Future<BaseResponse<int>>.error(source),
          ).error((String message, dynamic error) {
            capturedMessage = message;
            capturedError = error;
          });

      await expectLater(helper.execute(), throwsA(isA<Exception>()));
      expect(capturedError, same(source));
      expect(capturedMessage, contains('解析'));
    });

    test('链式可空配置允许显式清除且恢复服务端错误文案', () async {
      bool started = false;
      bool clearedErrorCallbackCalled = false;
      String? capturedMessage;
      final RequestHelper<int> helper =
          RequestHelper.repository<int>(
                Future<BaseResponse<int>>.value(
                  BaseResponse<int>(code: 400, message: '服务端错误'),
                ),
              )
              .start(() => started = true)
              .start(null)
              .error((String message, dynamic error) {
                clearedErrorCallbackCalled = true;
              })
              .error(null)
              .errorMsg('覆盖文案')
              .errorMsg(null)
              .error((String message, dynamic error) {
                capturedMessage = message;
              });

      await expectLater(helper.execute(), throwsA(isA<Error>()));
      expect(started, isFalse);
      expect(clearedErrorCallbackCalled, isFalse);
      expect(capturedMessage, '服务端错误');
    });

    test('start 在异步请求完成前执行且链式配置不可变', () async {
      final Completer<BaseResponse<int>> completer =
          Completer<BaseResponse<int>>();
      bool started = false;
      final RequestHelper<int> source = RequestHelper.repository<int>(
        completer.future,
      );
      final RequestHelper<int> configured = source.start(() {
        started = true;
      });

      final Future<int?> future = configured.execute();
      expect(started, isTrue);
      expect(configured, isNot(same(source)));
      completer.complete(
        BaseResponse<int>(data: 1, code: AppConfig.successCode),
      );
      expect(await future, 1);
    });

    testWidgets('loading 在请求期间展示并在成功后关闭', (WidgetTester tester) async {
      await tester.pumpWidget(buildCoreTestApp(home: const Scaffold()));
      final Completer<BaseResponse<int>> completer =
          Completer<BaseResponse<int>>();
      final Future<int?> future = RequestHelper.repository<int>(
        completer.future,
      ).loading(true).execute();

      await tester.pump();
      await tester.pump();
      expect(find.byType(TDLoading), findsOneWidget);

      completer.complete(BaseResponse<int>(data: 9));
      expect(await future, 9);
      await tester.pumpAndSettle();
      expect(find.byType(TDLoading), findsNothing);
    });

    testWidgets('loading 在类型错误后仍关闭并执行 finally 清理', (WidgetTester tester) async {
      await tester.pumpWidget(buildCoreTestApp(home: const Scaffold()));
      final Completer<BaseResponse<int>> completer =
          Completer<BaseResponse<int>>();
      final StateError source = StateError('请求状态错误');
      dynamic capturedError;
      final Future<int?> future =
          RequestHelper.repository<int>(completer.future).loading(true).error((
            String message,
            dynamic error,
          ) {
            capturedError = error;
          }).execute();

      await tester.pump();
      await tester.pump();
      expect(find.byType(TDLoading), findsOneWidget);

      completer.completeError(source, StackTrace.current);
      await expectLater(future, throwsA(isA<Exception>()));
      await tester.pumpAndSettle();
      expect(capturedError, same(source));
      expect(find.byType(TDLoading), findsNothing);
    });

    testWidgets('业务失败按配置展示 Toast 和 Dialog', (WidgetTester tester) async {
      await tester.pumpWidget(buildCoreTestApp(home: const Scaffold()));
      final Future<int?> future = RequestHelper.repository<int>(
        Future<BaseResponse<int>>.value(
          BaseResponse<int>(code: 500, message: '提交失败'),
        ),
      ).toast(true).dialog(true).execute();

      await expectLater(future, throwsA(isA<Error>()));
      await tester.pumpAndSettle();
      expect(find.text('提交失败'), findsWidgets);
      expect(find.byType(TDNoticeBar), findsOneWidget);
      expect(find.byType(TDConfirmDialog), findsOneWidget);
    });
  });
}
