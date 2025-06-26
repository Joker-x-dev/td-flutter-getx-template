import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../model/response/base/base_response.dart';
import '../aletr/alert_util.dart';
import '../toast/toast_util.dart';

/// 公共工具类
class CommonUtil {
  /// 震动方法
  static vibrate() {
    // 触发震动反馈
    HapticFeedback.lightImpact();
  }

  /// 复制方法
  static copy(String text, {String msg = '复制成功'}) async {
    try {
      // 将文本复制到剪贴板
      await Clipboard.setData(ClipboardData(text: text));
      ToastUtil.show(msg);
    } catch (e) {
      ToastUtil.show("复制失败");
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
  /// 返回 true 表示成功，返回 false 表示不成功。
  /// toast: 失败后是否弹出toast提示
  /// dialog: 失败后是否弹出dialog提示
  /// 使用方法: if (!CommonUtil.isSuccess(result, toast: true)) return;
  static bool isSuccess(
    BaseResponse<dynamic> response, {
    bool toast = false,
    bool dialog = false,
    String? msg,
  }) {
    if (isNull(response) || response.code != 1000) {
      if (toast) ToastUtil.error(msg ?? response.message ?? '加载失败');
      if (dialog) AlertUtil.showFeedbackDialog(msg ?? response.message ?? '加载失败');
      // 不成功
      return false;
    }
    // 成功
    return true;
  }

  /// 判断返回的内容是否出错
  /// 返回 true 表示有错误，返回 false 表示没有错误 与 isSuccess 方法相反。
  /// toast: 失败后是否弹出toast提示
  /// dialog: 失败后是否弹出dialog提示
  /// 使用方法: if (CommonUtil.isError(result, toast: true)) return;
  static bool isError(
    BaseResponse<dynamic> response, {
    bool toast = false,
    bool dialog = false,
    String? msg,
  }) {
    return !isSuccess(response, toast: toast, dialog: dialog, msg: msg);
  }

  /// 检测参数是否为空 其中 null、{}、[]、"" 均为空值  true 空值  false 有值
  /// @param value 需要判断的值
  /// 使用方法: CommonUtil.isNull(值);
  static bool isNull(dynamic value) {
    if (value == null) return true;
    if (value is String && value.trim().isEmpty) return true;
    if (value is List && value.isEmpty) return true;
    if (value is Map && value.isEmpty) return true;
    return false;
  }

  /// 检测参数是否不为空 结果与isNull相反
  /// @param value 需要判断的值
  /// 使用方法: CommonUtil.isNotNull(值);
  static bool isNotNull(dynamic value) => !isNull(value);

  /// 关闭pop/dialog/弹出层
  static void closePop() => Navigator.of(Get.context!).pop();
}
