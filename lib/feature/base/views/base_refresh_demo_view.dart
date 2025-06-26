import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../core/base/base/base_view.dart';
import '../logics/base_refresh_demo_logic.dart';

class BaseRefreshDemoView extends BaseView<BaseRefreshDemoLogic> {
  const BaseRefreshDemoView({super.key});

  @override
  String? get navTitle => 'BaseRefresh 示例';

  @override
  Widget body() => TDText('BaseRefresh 示例页面').center();
}
