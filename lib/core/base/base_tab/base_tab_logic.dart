import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../base/base_logic.dart';
import 'base_tab_state.dart';

/// 基础 Tab 页面 Logic
///
/// 统一管理 TabController、PageController 和页面切换动画状态。
abstract class BaseTabLogic extends BaseLogic with GetTickerProviderStateMixin {
  /// Tab状态管理
  final BaseTabState tabState = BaseTabState();

  /// tabs 标签列表，子类必须实现
  List<String> get tabList;

  /// 初始化 Tab 与 PageView 控制器
  @override
  void onInit() {
    super.onInit();
    if (tabList.isEmpty) return;
    tabState.tabController = TabController(length: tabList.length, vsync: this);
    if (!tabState.usePageView) return;
    tabState.pageController = PageController(initialPage: 0);
  }

  /// 释放 Tab 控制器
  @override
  void onClose() {
    super.onClose();
    tabState.tabController?.dispose();
    tabState.tabController = null;
    tabState.pageController?.dispose();
    tabState.pageController = null;
  }

  /// tab点击/改变
  ///
  /// [index] 目标 Tab 下标。
  void tabChange(int index) {
    tabState.isAnimating.value = true;
    setPageIndex(index);
    setPageView(index);
  }

  /// pageView改变
  ///
  /// [index] 当前 PageView 页面下标。
  void pageViewChange(int index) {
    // 根据标志判断是手动滚动还是动画滚动
    if (!tabState.isAnimating.value) {
      setPageIndex(index);
      tabState.isAnimating.value = false;
      return;
    }

    if (tabState.tabController!.index == index && tabState.isAnimating.value) {
      setPageIndex(index);
      tabState.isAnimating.value = false;
    }
  }

  /// 设置页面下标
  ///
  /// [index] 目标 Tab 下标。
  void setPageIndex(int index) {
    tabState.tabController!.index = index;
  }

  /// 设置页面
  ///
  /// [index] 目标 PageView 页面下标。
  void setPageView(int index) {
    final PageController? pageController = tabState.pageController;
    if (pageController == null || !pageController.hasClients) {
      return;
    }
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
