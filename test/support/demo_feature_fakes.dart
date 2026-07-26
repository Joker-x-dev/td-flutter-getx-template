import 'package:flutter_kit/core/database/datasource/demo/demo_local_data_source.dart';
import 'package:flutter_kit/core/database/entity/demo_entity.dart';
import 'package:flutter_kit/core/datastore/datasource/userinfo/user_info_store_data_source.dart';
import 'package:flutter_kit/core/model/entity/goods/goods.dart';
import 'package:flutter_kit/core/model/entity/user/user.dart';
import 'package:flutter_kit/core/model/request/goods_search_request.dart';
import 'package:flutter_kit/core/model/response/base/base_list_response.dart';
import 'package:flutter_kit/core/model/response/base/base_response.dart';
import 'package:flutter_kit/core/network/datasource/goods/goods_network_data_source.dart';

/// Demo Feature 测试使用的类型安全 Fake DataSource。

/// Fake 商品网络数据源。
class DemoFeatureGoodsDataSource implements GoodsNetworkDataSource {
  /// 创建 Fake 商品网络数据源。
  ///
  /// [detailHandler] 商品详情请求处理器。
  /// [pageHandler] 商品分页请求处理器。
  DemoFeatureGoodsDataSource({this.detailHandler, this.pageHandler});

  /// 商品详情请求处理器。
  final Future<BaseResponse<Goods>> Function(int id)? detailHandler;

  /// 商品分页请求处理器。
  final Future<BaseResponse<BaseListResponse<Goods>>> Function(
    GoodsSearchRequest request,
  )?
  pageHandler;

  /// 最近一次详情商品 ID。
  int? detailId;

  /// 最近一次分页请求。
  GoodsSearchRequest? pageRequest;

  /// 返回商品详情响应。
  @override
  Future<BaseResponse<Goods>> getGoodsInfo(int id) async {
    detailId = id;
    final handler = detailHandler;
    if (handler != null) {
      return handler(id);
    }
    return BaseResponse<Goods>(
      data: Goods(id: id, title: '商品$id'),
    );
  }

  /// 返回商品分页响应。
  @override
  Future<BaseResponse<BaseListResponse<Goods>>> getGoodsPage(
    GoodsSearchRequest request,
  ) async {
    pageRequest = request;
    final handler = pageHandler;
    if (handler != null) {
      return handler(request);
    }
    return BaseResponse<BaseListResponse<Goods>>(
      data: BaseListResponse<Goods>(
        list: const <Goods>[Goods(id: 1, title: '分页商品')],
      ),
    );
  }
}

/// 内存 Demo 本地数据源。
class DemoFeatureLocalDataSource implements DemoLocalDataSource {
  /// 内存记录列表。
  final List<DemoEntity> items = <DemoEntity>[];

  /// 下一条记录主键。
  int nextId = 1;

  /// 清空内存记录。
  @override
  Future<int> clearAll() async {
    final count = items.length;
    items.clear();
    return count;
  }

  /// 创建内存记录。
  @override
  Future<int> createItem(String title, {String? description}) async {
    final id = nextId++;
    items.add(DemoEntity(id: id, title: title, description: description));
    return id;
  }

  /// 按主键删除内存记录。
  @override
  Future<void> deleteById(int id) async {
    items.removeWhere((item) => item.id == id);
  }

  /// 返回全部内存记录。
  @override
  Future<List<DemoEntity>> getAllItems() async => List<DemoEntity>.of(items);

  /// 按主键返回内存记录。
  @override
  Future<DemoEntity?> getItemById(int id) async {
    for (final item in items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  /// 更新内存记录。
  @override
  Future<void> updateItem(DemoEntity entity) async {
    final index = items.indexWhere((item) => item.id == entity.id);
    if (index >= 0) {
      items[index] = entity;
    }
  }
}

/// 内存用户信息存储数据源。
class DemoFeatureUserStoreDataSource implements UserInfoStoreDataSource {
  /// 当前用户信息。
  User? user;

  /// 清除用户信息。
  @override
  Future<void> clearUserInfo() async {
    user = null;
  }

  /// 返回用户头像。
  @override
  Future<String?> getAvatarUrl() async => user?.avatarUrl;

  /// 返回用户昵称。
  @override
  Future<String?> getNickName() async => user?.nickName;

  /// 返回用户 ID。
  @override
  Future<int> getUserId() async => user?.id ?? 0;

  /// 返回用户信息。
  @override
  Future<User?> getUserInfo() async => user;

  /// 保存用户信息。
  @override
  Future<void> saveUserInfo(User user) async {
    this.user = user;
  }

  /// 更新用户信息字段。
  @override
  Future<void> updateUserInfo(Map<String, dynamic> updates) async {
    final current = user;
    if (current == null) {
      return;
    }
    user = User.fromJson(<String, dynamic>{...current.toJson(), ...updates});
  }
}
