import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import '../../design_system/theme/size.dart';
import '../base_network/base_network_view.dart';
import 'base_refresh_logic.dart';

abstract class BaseRefreshView<T extends BaseRefreshLogic>
    extends BaseNetworkView<T> {
  BaseRefreshView({super.key});

  /// 默认内边距的值 子类可重写
  final EdgeInsetsGeometry defaultPadding = listItemPadding;

  /// 是否有内边距 默认都会有内边距 子类可重写
  final bool padding = true;

  /// 子类重写此方法传递视图内容
  List<Widget> pageContent(T controller);

  @override
  Widget bodyContent(T controller) {
    return EasyRefresh(
      controller: controller.refreshState.easyRefreshController,
      onRefresh: () async => await controller.refresh(),
      header: const ClassicHeader(
        armedText: '释放刷新',
        readyText: '正在加载...',
        processedText: '加载完成',
        processingText: '正在刷新...',
        messageText: '更新于 %T',
        failedText: '刷新失败',
        noMoreText: '没有更多数据',
        dragText: '拉动刷新',
      ),
      child: ListView(
        padding: padding ? defaultPadding : null,
        children: pageContent(controller),
      ),
    );
  }
}
