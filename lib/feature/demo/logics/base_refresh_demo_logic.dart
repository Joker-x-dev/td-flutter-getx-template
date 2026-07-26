import 'package:flutter_kit/core/base/base_refresh/base_refresh_logic.dart';
import 'package:flutter_kit/core/data/repository/goods_repository.dart';
import 'package:flutter_kit/core/model/entity/goods/goods.dart';
import 'package:flutter_kit/core/model/response/base/base_response.dart';

import '../states/base_refresh_demo_state.dart';

/// BaseRefresh 示例页 Logic
///
/// 使用 [BaseRefreshLogic] 加载商品详情。
class BaseRefreshDemoLogic extends BaseRefreshLogic<Goods> {
  /// 创建 BaseRefresh 示例页 Logic
  ///
  /// [goodsRepository] 可选商品仓库，测试与预览可注入隔离实现。
  BaseRefreshDemoLogic({GoodsRepository? goodsRepository})
    : _goodsRepository = goodsRepository ?? GoodsRepository();

  /// BaseRefresh 示例页状态
  final BaseRefreshDemoState baseRefreshDemoState = BaseRefreshDemoState();

  /// 刷新父类复用页面声明的 State
  @override
  BaseRefreshDemoState get refreshState => baseRefreshDemoState;

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
  void requestOk(Goods data) => baseRefreshDemoState.goods.value = data;
}
