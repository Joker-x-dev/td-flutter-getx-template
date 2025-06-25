import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:td_flutter_getx_template/core/base/base/base_view.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../core/design_system/theme/type.dart';
import '../logics/main_logic.dart';

class MainView extends BaseView<MainLogic> {
  const MainView({super.key});

  @override
  bool get navBackBtn => false;

  @override
  String? get navTitle => "主页";

  @override
  Widget body() => TDText('TD Flutter Getx Template', font: fontBodyExtraLarge).center();
}
