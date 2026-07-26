import 'package:flutter/material.dart';
import 'package:flutter_kit/application.dart';
import 'package:flutter_kit/core/base/base/base_logic.dart';
import 'package:flutter_kit/core/design_system/theme/theme_color_preset.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../states/theme_demo_state.dart';

/// 语言与主题设置页 Logic
class ThemeDemoLogic extends BaseLogic {
  /// 创建语言与主题设置页 Logic。
  ///
  /// [themeDataLoader] 主题配置加载器，默认读取预设资源。
  ThemeDemoLogic({ThemeDemoDataLoader? themeDataLoader})
    : _themeDataLoader = themeDataLoader ?? _loadPresetThemeData;

  /// 主题配置加载器。
  final ThemeDemoDataLoader _themeDataLoader;

  /// 页面状态
  final ThemeDemoState themeDemoState = ThemeDemoState();

  /// 切换中文与英文
  Future<void> toggleLocale() async {
    final currentLocale = Application.locale.value;
    final nextLocale = currentLocale.languageCode == 'zh'
        ? const Locale('en', 'US')
        : const Locale('zh', 'CN');
    await Application.updateLocale(nextLocale);
  }

  /// 更新跟随系统状态
  ///
  /// [isOn] 是否跟随系统。
  /// [systemBrightness] 当前系统明暗模式。
  Future<void> updateFollowSystem(
    bool isOn,
    Brightness systemBrightness,
  ) async {
    final mode = isOn
        ? ThemeMode.system
        : systemBrightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light;
    await Application.updateThemeMode(mode);
  }

  /// 更新应用深浅模式
  ///
  /// [mode] 目标主题模式。
  Future<void> updateThemeMode(ThemeMode mode) async {
    await Application.updateThemeMode(mode);
  }

  /// 更新应用主题颜色
  ///
  /// [preset] 目标主题颜色预设。
  Future<void> updateThemeColor(ThemeColorPreset preset) async {
    try {
      final themeData = await _themeDataLoader(preset);
      if (themeData == null) {
        return;
      }
      await Application.updateThemeColor(themeData, preset.name);
    } on Object {
      return;
    }
  }

  /// 从预设资源加载主题配置。
  ///
  /// [preset] 主题颜色预设。
  ///
  /// 返回解析后的主题配置，资源无效时返回 `null`。
  static Future<TDThemeData?> _loadPresetThemeData(ThemeColorPreset preset) =>
      preset.loadThemeData();
}

/// Demo 主题配置加载器。
///
/// [preset] 主题颜色预设。
///
/// 返回解析后的主题配置，资源无效时返回 `null`。
typedef ThemeDemoDataLoader =
    Future<TDThemeData?> Function(ThemeColorPreset preset);
