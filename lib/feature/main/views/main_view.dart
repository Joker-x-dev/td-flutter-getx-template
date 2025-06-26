import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:td_flutter_getx_template/core/base/base/base_view.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../core/design_system/theme/color.dart';
import '../logics/main_logic.dart';

class MainView extends BaseView<MainLogic> {
  const MainView({super.key});

  @override
  bool get isHiddenNav => true;

  @override
  Widget body() {
    return PageView(
      physics: const BouncingScrollPhysics(),
      controller: controller.mainState.pageController,
      children: controller.pageList,
      onPageChanged: (int index) => controller.pageViewChange(index),
    );
  }

  @override
  Widget? bottom() {
    return Obx(
      () => TDBottomTabBar(
        barHeight: 60,
        TDBottomTabBarBasicType.iconText,
        currentIndex: controller.mainState.pageIndex.value,
        componentType: TDBottomTabBarComponentType.normal,
        navigationTabs: [
          tabItem('基类', TDIcons.layers, TDIcons.layers_filled, 0),
          tabItem('网络', TDIcons.internet, TDIcons.internet_filled, 1),
          tabItem('工具', TDIcons.tools, TDIcons.tools_filled, 2),
        ],
      ),
    );
  }

  /// 底部导航栏item
  TDBottomTabBarTabConfig tabItem(
    String title,
    IconData icon,
    IconData iconFill,
    int index,
  ) {
    return TDBottomTabBarTabConfig(
      tabText: title,
      selectedIcon: Icon(iconFill, color: primary),
      unselectedIcon: Icon(icon),
      onTap: () => controller.tabBarClick(index),
    );
  }
}
