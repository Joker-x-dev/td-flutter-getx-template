import 'package:flutter/material.dart';
import 'package:td_flutter_getx_template/core/design_system/extensions/extensions.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../core/design_system/theme/color.dart';
import '../../../core/design_system/theme/shape.dart';
import '../../../core/design_system/theme/size.dart';
import '../../../core/design_system/theme/type.dart';

/// Demo卡片组件
/// 用于展示各种demo功能的卡片样式
class DemoCard extends StatelessWidget {
  /// 标题
  final String title;

  /// 描述
  final String description;

  /// 图标
  final IconData icon;

  /// 点击回调
  final VoidCallback onTap;

  /// 右侧内容组件，可选
  /// 如果不传入，则使用默认的箭头图标
  final Widget? trailing;

  const DemoCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return [
          // 左侧图标
          Icon(icon, color: primary, size: 24)
              .tight(height: 48, width: 48)
              .backgroundColor(primary.withValues(alpha: 0.1))
              .clipRadius(radiusDefault),

          // 中间内容区域
          [
            // 标题
            TDText(
              title,
              font: fontTitleMedium,
              textColor: textPrimary,
              fontWeight: fontWeightBold,
            ),

            // 描述
            TDText(
              description,
              font: fontBodyMedium,
              textColor: textSecondary,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ].toColumnStart(spacing: spaceVerticalXSmall).expanded(),

          // 右侧内容（可自定义）
          trailing ??
              Icon(TDIcons.chevron_right, color: textPlaceholder, size: 20),
        ]
        .toRowCenter(spacing: spaceHorizontalMedium)
        .padAll(spacePaddingLarge)
        .animatedTapScale(onTap)
        .backgroundColor(backgroundContainer)
        .clipRadius(radiusExtraLarge);
  }
}
