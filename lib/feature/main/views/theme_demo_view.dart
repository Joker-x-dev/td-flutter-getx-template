import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../core/base/base/base_view.dart';
import '../../../core/design_system/theme/color.dart';
import '../../../core/design_system/theme/shape.dart';
import '../../../core/design_system/theme/size.dart';
import '../../../core/design_system/theme/type.dart';
import '../../../core/design_system/widgets/column.dart';
import '../../../core/design_system/widgets/space.dart';
import '../logics/theme_demo_logic.dart';
import '../widgets/demo_card.dart';

class ThemeDemoView extends BaseView<ThemeDemoLogic> {
  const ThemeDemoView({super.key});

  @override
  bool get navBackBtn => false;

  @override
  String get navTitle => '主题示例';

  @override
  Color? get backgroundColor => backgroundSecondaryContainer;

  @override
  Widget body() {
    return [
          // 顶部说明卡片
          _buildInfoCard(),

          // 主题选项列表
          ...controller.themeDemoState.themeDemoItems.asMap().entries.map((
            entry,
          ) {
            final index = entry.key;
            final item = entry.value;

            return DemoCard(
              title: item.title,
              description: item.description,
              icon: item.icon,
              onTap: item.onTap,
              trailing: _buildThemeColorCircle(index),
            );
          }),

          // 底部提示卡片
          _buildPreviewCard(),
        ]
        .toColumnCenter(spacing: spaceVerticalMedium)
        .scrollable(
          physics: const BouncingScrollPhysics(),
          padding: pagePadding,
        );
  }

  /// 构建顶部信息卡片
  Widget _buildInfoCard() {
    return [
          // 标题行
          [
            Icon(TDIcons.info_circle, color: primary, size: 20),
            const SpaceHorizontalSmall(),
            TDText(
              '主题切换说明',
              font: fontTitleMedium,
              textColor: primary,
              fontWeight: fontWeightBold,
            ),
          ].toRow(),

          const SpaceVerticalSmall(),

          // 说明文本
          TDText(
            '点击下方卡片可以切换应用的主题颜色，支持绿色、红色、蓝色和默认主题。主题切换会影响整个应用的配色方案，包括按钮、卡片、文本等所有UI元素。',
            font: fontBodyMedium,
            textColor: textSecondary,
            maxLines: null,
          ),
        ]
        .toColumnStart()
        .padding(all: spacePaddingLarge)
        .decorated(
          color: primary.withValues(alpha: 0.1),
          border: Border.all(color: primary.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(radiusExtraLarge),
        );
  }

  /// 构建底部预览卡片
  Widget _buildPreviewCard() {
    return [
          Icon(TDIcons.palette, color: textPlaceholder, size: 32),

          const SpaceVerticalSmall(),

          TDText(
            '主题预览',
            font: fontTitleMedium,
            textColor: textSecondary,
            fontWeight: fontWeightBold,
          ),

          const SpaceVerticalXSmall(),

          TDText(
            '当前页面展示了应用的主题色效果，切换主题后可以实时看到颜色变化。',
            font: fontBodySmall,
            textColor: textPlaceholder,
            textAlign: TextAlign.center,
            maxLines: null,
          ),
        ]
        .toColumnCenter()
        .padding(all: spacePaddingLarge)
        .backgroundColor(backgroundContainer)
        .clipRRect(all: radiusExtraLarge);
  }

  /// 根据主题索引构建对应颜色的圆圈
  Widget _buildThemeColorCircle(int themeIndex) {
    Color themeColor;
    switch (themeIndex) {
      case 0: // 绿色主题
        themeColor = const Color(0xff45c58b);
        break;
      case 1: // 红色主题
        themeColor = const Color(0xfff36d78);
        break;
      case 2: // 蓝色主题
        themeColor = const Color(0xff2196F3);
        break;
      case 3: // 默认主题
        themeColor = const Color(0xff0052d9);
        break;
      default:
        themeColor = primary;
    }

    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: themeColor,
        shape: BoxShape.circle,
        border: Border.all(color: themeColor.withValues(alpha: 0.3), width: 3),
      ),
    );
  }
}
