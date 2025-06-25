import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../design_system/widgets/keep_alive_wrapper.dart';

abstract class BaseView<T> extends GetView<T> {
  const BaseView({super.key});

  /// 设置标题文字
  final String? navTitle = null;

  /// 是否显示导航栏返回按钮
  final bool navBackBtn = true;

  /// 导航栏高度
  final double navHeight = 44;

  /// 导航栏底部的widget
  final Widget? navBottomWidget = null;

  /// 设置右边按钮数组
  final List<TDNavBarItem>? rightBarItems = null;

  /// 是否隐藏导航栏
  final bool isHiddenNav = false;

  /// 使用默认返回按钮
  final bool useDefaultBack = true;

  /// appbar塌陷
  final bool extendBodyBehindAppBar = false;

  /// 输入框推动页面
  final bool resizeToAvoidBottomInset = true;

  /// 背景颜色
  final Color? backgroundColor = null;

  /// 是否保存当前页面状态
  final bool keepAlive = true;

  /// 导航栏 子类可根据需求重写
  PreferredSizeWidget? head() {
    if (isHiddenNav) return null;
    return TDNavBar(
      leftBarItems:
          navBackBtn
              ? useDefaultBack
                  ? [TDNavBarItem(iconWidget: const BackButton())]
                  : null
              : null,
      padding: EdgeInsets.zero,
      title: navTitle,
      height: navHeight,
      useDefaultBack: false,
      rightBarItems: rightBarItems,
      belowTitleWidget: navBottomWidget,
    );
  }

  /// 设置主视图内容 (子类必须实现)
  Widget body();

  /// 底部导航栏内容 子类可根据需求重写
  Widget? bottom() => null;

  /// 右下角的悬浮操作按钮
  Widget? floatingAction() => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor,
      appBar: head(),
      body: keepAlive ? KeepAliveWrapper(child: body()) : body(),
      bottomNavigationBar: bottom(),
      floatingActionButton: floatingAction(),
    );
  }
}
