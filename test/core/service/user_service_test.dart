import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/data/repository/auth_store_repository.dart';
import 'package:flutter_kit/core/data/repository/user_info_store_repository.dart';
import 'package:flutter_kit/core/data/repository/user_repository.dart';
import 'package:flutter_kit/core/datastore/datasource/auth/auth_store_data_source.dart';
import 'package:flutter_kit/core/datastore/datasource/userinfo/user_info_store_data_source.dart';
import 'package:flutter_kit/core/model/entity/auth/auth.dart';
import 'package:flutter_kit/core/model/entity/user/user.dart';
import 'package:flutter_kit/core/model/response/base/base_response.dart';
import 'package:flutter_kit/core/network/datasource/user/user_network_data_source.dart';
import 'package:flutter_kit/core/service/user_service.dart';

/// UserService 内存状态、持久化和网络刷新测试。
void main() {
  late _MemoryAuthStoreDataSource authDataSource;
  late _MemoryUserStoreDataSource userDataSource;

  setUp(() {
    authDataSource = _MemoryAuthStoreDataSource();
    userDataSource = _MemoryUserStoreDataSource();
  });

  test('无本地数据时初始化为未登录', () async {
    final UserService service = _createService(authDataSource, userDataSource);

    await service.initialize();

    expect(service.isLoggedIn.value, isFalse);
    expect(service.auth.value, isNull);
    expect(service.userInfo.value, isNull);
    expect(service.userId.value, 0);
  });

  test('从本地认证和用户数据恢复完整登录状态', () async {
    authDataSource.auth = const Auth(token: 'token', refreshToken: 'refresh');
    userDataSource.user = const User(id: 9, unionid: 'u9');
    final UserService service = _createService(authDataSource, userDataSource);

    await service.initialize();

    expect(service.isLoggedIn.value, isTrue);
    expect(service.auth.value?.token, 'token');
    expect(service.userInfo.value?.id, 9);
    expect(service.userId.value, 9);
  });

  test('仅恢复认证时用户 ID 保持零', () async {
    authDataSource.auth = const Auth(token: 'token', refreshToken: 'refresh');
    final UserService service = _createService(authDataSource, userDataSource);

    await service.initialize();

    expect(service.isLoggedIn.value, isTrue);
    expect(service.userInfo.value, isNull);
    expect(service.userId.value, 0);
  });

  test('重复初始化切换到未登录时清除全部旧状态', () async {
    authDataSource.auth = const Auth(token: 'token', refreshToken: 'refresh');
    userDataSource.user = const User(id: 9, unionid: 'u9');
    final UserService service = _createService(authDataSource, userDataSource);
    await service.initialize();

    authDataSource.auth = null;
    await service.initialize();

    expect(service.isLoggedIn.value, isFalse);
    expect(service.auth.value, isNull);
    expect(service.userInfo.value, isNull);
    expect(service.userId.value, 0);
  });

  test('初始化读取用户失败时保留原有完整状态', () async {
    final UserService service = _createService(authDataSource, userDataSource);
    const Auth oldAuth = Auth(token: 'old-token', refreshToken: 'old-refresh');
    const User oldUser = User(id: 1, unionid: 'old-user');
    await service.updateUserState(oldAuth, oldUser);
    authDataSource.auth = const Auth(
      token: 'new-token',
      refreshToken: 'new-refresh',
    );
    userDataSource.getError = StateError('读取用户失败');

    await expectLater(service.initialize(), throwsA(isA<StateError>()));

    expect(service.isLoggedIn.value, isTrue);
    expect(service.auth.value, same(oldAuth));
    expect(service.userInfo.value, same(oldUser));
    expect(service.userId.value, 1);
  });

  test('updateUserState 同步更新持久化与内存状态', () async {
    final UserService service = _createService(authDataSource, userDataSource);
    const Auth auth = Auth(token: 'token', refreshToken: 'refresh');
    const User user = User(id: 3, unionid: 'u3');

    await service.updateUserState(auth, user);

    expect(authDataSource.auth, same(auth));
    expect(userDataSource.user, same(user));
    expect(service.isLoggedIn.value, isTrue);
    expect(service.userId.value, 3);
  });

  test('updateAuth 与 updateUserInfo 分别更新对应状态', () async {
    final UserService service = _createService(authDataSource, userDataSource);
    const Auth auth = Auth(token: 'new-token', refreshToken: 'refresh');
    const User user = User(id: 5, unionid: 'u5', nickName: '新用户');

    await service.updateAuth(auth);
    await service.updateUserInfo(user);

    expect(service.auth.value, same(auth));
    expect(service.isLoggedIn.value, isTrue);
    expect(service.userInfo.value, same(user));
    expect(service.userId.value, 5);
  });

  test('持久化失败时更新方法不提前污染内存状态', () async {
    final UserService service = _createService(authDataSource, userDataSource);
    const Auth oldAuth = Auth(token: 'old-token', refreshToken: 'old-refresh');
    const User oldUser = User(id: 1, unionid: 'old-user');
    await service.updateUserState(oldAuth, oldUser);

    authDataSource.saveError = StateError('保存认证失败');
    await expectLater(
      service.updateAuth(
        const Auth(token: 'new-token', refreshToken: 'new-refresh'),
      ),
      throwsA(isA<StateError>()),
    );
    expect(service.auth.value, same(oldAuth));
    expect(service.isLoggedIn.value, isTrue);

    userDataSource.saveError = StateError('保存用户失败');
    await expectLater(
      service.updateUserInfo(const User(id: 2, unionid: 'new-user')),
      throwsA(isA<StateError>()),
    );
    expect(service.userInfo.value, same(oldUser));
    expect(service.userId.value, 1);
  });

  test('logout 清除持久化与全部内存状态', () async {
    final UserService service = _createService(authDataSource, userDataSource);
    await service.updateUserState(
      const Auth(token: 'token', refreshToken: 'refresh'),
      const User(id: 2, unionid: 'u2'),
    );

    await service.logout();

    expect(authDataSource.auth, isNull);
    expect(userDataSource.user, isNull);
    expect(service.isLoggedIn.value, isFalse);
    expect(service.auth.value, isNull);
    expect(service.userInfo.value, isNull);
    expect(service.userId.value, 0);
  });

  test('logout 清理部分失败时仍执行全部清理并重置内存状态', () async {
    final UserService service = _createService(authDataSource, userDataSource);
    await service.updateUserState(
      const Auth(token: 'token', refreshToken: 'refresh'),
      const User(id: 2, unionid: 'u2'),
    );
    final StateError authError = StateError('认证清理失败');
    authDataSource.clearError = authError;
    userDataSource.clearError = ArgumentError('用户清理失败');

    await expectLater(service.logout(), throwsA(same(authError)));

    expect(authDataSource.clearCallCount, 1);
    expect(userDataSource.clearCallCount, 1);
    expect(service.isLoggedIn.value, isFalse);
    expect(service.auth.value, isNull);
    expect(service.userInfo.value, isNull);
    expect(service.userId.value, 0);
  });

  test('logout 仅用户清理失败时传播该异常并保持未登录', () async {
    final UserService service = _createService(authDataSource, userDataSource);
    await service.updateUserState(
      const Auth(token: 'token', refreshToken: 'refresh'),
      const User(id: 2, unionid: 'u2'),
    );
    final StateError userError = StateError('用户清理失败');
    userDataSource.clearError = userError;

    await expectLater(service.logout(), throwsA(same(userError)));

    expect(authDataSource.clearCallCount, 1);
    expect(userDataSource.clearCallCount, 1);
    expect(service.isLoggedIn.value, isFalse);
  });

  test('shouldRefreshToken 委托认证仓库', () async {
    authDataSource.shouldRefresh = true;
    final UserService service = _createService(authDataSource, userDataSource);

    expect(await service.shouldRefreshToken(), isTrue);
  });

  test('未登录时刷新用户不调用网络', () async {
    final _FakeUserNetworkDataSource network = _FakeUserNetworkDataSource();
    final UserService service = _createService(
      authDataSource,
      userDataSource,
      network: network,
    );

    await service.refreshUserInfo();

    expect(network.callCount, 0);
  });

  test('登录后刷新用户并持久化新信息', () async {
    final _FakeUserNetworkDataSource network = _FakeUserNetworkDataSource();
    final UserService service = _createService(
      authDataSource,
      userDataSource,
      network: network,
    );
    await service.updateAuth(
      const Auth(token: 'token', refreshToken: 'refresh'),
    );

    await service.refreshUserInfo();

    expect(network.callCount, 1);
    expect(service.userInfo.value?.id, 99);
    expect(userDataSource.user?.nickName, '网络用户');
  });

  test('网络刷新失败时原样传播异常且不覆盖旧用户', () async {
    final _FakeUserNetworkDataSource network = _FakeUserNetworkDataSource(
      error: Exception('刷新失败'),
    );
    final UserService service = _createService(
      authDataSource,
      userDataSource,
      network: network,
    );
    await service.updateUserState(
      const Auth(token: 'token', refreshToken: 'refresh'),
      const User(id: 1, unionid: 'old'),
    );

    await expectLater(service.refreshUserInfo(), throwsA(isA<Exception>()));
    expect(service.userInfo.value?.id, 1);
  });

  test('网络刷新返回空用户时保留旧用户且不写入存储', () async {
    final _FakeUserNetworkDataSource network = _FakeUserNetworkDataSource(
      response: BaseResponse<User>(),
    );
    final UserService service = _createService(
      authDataSource,
      userDataSource,
      network: network,
    );
    const User oldUser = User(id: 1, unionid: 'old');
    await service.updateUserState(
      const Auth(token: 'token', refreshToken: 'refresh'),
      oldUser,
    );
    final int saveCount = userDataSource.saveCallCount;

    await service.refreshUserInfo();

    expect(network.callCount, 1);
    expect(userDataSource.saveCallCount, saveCount);
    expect(service.userInfo.value, same(oldUser));
  });
}

