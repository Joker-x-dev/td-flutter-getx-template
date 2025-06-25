import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
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

    // 获取屏幕高度和状态栏高度
    final screenHeight = SizeUtil.getScreenHeight();
    final statusBarHeight = SizeUtil.getStatusBarHeight();
    final safeAreaHeight = SizeUtil.getSafeBarHeight();
    final isIos = CommonUtil.isIos();

    // 设定弹窗最大高度为屏幕高度的某个比例，减去状态栏和底部安全区域的高度
    final maxHeight = screenHeight - statusBarHeight - safeAreaHeight;

    Widget dialogContent = [
          TDNavBar(
            title: title,
            screenAdaptation: false,
            useDefaultBack: false,
            height: 56,
            belowTitleWidget: const TDDivider(),
            rightBarItems:
                close
                    ? [
                      TDNavBarItem(
                        iconWidget: Icon(
                              Icons.close,
                              size: 28,
                              // color: ConstantTheme.grayOpacity4,
                            )
                            .ripple()
                            .clipRRect(all: 4)
                            .gestures(
                              onTap: () => Navigator.of(Get.context!).pop(),
                            ),
                      ),
                    ]
                    : null,
          ),
          body()
              .toColumn(
                // crossAxisAlignment: Constant.crossStart,
                // mainAxisAlignment: Constant.mainStart,
              )
              .padding(all: 16),
          if (CommonUtil.isNotNull(bottom()))
            bottom()!.padding(bottom: SizeUtil.getSafeBarHeight()),
        ]
        .toColumn(mainAxisSize: MainAxisSize.min)
        .constrained(maxHeight: isIos ? 70.00 + maxHeight : maxHeight);

    // 使用PopScope包装对话框内容，控制物理返回键行为
    return PopScope(canPop: enablePhysicalBack, child: dialogContent);
  }
}
