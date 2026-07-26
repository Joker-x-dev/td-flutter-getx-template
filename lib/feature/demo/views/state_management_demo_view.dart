import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_kit/core/base/base/base_view.dart';
import 'package:flutter_kit/core/design_system/extensions/extensions.dart';
import 'package:flutter_kit/core/design_system/theme/shape.dart';
import 'package:flutter_kit/core/design_system/theme/size.dart';
import 'package:flutter_kit/core/design_system/widgets/space.dart';
import 'package:flutter_kit/core/service/demo_counter_service.dart';
import 'package:flutter_kit/core/ui/preview/app_preview_annotations.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../localization/demo_keys.dart';
import '../logics/state_management_demo_logic.dart';

/// 状态管理示例页
///
/// 展示跨页面共享的全局响应式计数器。
class StateManagementDemoView extends BaseView<StateManagementDemoLogic> {
  /// 创建状态管理示例页面
  ///
  /// [logic] 外部注入的状态管理示例 Logic 一般用于测试和预览。
  StateManagementDemoView({super.key, super.logic});

  /// 导航栏标题
  @override
  String? get navTitle => DemoKeys.titleStateManagementDemo.tr;

  /// 页面背景颜色
  @override
  Color? get backgroundColor => appTheme.backgroundSecondaryContainer;

  /// 构建全局计数器与操作按钮
  @override
  Widget body() {
    return Obx(
      () =>
          [
                TDText(
                  '${logic.count.value}',
                  font: appTheme.fontDisplayLarge,
                  textColor: appTheme.primary,
                  fontWeight: appTheme.fontWeightBold,
                ),
                const SpaceVerticalLarge(),
                [
                  TDButton(
                    text: DemoKeys.counterIncrement.tr,
                    theme: TDButtonTheme.primary,
                    onTap: logic.increment,
                  ),
                  TDButton(
                    text: DemoKeys.counterDecrement.tr,
                    theme: TDButtonTheme.defaultTheme,
                    onTap: logic.decrement,
                  ),
                  TDButton(
                    text: DemoKeys.counterReset.tr,
                    theme: TDButtonTheme.danger,
                    onTap: logic.reset,
                  ),
                ].toRowCenter(spacing: spaceHorizontalMedium),
              ]
              .toColumnCenter(spacing: spaceVerticalXLarge)
              .center(),
    );
  }
}

/// 状态管理示例页面预览
@ResponsivePreview()
Widget previewStateManagementDemoView() {
  final DemoCounterService counterService = DemoCounterService();
  counterService.count.value = 12;
  return StateManagementDemoView(
    logic: StateManagementDemoLogic(counterService: counterService),
  );
}
