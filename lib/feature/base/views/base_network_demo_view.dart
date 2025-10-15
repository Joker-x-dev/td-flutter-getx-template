import 'package:flutter/material.dart';
import 'package:td_flutter_getx_template/core/design_system/extensions/extensions.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../core/base/base/base_view.dart';
import '../logics/base_network_demo_logic.dart';

class BaseNetworkDemoView extends BaseView<BaseNetworkDemoLogic> {
  const BaseNetworkDemoView({super.key});

  @override
  String? get navTitle => 'BaseNetwork 示例';

  @override
  Widget body() => TDText('BaseNetwork 示例页面').center();
}
