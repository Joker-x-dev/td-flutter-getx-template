import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_kit/routes/app_pages.dart';
import 'package:flutter_kit/routes/main/main_routes.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'application.dart';
import 'core/design_system/theme/app_theme.dart';
import 'core/localization/app_translations.dart';

/// 应用入口
void main() => Application.init().then((value) => runApp(const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// 屏幕适配
    return ScreenUtilInit(
      splitScreenMode: true,
      minTextAdapt: true,
      // 适配尺寸，设计稿尺寸
      designSize: const Size(375, 812),
      builder: (context, child) {
        return Obx(() {
          /// 主题配置 - 响应式获取
          final TDThemeData themeData = Application.themeData.value;
          final themeMode = Application.themeMode.value;
          final locale = Application.locale.value;

          /// 浅色主题数据
          final lightTheme = themeData.light;

          /// 深色主题数据；未配置时回退到浅色主题
          final darkTheme = themeData.dark ?? lightTheme;

          /// 当前是否为深色模式
          final isDark =
              themeMode == ThemeMode.dark ||
              (themeMode == ThemeMode.system &&
                  MediaQuery.platformBrightnessOf(context) == Brightness.dark);
          final activeBrightness = isDark ? Brightness.dark : Brightness.light;
          final activeTheme = isDark ? darkTheme : lightTheme;

          return AnnotatedRegion<SystemUiOverlayStyle>(
            // 系统状态栏与导航栏颜色跟随当前主题语义色
            value: AppTheme.buildSystemUiOverlayStyle(
              activeTheme,
              activeBrightness,
            ),
            child: GetMaterialApp(
              // 平台原生转场支持 Android 预测性返回与 iOS 页面手势
              defaultTransition: Transition.native,
              // debug 模式下是否显示 Banner
              debugShowCheckedModeBanner: false,
              // 国际化配置
              translations: AppTranslations(),
              locale: locale,
              fallbackLocale: const Locale('zh', 'CN'),
              initialRoute: MainRoutes.main,
              theme: AppTheme.buildMaterialTheme(lightTheme, Brightness.light),
              darkTheme: AppTheme.buildMaterialTheme(
                darkTheme,
                Brightness.dark,
              ),
              themeMode: themeMode,
              builder: BotToastInit(),
              navigatorObservers: [BotToastNavigatorObserver()],
              getPages: AppPages.routes,
            ),
          );
        });
      },
    );
  }
}
