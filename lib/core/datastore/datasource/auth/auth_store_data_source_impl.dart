import 'dart:convert';

import '../../../model/entity/auth/auth.dart';
import '../../../util/storage/storage_util.dart';
import 'auth_store_data_source.dart';

/// 认证信息本地数据源实现
///
/// 基于 [StorageUtil] 持久化认证信息 JSON。
class AuthStoreDataSourceImpl implements AuthStoreDataSource {
  /// 认证信息存储键
  static const String _authInfoKey = 'auth_info';

  /// 保存认证信息
  ///
  /// [auth] 待持久化的认证信息；创建时间为空时使用当前时间。
  @override
  Future<void> saveAuth(Auth auth) async {
    final effectiveAuth = auth.createdAt == 0
        ? Auth(
            token: auth.token,
            refreshToken: auth.refreshToken,
            expire: auth.expire,
            refreshExpire: auth.refreshExpire,
            createdAt: DateTime.now().millisecondsSinceEpoch,
          )
        : auth;

    await StorageUtil.setString(
      _authInfoKey,
      jsonEncode(effectiveAuth.toJson()),
    );
  }

  /// 读取认证信息
  ///
  /// 返回解析后的认证信息；数据不存在或解析失败时返回 `null`。
  @override
  Future<Auth?> getAuth() async {
    final jsonString = StorageUtil.getString(_authInfoKey);
    if (jsonString.isEmpty) {
      return null;
    }

    try {
      return Auth.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
    } on Object {
      return null;
    }
  }

  /// 读取访问令牌
  ///
  /// 返回当前访问令牌；认证信息不存在时返回 `null`。
  @override
  Future<String?> getToken() async {
    final auth = await getAuth();
    return auth?.token;
  }

  /// 清除认证信息
  @override
  Future<void> clearAuth() async {
    await StorageUtil.delete(_authInfoKey);
  }

  /// 检查当前登录状态
  ///
  /// 访问令牌存在且未过期时返回 `true`。
  @override
  Future<bool> isLoggedIn() async {
    final auth = await getAuth();
    return auth != null && auth.token.isNotEmpty && !auth.isExpired;
  }

  /// 判断访问令牌是否需要刷新
  @override
  Future<bool> shouldRefreshToken() async {
    final auth = await getAuth();
    return auth?.shouldRefresh ?? false;
  }
}
