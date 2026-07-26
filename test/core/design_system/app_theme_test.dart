import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:flutter_kit/core/design_system/theme/app_theme.dart';
import 'package:flutter_kit/core/design_system/theme/theme_color_preset.dart';

/// 应用主题映射、插值、预设与系统栏语义测试。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('主题预设按名称查找并对空值和无效名称回退', () {
    expect(ThemeColorPreset.fromName('green'), same(ThemeColorPreset.green));
    expect(
      ThemeColorPreset.fromName(null),
      same(ThemeColorPreset.defaultTheme),
    );
    expect(
      ThemeColorPreset.fromName('missing'),
      same(ThemeColorPreset.defaultTheme),
    );
    expect(ThemeColorPreset.values, hasLength(4));
  });

  test('主题预设可从真实 JSON 资源加载明暗主题', () async {
    final TDThemeData? theme = await ThemeColorPreset.defaultTheme
        .loadThemeData();

    expect(theme, isNotNull);
    expect(theme!.dark, isNotNull);
  });

  test('Material 浅深色主题映射品牌色、背景、图标和扩展', () {
    final TDThemeData source = TDThemeData.defaultData();

    for (final Brightness brightness in Brightness.values) {
      final TDThemeData active = brightness == Brightness.dark
          ? source.dark ?? source.light
          : source.light;
      final ThemeData theme = AppTheme.buildMaterialTheme(active, brightness);

      expect(theme.brightness, brightness);
      expect(theme.colorScheme.primary, active.brandNormalColor);
      expect(theme.scaffoldBackgroundColor, active.bgColorPage);
      expect(theme.iconTheme.color, active.textColorPrimary);
      expect(theme.extension<TDThemeData>(), same(active));
      expect(theme.extension<AppTheme>()!.tdTheme, same(active));
    }
  });

  test('系统栏样式按亮度设置图标和容器背景', () {
    final TDThemeData theme = TDThemeData.defaultData().light;
    final SystemUiOverlayStyle light = AppTheme.buildSystemUiOverlayStyle(
      theme,
      Brightness.light,
    );
    final SystemUiOverlayStyle dark = AppTheme.buildSystemUiOverlayStyle(
      theme,
      Brightness.dark,
    );

    expect(light.statusBarColor, Colors.transparent);
    expect(light.statusBarIconBrightness, Brightness.dark);
    expect(dark.statusBarIconBrightness, Brightness.light);
    expect(light.systemNavigationBarColor, theme.bgColorContainer);
    expect(light.systemNavigationBarContrastEnforced, isFalse);
  });

  test('AppTheme 从 TDesign 映射全部语义并支持复制与插值', () {
    final TDThemeData source = TDThemeData.defaultData().light;
    final AppTheme theme = AppTheme.fromTdTheme(source);
    final AppTheme copied = theme.copyWith(primary: Colors.purple) as AppTheme;
    final AppTheme interpolated = theme.lerp(copied, 0.5) as AppTheme;

    expect(theme.primary, source.brandColor7);
    expect(theme.success, source.successColor5);
    expect(theme.warning, source.warningColor5);
    expect(theme.error, source.errorColor6);
    expect(theme.backgroundPage, source.bgColorPage);
    expect(theme.textPrimary, source.textColorPrimary);
    expect(theme.borderLevel1, source.componentStrokeColor);
    expect(theme.fontBodyMedium, source.fontBodyMedium);
    expect(theme.fontWeightBold, FontWeight.w600);
    expect(copied.primary, Colors.purple);
    expect(copied.error, theme.error);
    expect(interpolated.primary, Color.lerp(theme.primary, Colors.purple, 0.5));
  });

  test('AppTheme 字体插值在中点前后选择对应主题值', () {
    final AppTheme theme = AppTheme.fromTdTheme(
      TDThemeData.defaultData().light,
    );
    final AppTheme alternate =
        theme.copyWith(
              fontHeadlineMedium: theme.fontBodySmall,
              fontTitleExtraLarge: theme.fontBodySmall,
              fontBodyExtraLarge: theme.fontBodySmall,
              fontBodyExtraSmall: theme.fontBodyLarge,
              fontMarkExtraSmall: theme.fontBodyLarge,
            )
            as AppTheme;

    final AppTheme early = theme.lerp(alternate, 0.25) as AppTheme;
    final AppTheme late = theme.lerp(alternate, 0.75) as AppTheme;

    expect(early.fontHeadlineMedium, same(theme.fontHeadlineMedium));
    expect(early.fontTitleExtraLarge, same(theme.fontTitleExtraLarge));
    expect(early.fontBodyExtraLarge, same(theme.fontBodyExtraLarge));
    expect(early.fontBodyExtraSmall, same(theme.fontBodyExtraSmall));
    expect(early.fontMarkExtraSmall, same(theme.fontMarkExtraSmall));
    expect(late.fontHeadlineMedium, same(alternate.fontHeadlineMedium));
    expect(late.fontTitleExtraLarge, same(alternate.fontTitleExtraLarge));
    expect(late.fontBodyExtraLarge, same(alternate.fontBodyExtraLarge));
    expect(late.fontBodyExtraSmall, same(alternate.fontBodyExtraSmall));
    expect(late.fontMarkExtraSmall, same(alternate.fontMarkExtraSmall));
  });
}
