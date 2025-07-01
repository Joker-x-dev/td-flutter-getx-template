import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:td_flutter_getx_template/core/design_system/theme/size.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../util/common/common_util.dart';
import '../../util/size/size_util.dart';

abstract class BaseDialog extends StatelessWidget {
  const BaseDialog({super.key});

  /// 标题
  final String title = '';

  /// 关闭按钮
  final bool close = true;

  /// 导航栏分割线
  final bool line = true;

  /// 是否允许点击外部关闭
  bool get isDismissible => true;

  /// 是否允许向下滑动关闭
  bool get enableDrag => true;

  /// 是否允许通过物理返回按钮关闭（Android）
  bool get enablePhysicalBack => true;

  /// 顶部导航栏内容 子类可根据需求重写
  Widget? head() {
    return TDNavBar(
      title: title,
      screenAdaptation: false,
      useDefaultBack: false,
      height: 56,
      belowTitleWidget: const TDDivider(),
      rightBarItems: close
          ? [
              TDNavBarItem(
                iconWidget: Icon(Icons.close, size: 28)
                    .ripple()
                    .clipRRect(all: 4)
                    .gestures(onTap: () => CommonUtil.closePop()),
              ),
            ]
          : null,
    );
  }

  /// 设置主视图内容 (子类必须实现)
  List<Widget> body();

  /// 底部导航栏内容 子类可根据需求重写
  Widget? bottom() => null;

  /// 弹窗初始化 子类可根据需求重写
  void init() {}

  /// 展示dialog
  Future<void> show() async {
    return await Get.bottomSheet(
      // 设置是否可通过点击外部关闭
      isDismissible: isDismissible,
      // 设置是否可以通过向下滑动关闭
      enableDrag: enableDrag,
      // 设置为可滚动
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      this,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 初始化弹窗
    init();

    // 使用MediaQuery获取准确的屏幕和安全区域信息
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final topPadding = mediaQuery.padding.top; // 顶部安全区域（包括胶囊/刘海/状态栏）
    final bottomPadding = SizeUtil.getSafeBarHeight(); // 底部安全区域

    // 预留顶部和底部的安全边距
    final topMargin = spaceVerticalLarge; // 顶部额外边距
    final bottomMargin = spaceVerticalLarge; // 底部额外边距

    // 计算弹窗可用的最大高度
    // 屏幕高度 - 顶部安全区域 - 底部安全区域 - 额外边距
    final maxHeight =
        screenHeight - topPadding - bottomPadding - topMargin - bottomMargin;

    Widget dialogContent =
        [
              if (CommonUtil.isNotNull(head())) head()!,
              body().toColumn().scrollable(padding: pagePadding).flexible(),
              if (CommonUtil.isNotNull(bottom()))
                bottom()!.padding(bottom: bottomPadding),
            ]
            .toColumn(mainAxisSize: MainAxisSize.min)
            .constrained(maxHeight: maxHeight);

    // 使用PopScope包装对话框内容，控制物理返回键行为
    return PopScope(canPop: enablePhysicalBack, child: dialogContent);
  }
}
