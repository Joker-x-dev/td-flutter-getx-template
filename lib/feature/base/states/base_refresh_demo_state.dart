import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:td_flutter_getx_template/core/model/entity/goods/goods.dart';

import '../../../core/base/base_refresh/base_refresh_state.dart';

class BaseRefreshDemoState extends BaseRefreshState {
  /// 商品信息
  Rx<Goods> goods = Rx<Goods>(Goods());
}
