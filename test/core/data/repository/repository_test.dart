import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/data/repository/account_store_repository.dart';
import 'package:flutter_kit/core/data/repository/auth_repository.dart';
import 'package:flutter_kit/core/data/repository/auth_store_repository.dart';
import 'package:flutter_kit/core/data/repository/demo_repository.dart';
import 'package:flutter_kit/core/data/repository/goods_repository.dart';
import 'package:flutter_kit/core/data/repository/locale_store_repository.dart';
import 'package:flutter_kit/core/data/repository/theme_store_repository.dart';
import 'package:flutter_kit/core/data/repository/token_store_repository.dart';
import 'package:flutter_kit/core/data/repository/user_info_store_repository.dart';
import 'package:flutter_kit/core/data/repository/user_repository.dart';
import 'package:flutter_kit/core/database/datasource/demo/demo_local_data_source.dart';
import 'package:flutter_kit/core/database/entity/demo_entity.dart';
import 'package:flutter_kit/core/datastore/datasource/account/account_store_data_source.dart';
import 'package:flutter_kit/core/datastore/datasource/auth/auth_store_data_source.dart';
import 'package:flutter_kit/core/datastore/datasource/locale/locale_store_data_source.dart';
import 'package:flutter_kit/core/datastore/datasource/theme/theme_store_data_source.dart';
import 'package:flutter_kit/core/datastore/datasource/token/token_store_data_source.dart';
import 'package:flutter_kit/core/datastore/datasource/userinfo/user_info_store_data_source.dart';
import 'package:flutter_kit/core/model/entity/auth/auth.dart';
import 'package:flutter_kit/core/model/entity/goods/goods.dart';
import 'package:flutter_kit/core/model/entity/user/user.dart';
import 'package:flutter_kit/core/model/request/goods_search_request.dart';
import 'package:flutter_kit/core/model/request/login_request.dart';
import 'package:flutter_kit/core/model/response/base/base_list_response.dart';
import 'package:flutter_kit/core/model/response/base/base_response.dart';
import 'package:flutter_kit/core/network/datasource/auth/auth_network_data_source.dart';
import 'package:flutter_kit/core/network/datasource/goods/goods_network_data_source.dart';
import 'package:flutter_kit/core/network/datasource/user/user_network_data_source.dart';

import '../../../support/test_environment.dart';

