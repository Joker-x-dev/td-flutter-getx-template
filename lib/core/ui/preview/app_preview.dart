import "package:flutter/material.dart";
import "package:flutter/widget_previews.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:flutter_kit/core/design_system/extensions/extensions.dart";
import "package:tdesign_flutter/tdesign_flutter.dart";

import "../../design_system/theme/app_theme.dart";
import "../../design_system/theme/size.dart";
import "../../localization/app_translations.dart";

/// Widget Preview 公共支持
///
/// 为组件和页面预览提供应用主题、国际化、屏幕适配与 GetX 依赖环境。
///
/// 返回包含 TDesign 与应用语义色扩展的明暗主题配置。
PreviewThemeData buildAppPreviewTheme() {
  final TDThemeData themeData = TDThemeData.defaultData();
  final TDThemeData lightTheme = themeData.light;
  final TDThemeData darkTheme = themeData.dark ?? lightTheme;

  return PreviewThemeData(
    materialLight: AppTheme.buildMaterialTheme(lightTheme, Brightness.light),
    materialDark: AppTheme.buildMaterialTheme(darkTheme, Brightness.dark),
  );
}

/// 包装应用组件预览
///
/// [child] 需要预览的组件。
///
/// 返回包含屏幕适配、背景和标准边距的组件预览。
Widget wrapAppComponentPreview(Widget child) {
  return AppPreviewScope(
    child: Builder(
      builder: (BuildContext context) {
        final ThemeData theme = Theme.of(context);
        return _buildPreviewApp(
          theme,
          home: Builder(
            builder: (BuildContext context) {
              return child
                  .padAll(spacePaddingLarge)
                  .center()
                  .backgroundColor(Theme.of(context).scaffoldBackgroundColor);
            },
          ),
        );
      },
    ),
  );
}

/// 包装应用页面预览
///
/// [child] 需要预览的页面。
///
/// 返回包含屏幕适配和 GetX 翻译数据的页面预览。
Widget wrapAppScreenPreview(Widget child) {
  return AppPreviewScope(
    child: Builder(
      builder: (BuildContext context) {
        final ThemeData theme = Theme.of(context);
        return _buildPreviewApp(theme, home: child);
      },
    ),
  );
}

/// 构建应用预览容器
///
/// [theme] 当前预览主题。
/// [home] 预览首页内容。
///
/// 返回包含 GetX 路由与国际化环境的应用容器。
Widget _buildPreviewApp(ThemeData theme, {required Widget home}) {
  return GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: theme,
    darkTheme: theme,
    themeMode: ThemeMode.system,
    translations: AppTranslations(),
    locale: const Locale("zh", "CN"),
    fallbackLocale: const Locale("zh", "CN"),
    home: home,
  );
}

/// 应用预览作用域
///
/// 使用 Widget Preview 提供的 [MediaQuery] 初始化 ScreenUtil，
/// 并注册页面文案所需的 GetX 翻译数据。
class AppPreviewScope extends StatefulWidget {
  /// 创建应用预览作用域
  ///
  /// [key] 组件标识。
  /// [child] 预览内容。
  const AppPreviewScope({super.key, required this.child});

  /// 预览内容
  final Widget child;

  /// 创建应用预览作用域状态
  @override
  State<AppPreviewScope> createState() => _AppPreviewScopeState();
}

/// 应用预览作用域状态
class _AppPreviewScopeState extends State<AppPreviewScope> {
  /// 项目主题数据加载任务
  Future<TDThemeData>? _themeDataFuture;

  /// 初始化项目预览主题
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeDataFuture ??= _loadThemeData(DefaultAssetBundle.of(context));
  }

  /// 加载项目明暗主题配置
  ///
  /// [bundle] Widget Preview 提供的项目资源包。
  ///
  /// 返回项目主题数据；解析失败时回退到 TDesign 默认主题。
  Future<TDThemeData> _loadThemeData(AssetBundle bundle) async {
    TDTheme.needMultiTheme();
    try {
      final String jsonString = await bundle.loadString(
        'assets/json/theme.json',
      );
      return TDThemeData.fromJson('theme', jsonString, darkName: 'themeDark') ??
          TDThemeData.defaultData();
    } on Object {
      return TDThemeData.defaultData();
    }
  }

  /// 构建应用预览作用域
  ///
  /// [context] 构建上下文。
  ///
  /// 返回已初始化公共预览环境的组件。
  @override
  Widget build(BuildContext context) {
    Get.addTranslations(AppTranslations().keys);
    Get.locale = const Locale("zh", "CN");
    ScreenUtil.configure(
      data: MediaQuery.of(context),
      designSize: const Size(375, 812),
      splitScreenMode: true,
      minTextAdapt: true,
    );
    final Brightness brightness = MediaQuery.platformBrightnessOf(context);

    return FutureBuilder<TDThemeData>(
      future: _themeDataFuture,
      builder: (BuildContext context, AsyncSnapshot<TDThemeData> snapshot) {
        final TDThemeData themeData =
            snapshot.data ?? TDThemeData.defaultData();
        final TDThemeData activeTheme = brightness == Brightness.dark
            ? themeData.dark ?? themeData.light
            : themeData.light;
        return Theme(
          data: AppTheme.buildMaterialTheme(activeTheme, brightness),
          child: widget.child,
        );
      },
    );
  }
}
