import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 自定义遮罩加载动画
class LoadingDialog {
  static void show() {
    BotToast.showCustomLoading(
      backgroundColor: Colors.transparent,
      toastBuilder: (_) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            color: Colors.black.withOpacity(0.3),
            alignment: Alignment.center,
            child: const TDLoading(
              size: TDLoadingSize.large,
              icon: TDLoadingIcon.circle,
            ),
          ),
        );
      },
    );
  }

  static void hide() {
    BotToast.closeAllLoading();
  }
}
