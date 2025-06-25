import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import '../../design_system/theme/size.dart';
import '../../design_system/widgets/space.dart';
import '../base_network/base_network_view.dart';
import 'base_list_logic.dart';

abstract class BaseListView<T extends BaseListLogic, E>
    extends BaseNetworkView<T> {
  const BaseListView({super.key});

  /// 子类重写此方法传递列表项widget
  Widget itemWidget(E item, int index);

  @override
  Widget bodyContent(T controller) {
    return EasyRefresh(
      controller: controller.listState.easyRefreshController,
      onRefresh: () async => await controller.refresh(),
      onLoad: () async => await controller.loadMore(),
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
      footer: const ClassicFooter(
        dragText: '上拉以加载',
        armedText: '释放准备加载',
        readyText: '正在加载...',
        processingText: '正在加载...',
        processedText: '加载成功',
        noMoreText: '没有更多数据',
        failedText: '加载失败',
        messageText: '最后更新于 %T',
      ),
      child: builderItemWidget(),
    );
  }

  /// 使用listview进行构建 这里可以进行重写使用其他的进行构建
  Widget builderItemWidget() {
    return ListView.separated(
      padding: listItemPadding,
      itemCount: controller.listState.dataList.length,
      separatorBuilder: (context, index) => const SpaceVerticalLarge(),
      itemBuilder: (context, index) {
        var item = controller.listState.dataList[index];
        return itemWidget(item, index);
      },
    );
  }
}
