import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/model/response/base/base_response.dart';
import 'package:flutter_kit/core/util/common/common_util.dart';
import 'package:flutter_kit/core/util/storage/storage_util.dart';
import 'package:flutter_kit/core/util/toast/toast_util.dart';

import '../../support/test_environment.dart';

/// StorageUtil 与 CommonUtil 正常值和边界值测试。
void main() {
  setUp(initializeCoreTestEnvironment);
  tearDown(resetCoreTestEnvironment);

  group('StorageUtil', () {
    test('基础类型支持读写、默认值和删除', () async {
      expect(
        StorageUtil.getString('string', defaultValue: 'default'),
        'default',
      );
      expect(StorageUtil.getBool('bool', defaultValue: true), isTrue);
      expect(StorageUtil.getDouble('double', defaultValue: 1.5), 1.5);
      expect(StorageUtil.getInt('int', defaultValue: 2), 2);

      await StorageUtil.setString('string', 'value');
      await StorageUtil.setBool('bool', false);
      await StorageUtil.setDouble('double', 2.5);
      await StorageUtil.setInt('int', 3);

      expect(StorageUtil.getString('string'), 'value');
      expect(StorageUtil.getBool('bool'), isFalse);
      expect(StorageUtil.getDouble('double'), 2.5);
      expect(StorageUtil.getInt('int'), 3);
      expect(await StorageUtil.delete('string'), isTrue);
      expect(StorageUtil.getString('string'), isEmpty);
    });

    test('对象和列表支持 JSON 往返及空值回退', () async {
      expect(StorageUtil.getObject('object'), isEmpty);
      expect(StorageUtil.getListObject('list'), isEmpty);

      await StorageUtil.setObject('object', <String, Object>{'id': 1});
      await StorageUtil.setListObject('list', <Object>[1, 'two']);

      expect(StorageUtil.getObject('object'), <String, Object>{'id': 1});
      expect(StorageUtil.getListObject('list'), <Object>[1, 'two']);
    });

    test('损坏 JSON 和类型不匹配保持解析异常', () async {
      await StorageUtil.setString('broken', '{');
      await StorageUtil.setString('wrongObject', '[]');
      await StorageUtil.setString('wrongList', '{}');

      expect(() => StorageUtil.getObject('broken'), throwsFormatException);
      expect(
        () => StorageUtil.getObject('wrongObject'),
        throwsA(isA<TypeError>()),
      );
      expect(
        () => StorageUtil.getListObject('wrongList'),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('CommonUtil', () {
    test('成功和错误响应判断互为相反结果', () {
      final BaseResponse<void> success = BaseResponse<void>();
      final BaseResponse<void> failure = BaseResponse<void>(
        code: 400,
        message: '失败',
      );

      expect(CommonUtil.isSuccess(success), isTrue);
      expect(CommonUtil.isError(success), isFalse);
      expect(CommonUtil.isSuccess(failure), isFalse);
      expect(CommonUtil.isError(failure), isTrue);
      expect(CommonUtil.isSuccess(null), isFalse);
    });

    test('空值判断覆盖字符串和各类集合', () {
      final List<Object?> blankValues = <Object?>[
        null,
        '',
        '  ',
        <Object>[],
        <Object>{},
        <String, Object>{},
      ];

      for (final Object? value in blankValues) {
        expect(CommonUtil.isBlank(value), isTrue, reason: '$value 应为空值');
        expect(CommonUtil.isNotBlank(value), isFalse);
      }
      expect(CommonUtil.isBlank('value'), isFalse);
      expect(CommonUtil.isBlank(<int>[1]), isFalse);
      expect(CommonUtil.isNull(null), isTrue);
      expect(CommonUtil.isNotNull(0), isTrue);
    });

    test('平台判断与当前测试运行平台一致', () {
      expect(CommonUtil.isAndroid(), isFalse);
      expect(CommonUtil.isIos(), isFalse);
    });

    testWidgets('剪贴板异常被吸收且不向调用方传播', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildCoreTestApp(home: const Scaffold(body: SizedBox())),
      );
      final TestDefaultBinaryMessenger messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(SystemChannels.platform, (
        MethodCall methodCall,
      ) async {
        if (methodCall.method == 'Clipboard.setData') {
          throw PlatformException(code: 'clipboard-failed');
        }
        return null;
      });
      addTearDown(() {
        messenger.setMockMethodCallHandler(SystemChannels.platform, null);
      });

      await expectLater(CommonUtil.copy('内容'), completes);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
      expect(find.text('复制失败'), findsOneWidget);
      ToastUtil.hide();
      await tester.pump(const Duration(milliseconds: 300));
    });
  });
}
