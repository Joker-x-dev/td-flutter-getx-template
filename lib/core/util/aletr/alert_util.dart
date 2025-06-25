import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class AlertUtil {
  /// 默认的提示标题文本
  static const String defaultTitleText = '提示';

  /// 反馈类对话框
  static void showFeedbackDialog(
    String content, {
    String title = defaultTitleText,
  }) {
    showGeneralDialog(
      context: Get.context!,
      pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return TDConfirmDialog(
          title: title,
          content: content,
          showCloseButton: true,
        );
      },
    );
  }

  /// 确认类对话框
  static void showConfirmDialog(
    String content, {
    String title = defaultTitleText,
    rightBtnAction,
  }) {
    showGeneralDialog(
      context: Get.context!,
      pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return TDAlertDialog(
          title: title,
          content: content,
          showCloseButton: true,
          rightBtnAction: rightBtnAction,
        );
      },
    );
  }

  /// 输入类对话框
  /// 输入弹窗
  static Future<void> showInputDialog(
    String content, {
    String title = defaultTitleText,
    String hintText = '请输入内容',
    required Function(String value) onConfirm,
  }) async {
    final TextEditingController textController = TextEditingController();
    await showGeneralDialog(
      context: Get.context!,
      pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return StatefulBuilder(
          builder: (
            BuildContext context,
            void Function(void Function()) setState,
          ) {
            return TDInputDialog(
              textEditingController: textController,
              title: title,
              content: content,
              hintText: hintText,
              showCloseButton: true,
              rightBtn: TDDialogButtonOptions(
                title: '确认',
                fontWeight: FontWeight.w600,
                height: 56,
                action: () {
                  final inputValue = textController.text;
                  onConfirm(inputValue);
                },
              ),
            );
          },
        );
      },
    );
  }

  /// 带图片的对话框
  static void showImageDialog(
    String content, {
    required Image image,
    String title = defaultTitleText,
    TDDialogImagePosition imagePosition = TDDialogImagePosition.top,
  }) {
    showGeneralDialog(
      context: Get.context!,
      pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return TDImageDialog(
          image: image,
          title: title,
          content: content,
          imagePosition: imagePosition,
          showCloseButton: true,
        );
      },
    );
  }
}
