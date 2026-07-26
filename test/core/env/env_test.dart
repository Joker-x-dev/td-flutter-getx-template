import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/env/env.dart';
import 'package:flutter_kit/core/env/env_dev.dart';
import 'package:flutter_kit/core/env/env_pre.dart';
import 'package:flutter_kit/core/env/env_prod.dart';
import 'package:flutter_kit/core/env/env_test.dart';

/// 默认构建环境配置测试。
void main() {
  test('调试构建默认使用开发环境域名和环境标志', () {
    expect(Env.flavor, Env.dev);
    expect(Env.baseUrl, EnvDev.baseUrl);
    expect(Env.isDev, isTrue);
    expect(Env.isTest, isFalse);
    expect(Env.isPre, isFalse);
    expect(Env.isProd, isFalse);
    expect(Env.isNotProduction, isTrue);
  });

  test('按环境标识解析全部域名并拒绝未知环境', () {
    expect(Env.baseUrlForFlavor(Env.dev), EnvDev.baseUrl);
    expect(Env.baseUrlForFlavor(Env.test), EnvTest.baseUrl);
    expect(Env.baseUrlForFlavor(Env.pre), EnvPre.baseUrl);
    expect(Env.baseUrlForFlavor(Env.prod), EnvProd.baseUrl);
    expect(() => Env.baseUrlForFlavor('unknown'), throwsA(isA<StateError>()));
  });
}
