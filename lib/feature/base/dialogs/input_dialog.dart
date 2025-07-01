import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../core/base/base_dialog/base_dialog.dart';
import '../../../core/design_system/theme/color.dart';
import '../../../core/design_system/widgets/row.dart';
import '../../../core/util/common/common_util.dart';

/// 输入对话框示例
class InputDialog extends BaseDialog {
  final String dialogTitle;
  final String hintText;
  final String confirmText;
  final String cancelText;
  final Function(String)? onConfirm;
  final VoidCallback? onCancel;

  // 输入控制器需要在类级别定义以便在 bottom() 中访问
  final TextEditingController _controller = TextEditingController();

  InputDialog({
    super.key,
    this.dialogTitle = '请输入内容',
    this.hintText = '请输入...',
    this.confirmText = '确认',
    this.cancelText = '取消',
    this.onConfirm,
    this.onCancel,
  });

  @override
  String get title => dialogTitle;

  @override
  List<Widget> body() {
    return [
      // 输入框
      TDInput(
        controller: _controller,
        hintText: hintText,
        type: TDInputType.normal,
        maxLines: 3,
        backgroundColor: backgroundSecondaryContainer,
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
          final text = _controller.text.trim();
          CommonUtil.closePop();
          onConfirm?.call(text);
        },
      ).expanded(),
    ].toRowCenter().padding(horizontal: 16);
  }
}
