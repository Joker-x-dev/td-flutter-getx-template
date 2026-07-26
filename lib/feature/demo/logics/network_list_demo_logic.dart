import 'package:flutter_kit/core/base/base_list/base_list_logic.dart';
import 'package:flutter_kit/core/data/repository/goods_repository.dart';
import 'package:flutter_kit/core/model/entity/goods/goods.dart';
import 'package:flutter_kit/core/model/request/goods_search_request.dart';
import 'package:flutter_kit/core/model/response/base/base_list_response.dart';
import 'package:flutter_kit/core/model/response/base/base_response.dart';

import '../states/network_list_demo_state.dart';

/// 网络列表示例页 Logic
///
/// 通过 [BaseListLogic] 加载商品分页数据。
class NetworkListDemoLogic extends BaseListLogic<Goods> {
  /// 创建网络列表示例页 Logic
  ///
  /// [goodsRepository] 可选商品仓库，测试与预览可注入隔离实现。
  NetworkListDemoLogic({GoodsRepository? goodsRepository})
    : _goodsRepository = goodsRepository ?? GoodsRepository();

  /// 网络列表示例页状态
  final NetworkListDemoState networkListDemoState = NetworkListDemoState();

  /// 分页父类复用页面声明的 State
  @override
  NetworkListDemoState get listState => networkListDemoState;

  /// 商品数据仓库
  final GoodsRepository _goodsRepository;

  /// 商品分页请求
  @override
  Future<BaseResponse<BaseListResponse<Goods>>> Function()? get apiRequest =>
      () => _goodsRepository.getGoodsPage(
        GoodsSearchRequest(
          page: listState.currentPage,
          size: listState.pageSize,
        ),
      );
}
