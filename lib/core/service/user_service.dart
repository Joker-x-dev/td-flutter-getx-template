import 'package:get/get.dart';

import '../data/repository/auth_store_repository.dart';
import '../data/repository/user_info_store_repository.dart';
import '../data/repository/user_repository.dart';
import '../model/entity/auth/auth.dart';
import '../model/entity/user/user.dart';
import '../result/request_helper.dart';

/// 用户状态服务
///
/// 管理应用全局用户状态，包括登录状态、认证信息、用户信息，
/// 并通过 [AuthStoreRepository] 与 [UserInfoStoreRepository] 持久化到本地。
class UserService extends GetxService {
  /// 是否已登录
  final RxBool isLoggedIn = false.obs;

  /// 当前用户 ID
  final RxInt userId = 0.obs;

  /// 当前认证信息
  final Rx<Auth?> auth = Rx<Auth?>(null);

  /// 当前用户信息
  final Rx<User?> userInfo = Rx<User?>(null);

  /// 认证信息本地存储仓库
  final AuthStoreRepository _authStoreRepository;

  /// 用户信息本地存储仓库
  final UserInfoStoreRepository _userInfoStoreRepository;

  /// 用户网络数据仓库
  final UserRepository _userRepository;

  /// 构造函数
  ///
  /// [authStoreRepository]、[userInfoStoreRepository]、[userRepository] 可选，
  /// 未传入时自动创建默认实现。
  UserService({
    AuthStoreRepository? authStoreRepository,
    UserInfoStoreRepository? userInfoStoreRepository,
    UserRepository? userRepository,
  }) : _authStoreRepository = authStoreRepository ?? AuthStoreRepository(),
       _userInfoStoreRepository =
           userInfoStoreRepository ?? UserInfoStoreRepository(),
       _userRepository = userRepository ?? UserRepository();

  /// 从本地存储初始化用户状态
  ///
  /// 应在应用启动时调用一次。
  Future<void> initialize() async {
    final loggedIn = await _authStoreRepository.isLoggedIn();
    if (!loggedIn) {
      isLoggedIn.value = false;
      auth.value = null;
      userInfo.value = null;
      userId.value = 0;
      return;
    }

    final storedAuth = await _authStoreRepository.getAuth();
    final user = await _userInfoStoreRepository.getUserInfo();

    // 仓库读取全部成功后再提交内存状态，避免初始化失败产生部分更新。
    isLoggedIn.value = true;
    auth.value = storedAuth;
    userInfo.value = user;
    userId.value = user?.id ?? 0;
  }

  /// 更新登录状态并持久化认证信息与用户信息
  ///
  /// [auth] 登录后获取的认证信息
  /// [user] 登录后获取的用户信息
  Future<void> updateUserState(Auth auth, User user) async {
    await _authStoreRepository.saveAuth(auth);
    await _userInfoStoreRepository.saveUserInfo(user);

    this.auth.value = auth;
    userInfo.value = user;
    userId.value = user.id;
    isLoggedIn.value = true;
  }

  /// 更新用户信息并持久化
  ///
  /// [user] 新的用户信息
  Future<void> updateUserInfo(User user) async {
    await _userInfoStoreRepository.saveUserInfo(user);

    userInfo.value = user;
    userId.value = user.id;
  }

  /// 更新认证信息并持久化
  ///
  /// [auth] 新的认证信息，例如 token 刷新后
  Future<void> updateAuth(Auth auth) async {
    await _authStoreRepository.saveAuth(auth);

    this.auth.value = auth;
    isLoggedIn.value = true;
  }

  /// 用户登出
  ///
  /// 清除本地存储的认证信息、用户信息，并重置内存状态。
  Future<void> logout() async {
    Object? clearError;
    StackTrace? clearStackTrace;
    try {
      await _authStoreRepository.clearAuth();
    } on Object catch (error, stackTrace) {
      clearError = error;
      clearStackTrace = stackTrace;
    }
    try {
      await _userInfoStoreRepository.clearUserInfo();
    } on Object catch (error, stackTrace) {
      clearError ??= error;
      clearStackTrace ??= stackTrace;
    }

    isLoggedIn.value = false;
    auth.value = null;
    userInfo.value = null;
    userId.value = 0;

    if (clearError != null) {
      Error.throwWithStackTrace(clearError, clearStackTrace!);
    }
  }

  /// 判断当前访问令牌是否需要刷新
  Future<bool> shouldRefreshToken() async {
    return _authStoreRepository.shouldRefreshToken();
  }

  /// 从网络刷新用户信息并更新状态
  Future<void> refreshUserInfo() async {
    if (!isLoggedIn.value) {
      return;
    }

    final user = await RequestHelper.repository<User>(
      _userRepository.getPersonInfo(),
    ).execute();

    if (user != null) {
      await updateUserInfo(user);
    }
  }
}
