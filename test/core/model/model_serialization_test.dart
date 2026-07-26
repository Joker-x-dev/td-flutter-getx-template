import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/config/app_config.dart';
import 'package:flutter_kit/core/model/common/base_entity.dart';
import 'package:flutter_kit/core/model/common/id.dart';
import 'package:flutter_kit/core/model/entity/auth/auth.dart';
import 'package:flutter_kit/core/model/entity/goods/goods.dart';
import 'package:flutter_kit/core/model/entity/goods/goods_spec.dart';
import 'package:flutter_kit/core/model/entity/user/user.dart';
import 'package:flutter_kit/core/model/request/goods_search_request.dart';
import 'package:flutter_kit/core/model/request/login_request.dart';
import 'package:flutter_kit/core/model/request/page_request.dart';
import 'package:flutter_kit/core/model/response/base/base_list_response.dart';
import 'package:flutter_kit/core/model/response/base/base_response.dart';

/// Core 模型默认值与 JSON 契约测试。
void main() {
  group('基础模型', () {
    test('Id 与 BaseEntity 保持默认值并支持 JSON 往返', () {
      const Id id = Id();
      const BaseEntity entity = BaseEntity(
        id: 7,
        createTime: '2026-01-01',
        updateTime: '2026-01-02',
      );

      expect(id.id, 0);
      expect(Id.fromJson(id.toJson()).id, 0);
      expect(BaseEntity.fromJson(entity.toJson()).id, 7);
      expect(BaseEntity.fromJson(entity.toJson()).updateTime, '2026-01-02');
    });
  });

  group('请求模型', () {
    test('分页与登录请求保持默认值并支持 JSON 往返', () {
      const PageRequest page = PageRequest();
      const LoginRequest login = LoginRequest(
        phone: '13800000000',
        password: 'secret',
      );

      expect(page.toJson(), <String, Object>{'page': 1, 'size': 10});
      expect(PageRequest.fromJson(page.toJson()).size, 10);
      expect(LoginRequest.fromJson(login.toJson()).phone, '13800000000');
      expect(login.toJson()['password'], 'secret');
    });

    test('商品搜索请求不序列化空筛选字段', () {
      const GoodsSearchRequest request = GoodsSearchRequest(page: 2, size: 20);

      expect(request.toJson(), <String, Object>{'page': 2, 'size': 20});
    });

    test('商品搜索请求完整保留筛选与排序字段', () {
      const GoodsSearchRequest request = GoodsSearchRequest(
        page: 3,
        size: 15,
        typeId: <int>[1, 2],
        minPrice: '10',
        maxPrice: '99',
        keyWord: '手机',
        order: 'sold',
        sort: 'desc',
        recommend: true,
        featured: false,
      );

      final GoodsSearchRequest restored = GoodsSearchRequest.fromJson(
        request.toJson(),
      );
      expect(restored.typeId, <int>[1, 2]);
      expect(restored.keyWord, '手机');
      expect(restored.recommend, isTrue);
      expect(restored.featured, isFalse);
    });
  });

  group('实体模型', () {
    test('Auth 支持 JSON 往返并判断令牌有效期', () {
      final int now = DateTime.now().millisecondsSinceEpoch;
      final Auth valid = Auth(
        token: 'token',
        refreshToken: 'refresh',
        expire: 3600,
        refreshExpire: 7200,
        createdAt: now,
      );
      final Auth expired = Auth(
        token: 'token',
        refreshToken: 'refresh',
        expire: 1,
        refreshExpire: 1,
        createdAt: now - 5000,
      );

      expect(Auth.fromJson(valid.toJson()).token, 'token');
      expect(valid.isExpired, isFalse);
      expect(valid.isRefreshTokenExpired, isFalse);
      expect(valid.shouldRefresh, isFalse);
      expect(expired.isExpired, isTrue);
      expect(expired.isRefreshTokenExpired, isTrue);
      expect(expired.shouldRefresh, isFalse);
    });

    test('Auth 在访问令牌刷新窗口内返回需要刷新', () {
      final int now = DateTime.now().millisecondsSinceEpoch;
      final Auth auth = Auth(
        token: 'token',
        refreshToken: 'refresh',
        expire: 1200,
        refreshExpire: 7200,
        createdAt: now - const Duration(minutes: 10).inMilliseconds,
      );

      expect(auth.shouldRefresh, isTrue);
    });

    test('User 完整保留继承字段和可空字段', () {
      const User user = User(
        id: 9,
        unionid: 'union-9',
        avatarUrl: 'avatar.png',
        nickName: 'FlutterKit',
        phone: '13800000000',
        gender: 1,
        status: 1,
        loginType: '2',
        createTime: 'created',
        updateTime: 'updated',
      );

      final User restored = User.fromJson(user.toJson());
      expect(restored.id, 9);
      expect(restored.unionid, 'union-9');
      expect(restored.avatarUrl, 'avatar.png');
      expect(restored.updateTime, 'updated');
    });

    test('Goods 与 GoodsSpec 支持嵌套 JSON 往返', () {
      const GoodsSpec spec = GoodsSpec(
        id: 2,
        goodsId: 1,
        name: '黑色',
        price: 199,
        stock: 5,
        sortNum: 1,
        images: <String>['spec.png'],
      );
      const Goods goods = Goods(
        id: 1,
        typeId: 3,
        title: '商品',
        mainPic: 'main.png',
        pics: <String>['one.png'],
        price: 199,
        sold: 10,
        contentPics: <String>['detail.png'],
        recommend: true,
        featured: true,
        status: 1,
        sortNum: 2,
        specs: <GoodsSpec>[spec],
      );

      final Goods restored = Goods.fromJson(goods.toJson());
      expect(restored.title, '商品');
      expect(restored.specs, hasLength(1));
      expect(restored.specs?.first.stock, 5);
      expect(GoodsSpec.fromJson(spec.toJson()).images, <String>['spec.png']);
    });
  });

  group('响应模型', () {
    test('BaseResponse 使用全局成功码并支持泛型 JSON', () {
      final BaseResponse<User> response = BaseResponse<User>(
        data: const User(id: 3, unionid: 'u3'),
        message: 'ok',
      );

      final Map<String, dynamic> json = response.toJson(
        (User value) => value.toJson(),
      );
      final BaseResponse<User> restored = BaseResponse<User>.fromJson(
        json,
        (Object? value) => User.fromJson(value! as Map<String, dynamic>),
      );
      expect(response.code, AppConfig.successCode);
      expect(response.isSucceeded, isTrue);
      expect(restored.data?.id, 3);
      expect(BaseResponse<void>(code: 400).isSucceeded, isFalse);
    });

    test('分页响应和分页元数据支持泛型 JSON', () {
      final BaseListResponse<int> response = BaseListResponse<int>(
        list: <int>[1, 2],
        pagination: PageMeta(total: 5, size: 2, page: 1),
      );

      final Map<String, dynamic> json = response.toJson((int value) => value);
      final BaseListResponse<int> restored = BaseListResponse<int>.fromJson(
        json,
        (Object? value) => value! as int,
      );
      expect(restored.list, <int>[1, 2]);
      expect(restored.pagination?.total, 5);
      expect(PageMeta.fromJson(restored.pagination!.toJson()).page, 1);
    });

    test('分页响应允许列表与分页信息为空', () {
      final BaseListResponse<String> response = BaseListResponse<String>();

      expect(response.list, isNull);
      expect(response.pagination, isNull);
    });
  });
}
