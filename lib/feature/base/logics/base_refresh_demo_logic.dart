import 'package:td_flutter_getx_template/core/base/base_refresh/base_refresh_logic.dart';
import 'package:td_flutter_getx_template/core/model/entity/goods/goods.dart';
import 'package:td_flutter_getx_template/core/network/service/api_service.dart';

import '../../../core/model/response/base/base_response.dart';
import '../states/base_refresh_demo_state.dart';

class BaseRefreshDemoLogic extends BaseRefreshLogic<Goods> {
  final BaseRefreshDemoState baseRefreshDemoState = BaseRefreshDemoState();

  @override
  Future<BaseResponse<Goods>> Function()? get apiRequest => () {
    return ApiService.goods.getGoodsInfo(1);
  };

  @override
  void requestOk(Goods data) => baseRefreshDemoState.goods.value = data;
}
