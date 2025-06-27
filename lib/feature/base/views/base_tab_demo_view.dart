import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:td_flutter_getx_template/core/base/base_tab/base_tab_view.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../logics/base_tab_demo_logic.dart';

class BaseTabDemoView extends BaseTabView<BaseTabDemoLogic> {
  const BaseTabDemoView({super.key});

  @override
  String? get navTitle => 'BaseTab 示例';

  @override
  List<Widget> pageViewChildren() {
    return [
      TDText('页面 1').center().backgroundColor(Colors.red),
      TDText('页面 2').center().backgroundColor(Colors.green),
      TDText('页面 3').center().backgroundColor(Colors.blue),
    ];
  }
}
