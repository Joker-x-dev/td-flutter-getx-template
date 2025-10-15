import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:td_flutter_getx_template/core/design_system/extensions/extensions.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../core/base/base/base_view.dart';
import '../../../core/design_system/theme/color.dart';
import '../../../core/design_system/theme/shape.dart';
import '../../../core/design_system/theme/size.dart';
import '../../../core/design_system/theme/type.dart';
import '../../../core/design_system/widgets/space.dart';
import '../../main/widgets/demo_card.dart';
import '../logics/base_dialog_demo_logic.dart';

class BaseDialogDemoView extends BaseView<BaseDialogDemoLogic> {
  const BaseDialogDemoView({super.key});

  @override
  String? get navTitle => 'BaseDialog 示例';

  @override
  Color? get backgroundColor => backgroundSecondaryContainer;

  @override
  Widget body() {
    return [
          // 顶部说明卡片
          _buildInfoCard(),

          // 对话框选项列表 - 这些不需要响应状态变化
          DemoCard(
            title: '确认对话框',
            description: '展示确认/取消操作的对话框，常用于删除确认等重要操作场景',
            icon: TDIcons.check_circle,
            onTap: controller.showConfirmDialog,
          ),

          DemoCard(
            title: '输入对话框',
            description: '包含文本输入框的对话框，用于收集用户输入的内容信息',
            icon: TDIcons.edit,
            onTap: controller.showInputDialog,
          ),

          DemoCard(
            title: '城市选择对话框',
            description: '展示城市列表的选择对话框，支持滚动浏览和快速选择',
            icon: TDIcons.location,
            onTap: controller.showListDialog,
          ),

          // 只有加载对话框需要响应状态变化，所以只包裹这一个
          Obx(
            () => DemoCard(
              title: '加载对话框',
              description: controller.baseDialogDemoState.isLoading.value
                  ? '正在处理中，请稍候...'
                  : '显示加载状态的对话框，用于异步操作的等待提示',
              icon: controller.baseDialogDemoState.isLoading.value
                  ? TDIcons.hourglass
                  : TDIcons.loading,
              onTap: controller.baseDialogDemoState.isLoading.value
                  ? () {} // 加载中时提供空的回调函数
                  : controller.showLoadingDialog,
              trailing: controller.baseDialogDemoState.isLoading.value
                  ? TDLoading(
                      size: TDLoadingSize.small,
                      icon: TDLoadingIcon.circle,
                      iconColor: primary,
                    )
                  : null,
            ),
          ),

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
              '对话框使用说明',
              font: fontTitleMedium,
              textColor: primary,
              fontWeight: fontWeightBold,
            ),
          ].toRow(),

          const SpaceVerticalSmall(),

          // 说明文本
          TDText(
            '点击下方卡片可以体验不同类型的对话框。每个对话框都继承自 BaseDialog，支持自适应高度和滚动，确保在各种设备上都有良好的用户体验。',
            font: fontBodyMedium,
            textColor: textSecondary,
            maxLines: null,
          ),
        ]
        .toColumnStart()
        .padAll(spacePaddingLarge)
        .decorated(
          color: primary.withValues(alpha: 0.1),
          border: Border.all(color: primary.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(radiusExtraLarge),
        );
  }

  /// 构建底部预览卡片
  Widget _buildPreviewCard() {
    return [
          Icon(TDIcons.chat_bubble, color: textPlaceholder, size: 32),

          const SpaceVerticalSmall(),

          TDText(
            '对话框预览',
            font: fontTitleMedium,
            textColor: textSecondary,
            fontWeight: fontWeightBold,
          ),

          const SpaceVerticalXSmall(),

          TDText(
            '当前页面展示了应用的对话框效果，每种对话框都有不同的用途和交互方式。',
            font: fontBodySmall,
            textColor: textPlaceholder,
            textAlign: TextAlign.center,
            maxLines: null,
          ),
        ]
        .toColumnCenter()
        .width(double.infinity)
        .padAll(spacePaddingLarge)
        .backgroundColor(backgroundContainer)
        .clipRadius(radiusExtraLarge);
  }
}
