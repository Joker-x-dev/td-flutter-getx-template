import 'package:flutter/material.dart';
import 'package:td_flutter_getx_template/core/design_system/extensions/extensions.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../core/base/base_dialog/base_dialog.dart';
import '../../../core/design_system/theme/color.dart';
import '../../../core/design_system/theme/type.dart';

import '../../../core/util/common/common_util.dart';

/// 确认对话框示例
class ConfirmDialog extends BaseDialog {
  final String dialogTitle;
  final String content;
  final String cancelText;
  final String confirmText;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  const ConfirmDialog({
    super.key,
    this.dialogTitle = '确认操作',
    this.content = '您确定要执行此操作吗？',
    this.cancelText = '取消',
    this.confirmText = '确认',
    this.onCancel,
    this.onConfirm,
  });

  @override
  String get title => dialogTitle;

  @override
  List<Widget> body() {
    return [
      // 内容区域
      TDText(
        content,
        font: fontBodyLarge,
        textColor: textPrimary,
        textAlign: TextAlign.center,
      ),
    ];
  }

  @override
  Widget? bottom() {
    return [
      // 取消按钮
      TDButton(
        text: cancelText,
        theme: TDButtonTheme.defaultTheme,
        type: TDButtonType.outline,
        size: TDButtonSize.large,
        onTap: () {
          CommonUtil.closePop();
          onCancel?.call();
        },
      ).expanded(),

      const SizedBox(width: 12),

      // 确认按钮
      TDButton(
        text: confirmText,
        theme: TDButtonTheme.primary,
        size: TDButtonSize.large,
        onTap: () {
          CommonUtil.closePop();
          onConfirm?.call();
        },
      ).expanded(),
    ].toRowCenter().padHorizontal(16);
  }
}
