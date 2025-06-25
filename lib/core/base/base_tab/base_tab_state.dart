import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Tab状态管理类
class BaseTabState {
  /// tab控制器
  TabController? tabController;

  /// 使用 PageView
  bool usePageView = true;

  /// pageView控制器
  PageController? pageController;

  /// tabs切换的动画 用于修复
  /// 多个页面的情况下点击tab标签 到途径tab会卡住的问题
  RxBool isAnimating = false.obs;
}
