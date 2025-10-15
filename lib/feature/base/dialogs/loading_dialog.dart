import 'package:flutter/material.dart';
import 'package:td_flutter_getx_template/core/design_system/extensions/extensions.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../core/base/base_dialog/base_dialog.dart';
import '../../../core/design_system/theme/color.dart';
import '../../../core/design_system/theme/type.dart';
import '../../../core/design_system/widgets/space.dart';

/// 加载对话框示例
class LoadingDialog extends BaseDialog {
  final String dialogTitle;
  final String loadingText;

  const LoadingDialog({
    super.key,
    this.dialogTitle = '加载中',
    this.loadingText = '正在处理，请稍候...',
  });

  @override
  String get title => dialogTitle;

  @override
  bool get close => false; // 加载时不显示关闭按钮

  @override
  bool get line => true;

  @override
  bool get isDismissible => false; // 不允许点击外部关闭

  @override
  bool get enableDrag => false; // 不允许滑动关闭

  @override
  bool get enablePhysicalBack => false; // 不允许物理返回键关闭

  @override
  List<Widget> body() {
    return [
      // 加载指示器
      TDLoading(
        size: TDLoadingSize.large,
        icon: TDLoadingIcon.circle,
        iconColor: primary,
      ).center(),

      const SpaceVerticalLarge(),

      // 加载文本
      TDText(
        loadingText,
        font: fontBodyLarge,
        textColor: textSecondary,
        textAlign: TextAlign.center,
      ),
    ];
  }
}
