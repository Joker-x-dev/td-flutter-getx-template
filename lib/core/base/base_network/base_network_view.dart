import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../res/icon_res.dart';
import '../base/base_view.dart';
import 'base_network_logic.dart';
import 'base_network_state.dart';

typedef BodyBuilder = Widget Function(BaseNetworkLogic baseState);

abstract class BaseNetworkView<T extends BaseNetworkLogic> extends BaseView<T> {
  const BaseNetworkView({super.key});

  /// 显示时是否需要动画
  final bool showAnimation = true;

  /// 抽象方法，子类负责实现，用于返回成功状态下的布局
  Widget bodyContent(T controller);

  /// 主视图 子类可重写
  @override
  Widget body() {
    return commonView(controller, (baseState) {
      // 调用子类实现的方法
      return bodyContent(controller);
    });
  }

  /// 创建页面主视图
  Widget commonView(T controller, BodyBuilder builder) {
    return Obx(() {
      // 根据当前状态返回相应的 Widget
      Widget child = _getWidgetForCurrentState(controller, builder);

      // 如果不需要动画，直接返回
      if (!showAnimation) return child;

      // 使用 PageTransitionSwitcher 包裹状态切换
      return PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            fillColor: Colors.transparent,
            child: child,
          );
        },
        child: child,
      );
    });
  }

  /// 根据当前状态返回相应的 Widget
  Widget _getWidgetForCurrentState(T controller, BodyBuilder builder) {
    switch (controller.networkState.uiState.value) {
      case NetState.loading:
        return loadWidget();
      case NetState.emptyData:
        return emptyWidget();
      case NetState.error:
        return failWidget(controller);
      case NetState.dataSuccess:
        return builder(controller);
    }
  }

  /// 空视图 子类可重写
  Widget emptyWidget() {
    return empty("数据为空", IconRes.emptyVoid);
  }

  /// 错误视图 子类可重写
  Widget failWidget(T controller) {
    return empty('内容加载失败，请检查网络', IconRes.emptyError);
  }

  /// 缺省页视图内容
  Widget empty(String emptyText, String imgPath) {
    return TDEmpty(
      onTapEvent: () {
        controller.loadData();
        controller.setStatusLoad();
      },
      operationText: '重新加载',
      type: TDEmptyType.operation,
      emptyText: emptyText,
      image: SvgPicture.asset(imgPath).constrained(height: 220, width: 200),
    );
  }

  /// 加载视图 子类可重写
  Widget loadWidget() {
    return const TDLoading(
      text: '加载中…',
      size: TDLoadingSize.large,
      icon: TDLoadingIcon.circle,
    ).center();
  }
}
