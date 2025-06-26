import 'package:td_flutter_getx_template/core/base/base_list/base_list_logic.dart';
import 'package:td_flutter_getx_template/core/network/service/api_service.dart';

import '../../../core/model/entity/goods/goods.dart';
import '../../../core/model/request/goods_search_request.dart';
import '../../../core/model/response/base/base_list_response.dart';
import '../../../core/model/response/base/base_response.dart';
import '../states/base_list_demo_state.dart';

class BaseListDemoLogic extends BaseListLogic<Goods> {
  final BaseListDemoState baseListDemoState = BaseListDemoState();

  @override
  Future<BaseResponse<BaseListResponse<Goods>>> Function()? get apiRequest =>
      () => ApiService.goodsApi().getGoodsPage(
        GoodsSearchRequest(
          page: baseListDemoState.currentPage,
          size: baseListDemoState.pageSize,
        ),
      );
}
