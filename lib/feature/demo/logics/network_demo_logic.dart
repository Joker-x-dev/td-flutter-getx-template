import 'package:flutter_kit/core/base/base_network/base_network_logic.dart';
import 'package:flutter_kit/core/data/repository/goods_repository.dart';
import 'package:flutter_kit/core/model/entity/goods/goods.dart';
import 'package:flutter_kit/core/model/response/base/base_response.dart';

import '../states/network_demo_state.dart';

/// 网络请求示例页 Logic
///
/// 通过 [BaseNetworkLogic] 自动加载商品详情。
class NetworkDemoLogic extends BaseNetworkLogic<Goods> {
  /// 创建网络请求示例页 Logic
  ///
  /// [goodsRepository] 可选商品仓库，测试与预览可注入隔离实现。
  NetworkDemoLogic({GoodsRepository? goodsRepository})
    : _goodsRepository = goodsRepository ?? GoodsRepository();

  /// 网络请求示例页状态
  final NetworkDemoState networkDemoState = NetworkDemoState();

  /// 网络父类复用页面声明的 State
  @override
  NetworkDemoState get networkState => networkDemoState;

  /// 商品数据仓库
  final GoodsRepository _goodsRepository;

  /// 商品详情请求
  @override
  Future<BaseResponse<Goods>> Function()? get apiRequest =>
      () => _goodsRepository.getGoodsInfo(1);

  /// 保存商品详情请求结果
  ///
  /// [data] 商品详情数据。
  @override
  void requestOk(Goods data) => networkDemoState.goods.value = data;
}