/// 创建注入内存依赖的 UserService。
UserService _createService(
  _MemoryAuthStoreDataSource authDataSource,
  _MemoryUserStoreDataSource userDataSource, {
  _FakeUserNetworkDataSource? network,
}) {
  return UserService(
    authStoreRepository: AuthStoreRepository(dataSource: authDataSource),
    userInfoStoreRepository: UserInfoStoreRepository(
      dataSource: userDataSource,
    ),
    userRepository: UserRepository(
      dataSource: network ?? _FakeUserNetworkDataSource(),
    ),
  );
}

/// 内存认证存储数据源。
class _MemoryAuthStoreDataSource implements AuthStoreDataSource {
  /// 认证信息。
  Auth? auth;

  /// 刷新判断结果。
  bool shouldRefresh = false;

  /// 保存认证信息时抛出的错误。
  Object? saveError;

  /// 清除认证信息时抛出的错误。
  Object? clearError;

  /// 清除认证信息调用次数。
  int clearCallCount = 0;

  /// 清除认证信息。
  @override
  Future<void> clearAuth() async {
    clearCallCount++;
    if (clearError case final Object error) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }
    auth = null;
  }

  /// 读取认证信息。
  @override
  Future<Auth?> getAuth() async => auth;

  /// 读取 Token。
  @override
  Future<String?> getToken() async => auth?.token;

  /// 判断登录状态。
  @override
  Future<bool> isLoggedIn() async => auth?.token.isNotEmpty ?? false;

  /// 保存认证信息。
  @override
  Future<void> saveAuth(Auth auth) async {
    if (saveError case final Object error) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }
    this.auth = auth;
  }

  /// 返回刷新判断结果。
  @override
  Future<bool> shouldRefreshToken() async => shouldRefresh;
}

