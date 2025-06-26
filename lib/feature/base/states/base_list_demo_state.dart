import 'package:td_flutter_getx_template/core/model/entity/goods/goods.dart';

import '../../../core/base/base_list/base_list_state.dart';

class BaseListDemoState extends BaseListState<Goods> {
  @override
  int get pageSize => 10;
}
