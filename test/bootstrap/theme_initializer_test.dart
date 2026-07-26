import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/application.dart';
import 'package:flutter_kit/bootstrap/theme_initializer.dart';
import 'package:flutter_kit/core/data/repository/theme_store_repository.dart';

import '../support/test_environment.dart';

/// 启动阶段主题颜色和深浅模式恢复测试。
void main() {
  setUp(() async {
    await initializeCoreTestEnvironment();
    Application.themeColorName.value = 'theme';
    Application.themeMode.value = ThemeMode.system;
  });

  tearDown(() async {
    Application.themeColorName.value = 'theme';
    Application.themeMode.value = ThemeMode.system;
    await resetCoreTestEnvironment();
  });

  test('恢复已保存的主题颜色和深色模式', () async {
    final ThemeStoreRepository repository = ThemeStoreRepository();
    await repository.saveThemeColorName('green');
    await repository.saveThemeModeIndex(ThemeMode.dark.index);

    await ThemeInitializer().init();

    expect(Application.themeColorName.value, 'green');
    expect(Application.themeMode.value, ThemeMode.dark);
    expect(Application.themeData.value.dark, isNotNull);
  });

  test('无保存值时使用默认主题和系统模式', () async {
    await ThemeInitializer().init();

    expect(Application.themeColorName.value, 'theme');
    expect(Application.themeMode.value, ThemeMode.system);
  });

  test('无效主题名称和模式索引安全回退', () async {
    final ThemeStoreRepository repository = ThemeStoreRepository();
    await repository.saveThemeColorName('missing');
    await repository.saveThemeModeIndex(99);
    Application.themeMode.value = ThemeMode.light;

    await ThemeInitializer().init();

    expect(Application.themeColorName.value, 'theme');
    expect(Application.themeMode.value, ThemeMode.light);
  });
}
