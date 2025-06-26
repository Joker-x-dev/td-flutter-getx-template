import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../core/base/base/base_view.dart';
import '../../../core/design_system/theme/color.dart';
import '../../../core/design_system/theme/size.dart';
import '../logics/base_demo_logic.dart';

class BaseDemoView extends BaseView<BaseDemoLogic> {
  const BaseDemoView({super.key});

  @override
  double get navHeight => 88;

  @override
  String? get navTitle => 'Base 示例';

  @override
  List<TDNavBarItem>? get rightBarItems => [
    TDNavBarItem(
      icon: TDIcons.notification,
      iconSize: 20,
      padding: EdgeInsets.only(right: spaceHorizontalXLarge),
    ),
    TDNavBarItem(
      icon: TDIcons.logo_github,
      iconSize: 20,
      padding: EdgeInsets.only(right: spaceHorizontalLarge),
    ),
  ];

  @override
  Widget? get navBottomWidget => TDDropdownMenu(
    direction: TDDropdownMenuDirection.down,
    items: [
      TDDropdownItem(
        options: [
          TDDropdownItemOption(label: '全部产品', value: 'all', selected: true),
          TDDropdownItemOption(label: '最新产品', value: 'new'),
          TDDropdownItemOption(label: '最火产品', value: 'hot'),
        ],
      ),
      TDDropdownItem(
        options: [
          TDDropdownItemOption(label: '默认排序', value: 'default', selected: true),
          TDDropdownItemOption(label: '价格从高到低', value: 'price'),
        ],
      ),
    ],
  );

  @override
  Widget body() => TDText(
    '页面主视图内容\n对 Scaffold 做了封装，减少样板代码',
    textAlign: TextAlign.center,
  ).center().backgroundColor(backgroundSecondaryContainer);

  @override
  Widget? floatingAction() {
    return TDFab(theme: TDFabTheme.primary, text: 'Floating');
  }

  @override
  Widget? bottom() {
    return TDBottomTabBar(
      barHeight: 60,
      TDBottomTabBarBasicType.iconText,
      currentIndex: 2,
      componentType: TDBottomTabBarComponentType.normal,
      navigationTabs: [
        tabItem(
          '消息',
          TDIcons.chat_message,
          TDIcons.chat_message_filled,
          0,
          badge: true,
          badgeCount: '3',
        ),
        tabItem('待办', TDIcons.file_1, TDIcons.file_1_filled, 1),
        tabItem('工作台', TDIcons.app, TDIcons.app_filled, 2),
        tabItem(
          '通讯录',
          TDIcons.personal_information,
          TDIcons.personal_information_filled,
          3,
        ),
        tabItem('我的', TDIcons.user_1, TDIcons.user_1_filled, 4),
      ],
    );
  }

  /// 底部导航栏item
  TDBottomTabBarTabConfig tabItem(
    String title,
    IconData icon,
    IconData iconFill,
    int index, {
    bool badge = false,
    String badgeCount = '1',
  }) {
    return TDBottomTabBarTabConfig(
      tabText: title,
      selectedIcon: Icon(iconFill, color: primary),
      badgeConfig:
          badge
              ? BadgeConfig(
                showBadge: true,
                tdBadge: TDBadge(TDBadgeType.bubble, count: badgeCount),
                badgeTopOffset: -2,
                badgeRightOffset: -10,
              )
              : null,
      unselectedIcon: Icon(icon),
      onTap: () => {},
    );
  }
}
