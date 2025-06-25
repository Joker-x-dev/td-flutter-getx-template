import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

/// 交互效果扩展
extension InteractionExtensions on Widget {
  /// 点击回弹效果
  ///
  /// 使用示例:
  /// ```dart
  /// Container().tapScale(
  ///   onTap: () => print('tapped'),
  ///   scale: 0.95,
  ///   duration: Duration(milliseconds: 150),
  /// )
  /// ```
  Widget tapScale({
    required VoidCallback onTap,
    double scale = 0.95,
    Duration duration = const Duration(milliseconds: 150),
    Curve curve = Curves.easeOut,
  }) {
    RxBool pressed = false.obs;

    return Obx(
      () => gestures(
            onTap: onTap,
            onTapChange: (tapStatus) => pressed.value = tapStatus,
          )
          .scale(all: pressed.value ? scale : 1.0, animate: true)
          .animate(duration, curve),
    );
  }
}
