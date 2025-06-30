import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:td_flutter_getx_template/application.dart';
import 'package:td_flutter_getx_template/core/base/base/base_logic.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../res/json_res.dart';
import '../models/demo_item.dart';
import '../states/theme_demo_state.dart';

class ThemeDemoLogic extends BaseLogic {
  final ThemeDemoState themeDemoState = ThemeDemoState();

  @override
  void onInit() {
    super.onInit();
    _initThemeDemoItems();
  }

  /// 初始化主题Demo项目数据
  void _initThemeDemoItems() {
    themeDemoState.themeDemoItems = [
      DemoItem(
        title: '绿色主题',
        description: '切换应用为绿色主题风格',
        icon: TDIcons.palette,
        onTap: () => _switchTheme(JsonRes.green, 'green'),
      ),
      DemoItem(
        title: '红色主题',
        description: '切换应用为红色主题风格',
        icon: TDIcons.palette,
        onTap: () => _switchTheme(JsonRes.red, 'red'),
      ),
      DemoItem(
        title: '蓝色主题',
        description: '切换应用为蓝色主题风格',
        icon: TDIcons.palette,
        onTap: () => _switchTheme(JsonRes.blue, 'blue'),
      ),
      DemoItem(
        title: '默认主题',
        description: '恢复应用默认主题风格',
        icon: TDIcons.palette,
        onTap: () => _switchTheme(JsonRes.theme, 'theme'),
      ),
    ];
  }

  /// 通用主题切换方法
  /// [assetPath] 主题配置文件路径
  /// [themeKey] 主题JSON中的key
  Future<void> _switchTheme(String assetPath, String themeKey) async {
    final jsonString = await rootBundle.loadString(assetPath);
    final theme = TDThemeData.fromJson(themeKey, jsonString);
    
    if (theme != null) {
      Application.updateTheme(theme);
      await Future.delayed(const Duration(milliseconds: 50));
      Get.forceAppUpdate();
    }
  }
} 