/// 内存用户存储数据源。
class _MemoryUserStoreDataSource implements UserInfoStoreDataSource {
  /// 用户信息。
  User? user;

  /// 读取用户信息时抛出的错误。
  Object? getError;

  /// 保存用户信息时抛出的错误。
  Object? saveError;

  /// 清除用户信息时抛出的错误。
  Object? clearError;

  /// 保存用户信息调用次数。
  int saveCallCount = 0;

  /// 清除用户信息调用次数。
  int clearCallCount = 0;

  /// 清除用户信息。
  @override
  Future<void> clearUserInfo() async {
    clearCallCount++;
    if (clearError case final Object error) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }
    user = null;
  }

  /// 读取头像。
  @override
  Future<String?> getAvatarUrl() async => user?.avatarUrl;

  /// 读取昵称。
  @override
  Future<String?> getNickName() async => user?.nickName;

  /// 读取用户 ID。
  @override
  Future<int> getUserId() async => user?.id ?? 0;

  /// 读取用户信息。
  @override
  Future<User?> getUserInfo() async {
    if (getError case final Object error) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }
    return user;
  }

  /// 保存用户信息。
  @override
  Future<void> saveUserInfo(User user) async {
    saveCallCount++;
    if (saveError case final Object error) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }
    this.user = user;
  }

  /// 更新用户信息。
  @override
  Future<void> updateUserInfo(Map<String, dynamic> updates) async {}
}

/// Fake 用户网络数据源。
class _FakeUserNetworkDataSource implements UserNetworkDataSource {
  /// 创建 Fake 用户网络数据源。
  _FakeUserNetworkDataSource({this.error, this.response});

  /// 可选异常。
  final Object? error;

  /// 可选响应。
  final BaseResponse<User>? response;

  /// 调用次数。
  int callCount = 0;

  /// 返回用户信息或抛出异常。
  @override
  Future<BaseResponse<User>> getPersonInfo() async {
    callCount++;
    if (error case final Object error) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }
    return response ??
        BaseResponse<User>(
          data: const User(id: 99, unionid: 'network', nickName: '网络用户'),
        );
  }
}
