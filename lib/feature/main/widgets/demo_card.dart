import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:td_flutter_getx_template/core/design_system/widgets/column.dart';
import 'package:td_flutter_getx_template/core/design_system/widgets/row.dart';
import 'package:td_flutter_getx_template/core/extensions/interaction_extensions.dart';
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

  const DemoCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return [
          // 左侧图标
          Icon(icon, color: primary, size: 24)
              .constrained(height: 48, width: 48)
              .backgroundColor(primary.withValues(alpha: 0.1))
              .clipRRect(all: radiusDefault),

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

          // 右侧箭头
          Icon(TDIcons.chevron_right, color: textPlaceholder, size: 20),
        ]
        .toRowCenter(spacing: spaceHorizontalMedium)
        .padding(all: spacePaddingLarge)
        .ripple()
        .backgroundColor(backgroundContainer)
        .clipRRect(all: radiusExtraLarge)
        .tapScale(onTap: onTap);
  }
} 