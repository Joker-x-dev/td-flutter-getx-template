import 'package:flutter/material.dart';
import 'package:td_flutter_getx_template/core/base/base/base_logic.dart';

import '../states/main_state.dart';
import '../views/base_demo_view.dart';
import '../views/network_demo_view.dart';
import '../views/utils_demo_view.dart';

class MainLogic extends BaseLogic {
  final MainState mainState = MainState();

  /// 页面列表
  final List<Widget> pageList = [
    const BaseDemoView(),
    const NetworkDemoView(),
    const UtilsDemoView(),
  ];

  @override
  void onInit() {
    super.onInit();
    init();
  }

  init() {
    mainState.pageController = PageController(initialPage: mainState.pageIndex.value);
  }

  /// 底部导航栏点击
  tabBarClick(int index) {
    mainState.isAnimating.value = true;
    setPageIndex(index);
    setPageView(index);
  }

  /// pageView改变
  pageViewChange(int index) {
    // 根据标志判断是手动滚动还是动画滚动
    if (!mainState.isAnimating.value) {
      setPageIndex(index);
      mainState.isAnimating.value = false;
      return;
    }

    if (mainState.pageIndex.value == index && mainState.isAnimating.value) {
      setPageIndex(index);
      mainState.isAnimating.value = false;
    }
  }

  /// 设置页面下标
  setPageIndex(int index) {
    mainState.pageIndex.value = index;
  }

  /// 设置页面
  setPageView(int index) {
    mainState.pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    mainState.pageController.dispose();
    super.onClose();
  }
}
