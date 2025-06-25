import 'package:alice/alice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:td_flutter_getx_template/res/json_res.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'core/util/storage/storage_util.dart';

class Application {
  /// 主题
  static late TDThemeData themeData;

  /// Alice 网络请求调试工具
  static late Alice alice;

  /// 页面初始化
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    /// 系统UI样式配置
    setSystemUIOverlayStyle();

    /// 初始化全局存储
    await StorageUtil.init();

    /// 仅在调试模式下初始化 Alice
    initAlice();

    /// 设置主题
    await setTheme();

    /// 通知需要更新
    return Future.value();
  }

  ///设置系统ui样式
  static setSystemUIOverlayStyle() {
    // 设置导航栏颜色
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        // 导航栏背景色
        statusBarColor: Colors.transparent,
        // 导航栏颜色
        statusBarIconBrightness: Brightness.dark,
        // 适配安卓小横条
        systemNavigationBarColor: Colors.transparent,
      ),
    );
  }

  /// 设置主题样式
  static setTheme() async {
    // 主题配置
    TDTheme.needMultiTheme();
    var jsonString = await rootBundle.loadString(JsonRes.theme);
    themeData = TDThemeData.fromJson('theme', jsonString)!;
  }

  /// 初始化 Alice
  static initAlice() {
    // 仅在调试模式下初始化 Alice
    if (kDebugMode) {
      alice = Alice();
      alice.setNavigatorKey(Get.key);
    }
  }
}
