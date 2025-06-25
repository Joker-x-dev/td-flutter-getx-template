import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/common_util.dart';

class SizeUtil {
  /// 获取屏幕宽度
  static getScreenWidth() {
    return ScreenUtil().screenWidth;
  }

  /// 获取屏幕高度
  static getScreenHeight() {
    return ScreenUtil().screenHeight;
  }

  /// 状态栏高度 刘海屏会更高
  static getStatusBarHeight() {
    return ScreenUtil().statusBarHeight;
  }

  /// 导航栏高度
  static getNavBarHeight() {
    return AppBar().preferredSize.height;
  }

  /// 安全区域高度
  static getSafeBarHeight() {
    return CommonUtil.isAndroid() ? 14.00 : ScreenUtil().bottomBarHeight;
  }
}
