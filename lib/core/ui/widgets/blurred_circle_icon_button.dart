// 毛玻璃按钮
import 'dart:ui';

import 'package:flutter/material.dart';

class BlurredCircleIconButton extends StatelessWidget {
  /// 按钮icon
  final Icon icon;

  /// 按钮点击
  final VoidCallback onPressed;

  /// 按钮大小
  final double btnSize;

  /// 图标大小
  final double iconSize;

  const BlurredCircleIconButton(
      {super.key,
      required this.icon,
      required this.onPressed,
      this.btnSize = 52,
      this.iconSize = 31.2});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: btnSize,
      width: btnSize,
      child: ClipOval(
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      color: Colors.white,
                      iconSize: iconSize,
                      icon: icon,
                      onPressed: onPressed)))),
    );
  }
}
