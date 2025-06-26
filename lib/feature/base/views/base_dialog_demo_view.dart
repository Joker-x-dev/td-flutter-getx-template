import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../core/base/base/base_view.dart';
import '../logics/base_dialog_demo_logic.dart';

class BaseDialogDemoView extends BaseView<BaseDialogDemoLogic> {
  const BaseDialogDemoView({super.key});

  @override
  String? get navTitle => 'BaseDialog 示例';

  @override
  Widget body() => TDText('BaseDialog 示例页面').center();
}
