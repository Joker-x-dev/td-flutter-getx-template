import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../design_system/theme/shape.dart';
import '../../design_system/theme/size.dart';

class ToastUtil {
  static CancelFunc? _cancelFunc;

  static void _showBase(
    String message, {
    TDNoticeBarTheme theme = TDNoticeBarTheme.info,
  }) {
    _cancelFunc = BotToast.showCustomNotification(
      toastBuilder: (cancelFunc) {
        return TDNoticeBar(
              context: message,
              theme: theme,
              prefixIcon: TDIcons.error_circle_filled,
              suffixIcon: TDIcons.close,
              onTap: (trigger) => hide(),
            )
            .clipRRect(all: radiusDefault)
            .marginSymmetric(horizontal: spaceHorizontalLarge);
      },
    );
  }

  /// 普通通知
  static void show(String message) {
    _showBase(message, theme: TDNoticeBarTheme.info);
  }

  /// 成功通知
  static void success(String message) {
    _showBase(message, theme: TDNoticeBarTheme.success);
  }

  /// 警告通知
  static void warning(String message) {
    _showBase(message, theme: TDNoticeBarTheme.warning);
  }

  /// 错误通知
  static void error(String message) {
    _showBase(message, theme: TDNoticeBarTheme.error);
  }

  static void hide() {
    if (_cancelFunc != null) {
      _cancelFunc!();
      _cancelFunc = null;
    }
  }
}
