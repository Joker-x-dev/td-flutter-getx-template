import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:flutter_kit/core/design_system/theme/app_theme.dart';
import 'package:flutter_kit/core/localization/app_translations.dart';
import 'package:flutter_kit/core/util/storage/storage_util.dart';

/// Core 测试公共环境。

/// 初始化 GetX 翻译与测试存储。
Future<void> initializeCoreTestEnvironment() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;
  Get.locale = const Locale('zh', 'CN');
  Get.addTranslations(AppTranslations().keys);
  SharedPreferences.setMockInitialValues(<String, Object>{});
  await StorageUtil.init();
}

/// 重置 GetX 与本地存储状态。
Future<void> resetCoreTestEnvironment() async {
  if (StorageUtil.sharedPreferences.getKeys().isNotEmpty) {
    await StorageUtil.sharedPreferences.clear();
  }
  Get.reset();
  Get.testMode = true;
  Get.locale = const Locale('zh', 'CN');
  Get.addTranslations(AppTranslations().keys);
}

/// 构建包含 GetX、TDesign、国际化与 BotToast 的测试应用壳。
///
/// [home] 测试页面。
/// [routes] 可选本地命名路由。
/// [locale] 测试语言。
/// [brightness] 测试主题亮度。
Widget buildCoreTestApp({
  required Widget home,
  List<GetPage<dynamic>> routes = const <GetPage<dynamic>>[],
  Locale locale = const Locale('zh', 'CN'),
  Brightness brightness = Brightness.light,
}) {
  final TDThemeData tdTheme = TDThemeData.defaultData();
  final TDThemeData activeTheme = brightness == Brightness.dark
      ? tdTheme.dark ?? tdTheme.light
      : tdTheme.light;
  final ThemeData theme = AppTheme.buildMaterialTheme(activeTheme, brightness);

  return GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: theme,
    darkTheme: theme,
    themeMode: brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
    translations: AppTranslations(),
    locale: locale,
    fallbackLocale: const Locale('zh', 'CN'),
    getPages: routes,
    builder: BotToastInit(),
    navigatorObservers: <NavigatorObserver>[BotToastNavigatorObserver()],
    home: home,
  );
}
