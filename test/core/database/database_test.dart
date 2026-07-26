import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path_util;
import 'package:sqflite/sqflite.dart';

import 'package:flutter_kit/core/database/datasource/demo/demo_local_data_source_impl.dart';
import 'package:flutter_kit/core/database/entity/demo_entity.dart';
import 'package:flutter_kit/core/database/provider/database_provider.dart';

import '../../support/database_test_environment.dart';

/// FFI SQLite 建表、实体映射与 CRUD 测试。
void main() {
  late DemoLocalDataSourceImpl dataSource;
  late Database database;

  setUpAll(() async {
    DatabaseTestEnvironment.initialize();
    final String databasePath = path_util.join(
      await getDatabasesPath(),
      'app_database.db',
    );
    await deleteDatabase(databasePath);
    database = await DatabaseProvider().database;
    dataSource = DemoLocalDataSourceImpl();
  });

  tearDownAll(() async {
    await DatabaseProvider().close();
  });

  setUp(() async {
    await database.delete('demo_items');
  });

  test('DemoEntity 支持复制、Map 转换和排除主键', () {
    const DemoEntity entity = DemoEntity(
      id: 1,
      title: '标题',
      description: '描述',
      createdAt: 'created',
      updatedAt: 'updated',
    );

    expect(entity.copyWith(title: '新标题').title, '新标题');
    expect(entity.copyWith().id, 1);
    expect(entity.toMap()['id'], 1);
    expect(entity.toMap(includeId: false).containsKey('id'), isFalse);
    expect(DemoEntity.fromMap(entity.toMap()).description, '描述');
    expect(DemoEntity.fromMap(<String, dynamic>{}).title, isEmpty);
  });

  test('数据库首次打开后创建 Demo 表', () async {
    final List<Map<String, Object?>> tables = await database.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table' AND name = ?",
      <Object>['demo_items'],
    );

    expect(tables, hasLength(1));
  });

  test('数据库提供者为并发访问复用同一打开实例', () async {
    final DatabaseProvider firstProvider = DatabaseProvider();
    final DatabaseProvider secondProvider = DatabaseProvider();

    final List<Database> databases = await Future.wait(<Future<Database>>[
      firstProvider.database,
      secondProvider.database,
      firstProvider.database,
    ]);

    expect(firstProvider, same(secondProvider));
    expect(databases, everyElement(same(database)));
  });

  test('创建、查询、更新与删除记录', () async {
    final int id = await dataSource.createItem('标题', description: '描述');

    final DemoEntity? created = await dataSource.getItemById(id);
    expect(created?.title, '标题');
    expect(created?.description, '描述');
    expect(created?.createdAt, isNotEmpty);

    await dataSource.updateItem(created!.copyWith(title: '新标题'));
    expect((await dataSource.getItemById(id))?.title, '新标题');

    await dataSource.deleteById(id);
    expect(await dataSource.getItemById(id), isNull);
  });

  test('不存在记录的查询、更新与删除保持安全且不产生新数据', () async {
    expect(await dataSource.getItemById(999), isNull);

    await dataSource.updateItem(const DemoEntity(id: 999, title: '不存在记录'));
    await dataSource.deleteById(999);

    expect(await dataSource.getAllItems(), isEmpty);
  });

  test('空描述按空字符串持久化并保留创建更新时间', () async {
    final int id = await dataSource.createItem('无描述');
    final DemoEntity? entity = await dataSource.getItemById(id);

    expect(entity?.description, isEmpty);
    expect(entity?.createdAt, isNotEmpty);
    expect(entity?.updatedAt, entity?.createdAt);
  });

  test('查询列表按更新时间与创建时间倒序返回', () async {
    await database.insert('demo_items', <String, Object?>{
      'title': '较早',
      'description': '',
      'createdAt': '2026-01-01T00:00:00',
      'updatedAt': '2026-01-01T00:00:00',
    });
    await database.insert('demo_items', <String, Object?>{
      'title': '较晚',
      'description': '',
      'createdAt': '2026-01-02T00:00:00',
      'updatedAt': '2026-01-02T00:00:00',
    });

    final List<DemoEntity> items = await dataSource.getAllItems();

    expect(items.map((DemoEntity item) => item.title), <String>['较晚', '较早']);
  });

  test('无主键更新抛出参数异常', () async {
    await expectLater(
      dataSource.updateItem(const DemoEntity(title: '无主键')),
      throwsArgumentError,
    );
  });

  test('清空数据返回删除数量', () async {
    await dataSource.createItem('一');
    await dataSource.createItem('二');

    expect(await dataSource.clearAll(), 2);
    expect(await dataSource.getAllItems(), isEmpty);
  });

  test('数据库关闭后重新访问会打开可用实例并保留表结构', () async {
    final DatabaseProvider provider = DatabaseProvider();
    final Database closedDatabase = database;

    await provider.close();
    database = await provider.database;
    dataSource = DemoLocalDataSourceImpl();

    expect(closedDatabase.isOpen, isFalse);
    expect(database.isOpen, isTrue);
    expect(database, isNot(same(closedDatabase)));
    final int id = await dataSource.createItem('重新打开');
    expect((await dataSource.getItemById(id))?.title, '重新打开');
  });
}
