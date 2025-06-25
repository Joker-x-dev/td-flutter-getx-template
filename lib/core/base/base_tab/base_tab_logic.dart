import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../base/base_logic.dart';
import 'base_tab_state.dart';

abstract class BaseTabLogic extends BaseLogic with GetTickerProviderStateMixin {
  /// Tab状态管理
  final BaseTabState tabState = BaseTabState();

  /// tabs 标签列表，子类必须实现
  List<String> get tabList;

  @override
  void onInit() {
    super.onInit();
    if (tabList.isEmpty) return;
    tabState.tabController = TabController(length: tabList.length, vsync: this);
    if (!tabState.usePageView) return;
    tabState.pageController = PageController(initialPage: 0);
  }

  @override
  void onClose() {
    super.onClose();
    tabState.tabController?.dispose();
  }

  /// tab点击/改变
  void tabChange(int index) {
    tabState.isAnimating.value = true;
    setPageIndex(index);
    setPageView(index);
  }

  /// pageView改变
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
  setPageIndex(int index) {
    tabState.tabController!.index = index;
  }

  /// 设置页面
  setPageView(index) {
    tabState.pageController?.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
