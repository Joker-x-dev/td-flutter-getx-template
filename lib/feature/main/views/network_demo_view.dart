import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:td_flutter_getx_template/core/base/base/base_view.dart';
import 'package:td_flutter_getx_template/core/design_system/widgets/column.dart';

import '../../../core/design_system/theme/color.dart';
import '../../../core/design_system/theme/size.dart';
import '../logics/network_demo_logic.dart';
import '../widgets/demo_card.dart';

class NetworkDemoView extends BaseView<NetworkDemoLogic> {
  const NetworkDemoView({super.key});

  @override
  bool get navBackBtn => false;

  @override
  String? get navTitle => "网络请求展示";

  @override
  Color? get backgroundColor => backgroundSecondaryContainer;

  @override
  Widget body() {
    return controller.networkDemoState.networkDemoItems
        .map((item) => DemoCard(
              title: item.title,
              description: item.description,
              icon: item.icon,
              onTap: item.onTap,
            ))
        .toList()
        .toColumnCenter(spacing: spaceVerticalMedium)
        .scrollable(
          physics: const BouncingScrollPhysics(),
          padding: pagePadding,
        );
  }
} 