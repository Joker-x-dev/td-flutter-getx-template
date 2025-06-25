import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:td_flutter_getx_template/routes/app_pages.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'application.dart';

/// 应用入口
void main() => Application.init().then((value) => runApp(const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// 主题配置
    final themeData = Application.themeData;

    /// 屏幕适配
    return ScreenUtilInit(
      splitScreenMode: true,
      minTextAdapt: true,
      // 适配尺寸，设计稿尺寸
      designSize: const Size(375, 812),
      builder: (context, child) {
        return GetMaterialApp(
          // 页面切换动画
          defaultTransition: Transition.rightToLeft,
          // debug 模式下是否显示 Banner
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.MAIN,
          locale: const Locale('zh', 'CN'),
          theme: ThemeData(
            extensions: [themeData],
            colorScheme: ColorScheme.light(primary: themeData.brandNormalColor),
          ),
          builder: BotToastInit(),
          navigatorObservers: [BotToastNavigatorObserver()],
          getPages: AppPages.routes,
        );
      },
    );
  }
}
