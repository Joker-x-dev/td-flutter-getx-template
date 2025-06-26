import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainState {
  /// 页面下标
  RxInt pageIndex = 0.obs;

  /// pageView控制器
  late final PageController pageController;

  /// 页面切换的动画锁，用于修复
  /// 多个页面的情况下点击tab标签到途径tab会卡住的问题
  RxBool isAnimating = false.obs;
}
