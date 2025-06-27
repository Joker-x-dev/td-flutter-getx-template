import 'package:td_flutter_getx_template/core/base/base_tab/base_tab_logic.dart';

import '../states/base_tab_demo_state.dart';

class BaseTabDemoLogic extends BaseTabLogic {
  final BaseTabDemoState baseTabDemoState = BaseTabDemoState();

  @override
  List<String> get tabList => ["标签页 1", "标签页 2", "标签页 3"];
}
