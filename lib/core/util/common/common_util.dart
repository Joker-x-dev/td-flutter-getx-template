import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../config/app_config.dart';
import '../../localization/common/common_keys.dart';
import '../../model/response/base/base_response.dart';
import '../aletr/alert_util.dart';
import '../toast/toast_util.dart';

/// 公共工具类
class CommonUtil {
  /// 震动方法
  static void vibrate() {
    // 触发震动反馈
    HapticFeedback.lightImpact();
  }

  /// 复制方法
  ///
  /// [text] 待复制文本。
  /// [msg] 可选复制成功提示。
  static Future<void> copy(String text, {String? msg}) async {
    try {
      // 将文本复制到剪贴板
      await Clipboard.setData(ClipboardData(text: text));
      ToastUtil.show(msg ?? CommonKeys.copySuccess.tr);
    } on Exception catch (_) {
      ToastUtil.show(CommonKeys.copyFailed.tr);
    }
  }

  /// 退出应用
  static void exitApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  /// 是否安卓
  static bool isAndroid() => Platform.isAndroid;

  /// 是否ios
  static bool isIos() => Platform.isIOS;

  /// 判断返回的内容是否成功
  ///
  /// [response] 待检查的网络响应。
  /// [toast] 失败时是否展示 Toast。
  /// [dialog] 失败时是否展示对话框。
  /// [msg] 可选自定义错误提示。
  ///
  /// 返回 true 表示成功，返回 false 表示不成功。
  static bool isSuccess(
    BaseResponse<dynamic>? response, {
    bool toast = false,
    bool dialog = false,
    String? msg,
  }) {
    if (response == null || response.code != AppConfig.successCode) {
      if (toast) {
        ToastUtil.error(msg ?? response?.message ?? CommonKeys.loadFailed.tr);
      }
      if (dialog) {
        AlertUtil.showFeedbackDialog(
          msg ?? response?.message ?? CommonKeys.loadFailed.tr,
        );
      }
      // 不成功
      return false;
    }
    // 成功
    return true;
  }

  /// 判断返回的内容是否出错
  ///
  /// [response] 待检查的网络响应。
  /// [toast] 失败时是否展示 Toast。
  /// [dialog] 失败时是否展示对话框。
  /// [msg] 可选自定义错误提示。
  ///
  /// 返回 true 表示有错误，返回 false 表示没有错误 与 isSuccess 方法相反。
  static bool isError(
    BaseResponse<dynamic>? response, {
    bool toast = false,
    bool dialog = false,
    String? msg,
  }) {
    return !isSuccess(response, toast: toast, dialog: dialog, msg: msg);
  }

  /// 检测参数是否为 null
  ///
  /// [value] 待检测值。
  ///
  /// 值为 `null` 时返回 `true`。
  static bool isNull(dynamic value) => value == null;

  /// 检测参数是否不为 null
  ///
  /// [value] 待检测值。
  ///
  /// 值不为 `null` 时返回 `true`。
  static bool isNotNull(dynamic value) => !isNull(value);

  /// 检测参数是否为空值
  ///
  /// [value] 待检测值。
  ///
  /// null、空字符串、空集合（List/Set/Map/Iterable）均为空值
  /// 返回是否为空值。
  static bool isBlank(dynamic value) {
    if (value == null) return true;
    if (value is String && value.trim().isEmpty) return true;
    if (value is Iterable && value.isEmpty) return true;
    if (value is Map && value.isEmpty) return true;
    return false;
  }

  /// 检测参数是否不为空
  ///
  /// [value] 待检测值。
  ///
  /// 返回是否包含有效值。
  static bool isNotBlank(dynamic value) => !isBlank(value);

  /// 关闭pop/dialog/弹出层
  static void closePop() => Navigator.of(Get.context!).pop();
}
