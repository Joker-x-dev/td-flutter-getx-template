import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../core/base/base/base_view.dart';
import '../logics/base_tab_demo_logic.dart';

class BaseTabDemoView extends BaseView<BaseTabDemoLogic> {
  const BaseTabDemoView({super.key});

  @override
  String? get navTitle => 'BaseTab 示例';

  @override
  Widget body() => TDText('BaseTab 示例页面').center();
}
