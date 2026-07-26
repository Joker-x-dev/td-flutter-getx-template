import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/localization/app_translations.dart';
import 'package:flutter_kit/core/localization/common/common_en.dart';
import 'package:flutter_kit/core/localization/common/common_zh.dart';
import 'package:flutter_kit/core/localization/network/network_en.dart';
import 'package:flutter_kit/core/localization/network/network_zh.dart';

/// Core 中英文国际化资源完整性测试。
void main() {
  test('通用和网络中英文键集合完全一致', () {
    expect(commonZh.keys.toSet(), commonEn.keys.toSet());
    expect(networkZh.keys.toSet(), networkEn.keys.toSet());
  });

  test('中英文对应文案的占位符集合一致', () {
    final Map<String, String> zh = <String, String>{...commonZh, ...networkZh};
    final Map<String, String> en = <String, String>{...commonEn, ...networkEn};

    for (final String key in zh.keys) {
      expect(
        _placeholders(zh[key]!),
        _placeholders(en[key]!),
        reason: '国际化键 $key 的占位符不一致',
      );
    }
  });

  test('翻译聚合包含 Core 文案且两种语言键集合一致', () {
    final Map<String, Map<String, String>> keys = AppTranslations().keys;

    expect(keys.keys, containsAll(<String>['zh_CN', 'en_US']));
    expect(keys['zh_CN']!.keys.toSet(), keys['en_US']!.keys.toSet());
    for (final MapEntry<String, String> entry in commonZh.entries) {
      expect(keys['zh_CN']![entry.key], entry.value);
    }
    for (final MapEntry<String, String> entry in networkEn.entries) {
      expect(keys['en_US']![entry.key], entry.value);
    }
  });
}

/// 提取文案中的格式化占位符。
Set<String> _placeholders(String value) {
  return RegExp(r'%[A-Za-z]').allMatches(value).map((Match match) {
    return match.group(0)!;
  }).toSet();
}
