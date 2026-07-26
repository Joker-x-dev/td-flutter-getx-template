import 'dart:convert';

import '../../../model/entity/user/user.dart';
import '../../../util/storage/storage_util.dart';
import 'user_info_store_data_source.dart';

/// 用户信息本地数据源实现
///
/// 基于 [StorageUtil] 持久化用户信息 JSON。
class UserInfoStoreDataSourceImpl implements UserInfoStoreDataSource {
  /// 用户信息存储键
  static const String _userInfoKey = 'user_info';

  /// 保存用户信息
  ///
  /// [user] 待持久化的用户信息。
  @override
  Future<void> saveUserInfo(User user) async {
    await StorageUtil.setString(_userInfoKey, jsonEncode(user.toJson()));
  }

  /// 读取用户信息
  ///
  /// 返回解析后的用户信息；数据不存在或解析失败时返回 `null`。
  @override
  Future<User?> getUserInfo() async {
    final jsonString = StorageUtil.getString(_userInfoKey);
    if (jsonString.isEmpty) {
      return null;
    }

    try {
      return User.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
    } on Object {
      return null;
    }
  }

  /// 更新用户信息中的指定字段
  ///
  /// [updates] 字段更新映射；值为 `null` 时删除对应字段。
  @override
  Future<void> updateUserInfo(Map<String, dynamic> updates) async {
    final jsonString = StorageUtil.getString(_userInfoKey);
    if (jsonString.isEmpty) {
      return;
    }

    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      updates.forEach((key, value) {
        if (value == null) {
          map.remove(key);
        } else {
          map[key] = value;
        }
      });

      await StorageUtil.setString(_userInfoKey, jsonEncode(map));
    } on Object {
      // 更新失败时保留原始数据
    }
  }

  /// 清除用户信息
  @override
  Future<void> clearUserInfo() async {
    await StorageUtil.delete(_userInfoKey);
  }

  /// 读取用户 ID
  ///
  /// 用户信息不存在时返回 `0`。
  @override
  Future<int> getUserId() async {
    final user = await getUserInfo();
    return user?.id ?? 0;
  }

  /// 读取用户昵称
  @override
  Future<String?> getNickName() async {
    final user = await getUserInfo();
    return user?.nickName;
  }

  /// 读取用户头像 URL
  @override
  Future<String?> getAvatarUrl() async {
    final user = await getUserInfo();
    return user?.avatarUrl;
  }
}