/// Core Repository 方法映射与异常传播测试。
void main() {
  setUp(initializeCoreTestEnvironment);
  tearDown(resetCoreTestEnvironment);

  test('默认构造创建正式数据源并完成本地存储读写', () async {
    final AccountStoreRepository accountRepository = AccountStoreRepository();
    final LocaleStoreRepository localeRepository = LocaleStoreRepository();
    final TokenStoreRepository tokenRepository = TokenStoreRepository();

    await accountRepository.saveAccount('default-account');
    await localeRepository.saveLocaleTag('zh_CN');
    await tokenRepository.saveToken('default-token');

    expect(await accountRepository.loadAccount(), 'default-account');
    expect(await localeRepository.getLocaleTag(), 'zh_CN');
    expect(await tokenRepository.loadToken(), 'default-token');
    expect(AuthRepository(), isA<AuthRepository>());
    expect(GoodsRepository(), isA<GoodsRepository>());
    expect(DemoRepository(), isA<DemoRepository>());
  });

  group('网络 Repository', () {
    test('AuthRepository 转发登录请求与返回值', () async {
      final _FakeAuthNetworkDataSource dataSource =
          _FakeAuthNetworkDataSource();
      final AuthRepository repository = AuthRepository(dataSource: dataSource);
      const LoginRequest request = LoginRequest(phone: '138', password: 'pwd');

      final BaseResponse<Auth> response = await repository.loginByPassword(
        request,
      );

      expect(dataSource.request, same(request));
      expect(response.data?.token, 'auth-token');
    });

    test('GoodsRepository 转发分页与详情参数', () async {
      final _FakeGoodsNetworkDataSource dataSource =
          _FakeGoodsNetworkDataSource();
      final GoodsRepository repository = GoodsRepository(
        dataSource: dataSource,
      );
      const GoodsSearchRequest request = GoodsSearchRequest(page: 2, size: 20);

      final BaseResponse<BaseListResponse<Goods>> page = await repository
          .getGoodsPage(request);
      final BaseResponse<Goods> detail = await repository.getGoodsInfo(9);

      expect(dataSource.pageRequest, same(request));
      expect(dataSource.detailId, 9);
      expect(page.data?.list?.first.id, 1);
      expect(detail.data?.id, 9);
    });

    test('UserRepository 返回数据源结果', () async {
      final UserRepository repository = UserRepository(
        dataSource: _FakeUserNetworkDataSource(),
      );

      final BaseResponse<User> response = await repository.getPersonInfo();

      expect(response.data?.nickName, '用户');
    });

    test('网络 Repository 原样传播数据源异常', () async {
      final AuthRepository repository = AuthRepository(
        dataSource: _FakeAuthNetworkDataSource(error: StateError('登录失败')),
      );

      await expectLater(
        repository.loginByPassword(const LoginRequest()),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('Store Repository', () {
    test('账号、密码与 Token Repository 映射读写方法', () async {
      final _FakeAccountStoreDataSource accountDataSource =
          _FakeAccountStoreDataSource();
      final _FakeTokenStoreDataSource tokenDataSource =
          _FakeTokenStoreDataSource();
      final AccountStoreRepository accountRepository = AccountStoreRepository(
        dataSource: accountDataSource,
      );
      final TokenStoreRepository tokenRepository = TokenStoreRepository(
        dataSource: tokenDataSource,
      );

      await accountRepository.saveAccount('account');
      await accountRepository.savePassword('password');
      await tokenRepository.saveToken('token');

      expect(await accountRepository.loadAccount(), 'account');
      expect(await accountRepository.loadPassword(), 'password');
      expect(await tokenRepository.loadToken(), 'token');
      await tokenRepository.clearToken();
      expect(await tokenRepository.loadToken(), isEmpty);
    });

    test('认证 Repository 覆盖全部认证存储入口', () async {
      final _FakeAuthStoreDataSource dataSource = _FakeAuthStoreDataSource();
      final AuthStoreRepository repository = AuthStoreRepository(
        dataSource: dataSource,
      );
      const Auth auth = Auth(token: 'token', refreshToken: 'refresh');

      await repository.saveAuth(auth);

      expect(await repository.getAuth(), same(auth));
      expect(await repository.getToken(), 'token');
      expect(await repository.isLoggedIn(), isTrue);
      expect(await repository.shouldRefreshToken(), isFalse);
      await repository.clearAuth();
      expect(await repository.getAuth(), isNull);
    });

    test('主题与语言 Repository 映射全部持久化入口', () async {
      final _FakeThemeStoreDataSource themeDataSource =
          _FakeThemeStoreDataSource();
      final _FakeLocaleStoreDataSource localeDataSource =
          _FakeLocaleStoreDataSource();
      final ThemeStoreRepository themeRepository = ThemeStoreRepository(
        dataSource: themeDataSource,
      );
      final LocaleStoreRepository localeRepository = LocaleStoreRepository(
        dataSource: localeDataSource,
      );

      await themeRepository.saveThemeModeIndex(2);
      await themeRepository.saveThemeColorName('green');
      await localeRepository.saveLocaleTag('en_US');

      expect(await themeRepository.getThemeModeIndex(), 2);
      expect(await themeRepository.getThemeColorName(), 'green');
      expect(await localeRepository.getLocaleTag(), 'en_US');
    });

    test('用户信息 Repository 映射读写、更新、派生字段和清理', () async {
      final _FakeUserInfoStoreDataSource dataSource =
          _FakeUserInfoStoreDataSource();
      final UserInfoStoreRepository repository = UserInfoStoreRepository(
        dataSource: dataSource,
      );
      const User user = User(
        id: 8,
        unionid: 'u8',
        nickName: '旧昵称',
        avatarUrl: 'avatar.png',
      );

      await repository.saveUserInfo(user);
      await repository.updateUserInfo(<String, dynamic>{'nickName': '新昵称'});

      expect(await repository.getUserId(), 8);
      expect(await repository.getNickName(), '新昵称');
      expect(await repository.getAvatarUrl(), 'avatar.png');
      await repository.clearUserInfo();
      expect(await repository.getUserInfo(), isNull);
    });
  });

  group('DemoRepository', () {
    test('映射完整 CRUD 方法及参数', () async {
      final _FakeDemoLocalDataSource dataSource = _FakeDemoLocalDataSource();
      final DemoRepository repository = DemoRepository(dataSource: dataSource);

      final int id = await repository.createDemo('标题', description: '描述');
      await repository.updateDemo(const DemoEntity(id: 3, title: '新标题'));
      await repository.deleteDemo(3);

      expect(id, 3);
      expect(dataSource.createdTitle, '标题');
      expect(dataSource.createdDescription, '描述');
      expect((await repository.getById(3))?.title, '新标题');
      expect(await repository.getAll(), hasLength(1));
      expect(await repository.clearAll(), 1);
    });
  });
}

/// Fake 认证网络数据源。
class _FakeAuthNetworkDataSource implements AuthNetworkDataSource {
  /// 创建 Fake 认证网络数据源。
  _FakeAuthNetworkDataSource({this.error});

  /// 可选异常。
  final Object? error;

  /// 捕获的登录请求。
  LoginRequest? request;

  /// 返回认证响应。
  @override
  Future<BaseResponse<Auth>> loginByPassword(LoginRequest request) async {
    this.request = request;
    if (error case final Object error) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }
    return BaseResponse<Auth>(
      data: const Auth(token: 'auth-token', refreshToken: 'refresh'),
    );
  }
}

/// Fake 商品网络数据源。
class _FakeGoodsNetworkDataSource implements GoodsNetworkDataSource {
  /// 捕获的分页请求。
  GoodsSearchRequest? pageRequest;

  /// 捕获的详情 ID。
  int? detailId;

  /// 返回商品分页响应。
  @override
  Future<BaseResponse<BaseListResponse<Goods>>> getGoodsPage(
    GoodsSearchRequest request,
  ) async {
    pageRequest = request;
    return BaseResponse<BaseListResponse<Goods>>(
      data: BaseListResponse<Goods>(
        list: const <Goods>[Goods(id: 1, title: '商品')],
      ),
    );
  }

  /// 返回商品详情响应。
  @override
  Future<BaseResponse<Goods>> getGoodsInfo(int id) async {
    detailId = id;
    return BaseResponse<Goods>(
      data: Goods(id: id, title: '商品$id'),
    );
  }
}

/// Fake 用户网络数据源。
class _FakeUserNetworkDataSource implements UserNetworkDataSource {
  /// 返回用户信息。
  @override
  Future<BaseResponse<User>> getPersonInfo() async {
    return BaseResponse<User>(
      data: const User(id: 1, unionid: 'u1', nickName: '用户'),
    );
  }
}

/// Fake 账号存储数据源。
class _FakeAccountStoreDataSource implements AccountStoreDataSource {
  /// 账号。
  String account = '';

  /// 密码。
  String password = '';

  /// 读取账号。
  @override
  Future<String> getAccount() async => account;

  /// 读取密码。
  @override
  Future<String> getPassword() async => password;

  /// 保存账号。
  @override
  Future<void> setAccount(String account) async {
    this.account = account;
  }

  /// 保存密码。
  @override
  Future<void> setPassword(String password) async {
    this.password = password;
  }
}

/// Fake Token 存储数据源。
class _FakeTokenStoreDataSource implements TokenStoreDataSource {
  /// Token。
  String token = '';

  /// 清除 Token。
  @override
  Future<void> clearToken() async {
    token = '';
  }

  /// 读取 Token。
  @override
  Future<String> getToken() async => token;

  /// 保存 Token。
  @override
  Future<void> setToken(String token) async {
    this.token = token;
  }
}

/// Fake 认证存储数据源。
class _FakeAuthStoreDataSource implements AuthStoreDataSource {
  /// 认证信息。
  Auth? auth;

  /// 清除认证信息。
  @override
  Future<void> clearAuth() async {
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
    this.auth = auth;
  }

  /// 判断是否需要刷新。
  @override
  Future<bool> shouldRefreshToken() async => false;
}

/// Fake 主题存储数据源。
class _FakeThemeStoreDataSource implements ThemeStoreDataSource {
  /// 主题模式索引。
  int? modeIndex;

  /// 主题颜色名称。
  String? colorName;

  /// 读取主题颜色名称。
  @override
  Future<String?> getThemeColorName() async => colorName;

  /// 读取主题模式索引。
  @override
  Future<int?> getThemeModeIndex() async => modeIndex;

  /// 保存主题颜色名称。
  @override
  Future<void> saveThemeColorName(String colorName) async {
    this.colorName = colorName;
  }

  /// 保存主题模式索引。
  @override
  Future<void> saveThemeModeIndex(int modeIndex) async {
    this.modeIndex = modeIndex;
  }
}

/// Fake 语言存储数据源。
class _FakeLocaleStoreDataSource implements LocaleStoreDataSource {
  /// 语言标识。
  String? localeTag;

  /// 读取语言标识。
  @override
  Future<String?> getLocaleTag() async => localeTag;

  /// 保存语言标识。
  @override
  Future<void> saveLocaleTag(String localeTag) async {
    this.localeTag = localeTag;
  }
}

/// Fake 用户信息存储数据源。
class _FakeUserInfoStoreDataSource implements UserInfoStoreDataSource {
  /// 用户信息。
  User? user;

  /// 清除用户信息。
  @override
  Future<void> clearUserInfo() async {
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
  Future<User?> getUserInfo() async => user;

  /// 保存用户信息。
  @override
  Future<void> saveUserInfo(User user) async {
    this.user = user;
  }

  /// 更新用户信息。
  @override
  Future<void> updateUserInfo(Map<String, dynamic> updates) async {
    final User? current = user;
    if (current == null) {
      return;
    }
    user = User.fromJson(<String, dynamic>{...current.toJson(), ...updates});
  }
}

/// Fake Demo 本地数据源。
class _FakeDemoLocalDataSource implements DemoLocalDataSource {
  /// 当前记录。
  DemoEntity? entity;

  /// 创建标题。
  String? createdTitle;

  /// 创建描述。
  String? createdDescription;

  /// 清空记录。
  @override
  Future<int> clearAll() async {
    final int count = entity == null ? 0 : 1;
    entity = null;
    return count;
  }

  /// 创建记录。
  @override
  Future<int> createItem(String title, {String? description}) async {
    createdTitle = title;
    createdDescription = description;
    entity = DemoEntity(id: 3, title: title, description: description);
    return 3;
  }

  /// 删除记录。
  @override
  Future<void> deleteById(int id) async {}

  /// 查询全部记录。
  @override
  Future<List<DemoEntity>> getAllItems() async => <DemoEntity>[
    if (entity case final DemoEntity value) value,
  ];

  /// 按 ID 查询记录。
  @override
  Future<DemoEntity?> getItemById(int id) async => entity;

  /// 更新记录。
  @override
  Future<void> updateItem(DemoEntity entity) async {
    this.entity = entity;
  }
}
