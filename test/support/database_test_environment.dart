import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// FFI 数据库测试环境。
abstract final class DatabaseTestEnvironment {
  /// 禁止实例化数据库测试环境。
  DatabaseTestEnvironment._();

  /// 初始化 sqflite FFI 实现。
  static void initialize() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}
