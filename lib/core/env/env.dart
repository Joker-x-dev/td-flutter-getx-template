import 'package:flutter/foundation.dart';

import 'env_dev.dart';
import 'env_pre.dart';
import 'env_prod.dart';
import 'env_test.dart';

/// 环境配置管理
///
/// 环境参数直接通过 [EnvDev]、[EnvTest]、[EnvPre]、[EnvProd] 维护，
/// 当前环境由构建命令通过 `--dart-define=ENV=xxx` 注入。
abstract final class Env {
  /// 禁止实例化环境配置管理类
  Env._();

  /// 开发环境标识
  static const String dev = 'dev';

  /// 测试环境标识
  static const String test = 'test';

  /// 预生产环境标识
  static const String pre = 'pre';

  /// 生产环境标识
  static const String prod = 'prod';

  /// 当前构建模式
  ///
  /// 通过 `flutter run --dart-define=ENV=prod` 或 IDE 启动配置注入，
  /// Release 构建默认使用 [EnvProd.flavor]，其他构建默认使用 [EnvDev.flavor]。
  static const String flavor = String.fromEnvironment(
    'ENV',
    defaultValue: kReleaseMode ? EnvProd.flavor : EnvDev.flavor,
  );

  /// 当前环境的基础域名
  static String get baseUrl => baseUrlForFlavor(flavor);

  /// 获取指定环境的基础域名
  ///
  /// [flavor] 环境标识。
  ///
  /// 返回环境对应的基础域名。
  @visibleForTesting
  static String baseUrlForFlavor(String flavor) {
    return switch (flavor) {
      EnvProd.flavor => EnvProd.baseUrl,
      EnvPre.flavor => EnvPre.baseUrl,
      EnvTest.flavor => EnvTest.baseUrl,
      EnvDev.flavor => EnvDev.baseUrl,
      _ => throw StateError('不支持的环境标识: $flavor'),
    };
  }

  /// 是否开发环境
  static bool get isDev => flavor == dev;

  /// 是否测试环境
  static bool get isTest => flavor == test;

  /// 是否预生产环境
  static bool get isPre => flavor == pre;

  /// 是否生产环境
  static bool get isProd => flavor == prod;

  /// 是否不是正式环境
  static bool get isNotProduction => !isProd;
}
