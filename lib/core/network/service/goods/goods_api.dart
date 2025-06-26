import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../model/common/id.dart';
import '../../../model/entity/goods/goods.dart';
import '../../../model/request/goods_search_request.dart';
import '../../../model/response/base/base_list_response.dart';
import '../../../model/response/base/base_response.dart';

part 'goods_api.g.dart';

/// 商品相关接口
@RestApi(baseUrl: 'goods/info')
abstract class GoodsApi {
  factory GoodsApi(Dio dio, {String baseUrl}) = _GoodsApi;

  /// 分页查询商品
  @POST('/page')
  Future<BaseResponse<BaseListResponse<Goods>>> getGoodsPage(
    @Body() GoodsSearchRequest request,
  );

  /// 商品信息
  @GET('/info')
  Future<BaseResponse<Goods>> getGoodsInfo(@Query('id') Id id);
}
