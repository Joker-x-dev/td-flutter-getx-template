import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/datastore/datasource/account/account_store_data_source_impl.dart';
import 'package:flutter_kit/core/datastore/datasource/auth/auth_store_data_source_impl.dart';
import 'package:flutter_kit/core/datastore/datasource/locale/locale_store_data_source_impl.dart';
import 'package:flutter_kit/core/datastore/datasource/theme/theme_store_data_source_impl.dart';
import 'package:flutter_kit/core/datastore/datasource/token/token_store_data_source_impl.dart';
import 'package:flutter_kit/core/datastore/datasource/userinfo/user_info_store_data_source_impl.dart';
import 'package:flutter_kit/core/model/entity/auth/auth.dart';
import 'package:flutter_kit/core/model/entity/user/user.dart';
import 'package:flutter_kit/core/util/storage/storage_util.dart';

import '../../support/test_environment.dart';

/// SharedPreferences DataSource 真实读写测试。
void main() {
  setUp(initializeCoreTestEnvironment);
  tearDown(resetCoreTestEnvironment);

  test('账号、密码和 Token 支持默认值、覆盖与清理', () async {
    final AccountStoreDataSourceImpl account = AccountStoreDataSourceImpl();
    final TokenStoreDataSourceImpl token = TokenStoreDataSourceImpl();

    expect(await account.getAccount(), isEmpty);
    expect(await account.getPassword(), isEmpty);
    expect(await token.getToken(), isEmpty);

    await account.setAccount('first');
    await account.setAccount('second');
    await account.setPassword('password');
    await token.setToken('token');

    expect(await account.getAccount(), 'second');
    expect(await account.getPassword(), 'password');
    expect(await token.getToken(), 'token');
    await token.clearToken();
    expect(await token.getToken(), isEmpty);
  });

  test('主题与语言支持空值和完整读写', () async {
    final ThemeStoreDataSourceImpl theme = ThemeStoreDataSourceImpl();
    final LocaleStoreDataSourceImpl locale = LocaleStoreDataSourceImpl();

    expect(await theme.getThemeModeIndex(), isNull);
    expect(await theme.getThemeColorName(), isNull);
    expect(await locale.getLocaleTag(), isNull);

    await theme.saveThemeModeIndex(2);
    await theme.saveThemeColorName('red');
    await locale.saveLocaleTag('en_US');

    expect(await theme.getThemeModeIndex(), 2);
    expect(await theme.getThemeColorName(), 'red');
    expect(await locale.getLocaleTag(), 'en_US');
  });

  test('认证信息补充创建时间并支持登录和刷新判断', () async {
    final AuthStoreDataSourceImpl dataSource = AuthStoreDataSourceImpl();
    const Auth auth = Auth(
      token: 'token',
      refreshToken: 'refresh',
      expire: 120,
      refreshExpire: 3600,
    );

    await dataSource.saveAuth(auth);
    final Auth? restored = await dataSource.getAuth();

    expect(restored?.createdAt, greaterThan(0));
    expect(await dataSource.getToken(), 'token');
    expect(await dataSource.isLoggedIn(), isTrue);
    expect(await dataSource.shouldRefreshToken(), isTrue);
    await dataSource.clearAuth();
    expect(await dataSource.getAuth(), isNull);
    expect(await dataSource.isLoggedIn(), isFalse);
  });

  test('认证信息损坏或过期时安全返回未登录', () async {
    final AuthStoreDataSourceImpl dataSource = AuthStoreDataSourceImpl();
    await StorageUtil.setString('auth_info', 'not-json');

    expect(await dataSource.getAuth(), isNull);

    final int now = DateTime.now().millisecondsSinceEpoch;
    await dataSource.saveAuth(
      Auth(
        token: 'expired',
        refreshToken: 'refresh',
        expire: 1,
        refreshExpire: 1,
        createdAt: now - 5000,
      ),
    );
    expect(await dataSource.isLoggedIn(), isFalse);
    expect(await dataSource.shouldRefreshToken(), isFalse);
  });

  test('认证信息为合法 JSON 但结构错误时安全返回空值', () async {
    final AuthStoreDataSourceImpl dataSource = AuthStoreDataSourceImpl();
    await StorageUtil.setString('auth_info', '[]');

    expect(await dataSource.getAuth(), isNull);
    expect(await dataSource.getToken(), isNull);
    expect(await dataSource.isLoggedIn(), isFalse);
    expect(await dataSource.shouldRefreshToken(), isFalse);
  });

  test('用户信息支持保存、派生字段、字段更新和字段删除', () async {
    final UserInfoStoreDataSourceImpl dataSource =
        UserInfoStoreDataSourceImpl();
    const User user = User(
      id: 6,
      unionid: 'u6',
      nickName: '旧昵称',
      avatarUrl: 'avatar.png',
    );

    expect(await dataSource.getUserInfo(), isNull);
    expect(await dataSource.getUserId(), 0);
    await dataSource.saveUserInfo(user);
    await dataSource.updateUserInfo(<String, dynamic>{
      'nickName': '新昵称',
      'avatarUrl': null,
    });

    expect(await dataSource.getUserId(), 6);
    expect(await dataSource.getNickName(), '新昵称');
    expect(await dataSource.getAvatarUrl(), isNull);
    await dataSource.clearUserInfo();
    expect(await dataSource.getUserInfo(), isNull);
  });

  test('用户信息损坏时读取和更新均保留安全结果', () async {
    final UserInfoStoreDataSourceImpl dataSource =
        UserInfoStoreDataSourceImpl();
    await StorageUtil.setString('user_info', 'not-json');

    expect(await dataSource.getUserInfo(), isNull);
    await dataSource.updateUserInfo(<String, dynamic>{'nickName': 'ignored'});
    expect(StorageUtil.getString('user_info'), 'not-json');

    await StorageUtil.setString('user_info', jsonEncode(<String, Object>{}));
    expect((await dataSource.getUserInfo())?.id, 0);
  });

  test('用户信息为合法 JSON 但结构错误时读取与更新安全回退', () async {
    final UserInfoStoreDataSourceImpl dataSource =
        UserInfoStoreDataSourceImpl();
    await StorageUtil.setString('user_info', '[]');

    expect(await dataSource.getUserInfo(), isNull);
    await dataSource.updateUserInfo(<String, dynamic>{'nickName': 'ignored'});
    expect(StorageUtil.getString('user_info'), '[]');
    expect(await dataSource.getUserId(), 0);
    expect(await dataSource.getNickName(), isNull);
    expect(await dataSource.getAvatarUrl(), isNull);
  });
}
