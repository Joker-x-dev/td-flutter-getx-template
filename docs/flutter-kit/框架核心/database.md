# 数据库

数据库模块位于 `lib/core/database/`，当前基于 sqflite 实现。它由 `DatabaseProvider` 管理数据库单例和建表，Entity 负责记录映射，DataSource 抽象 CRUD 契约，Repository 对 Feature 提供业务入口。页面和 Logic 不直接持有 `Database`、SQL、表名或列名。

## 介绍

数据库模块提供本地持久化能力，当前以 Demo 表演示完整的 Entity、DataSource、Repository 与 Feature Logic 链路。数据库模块只处理本地读写；业务只能通过 `DemoRepository` 等 Repository 调用，不能从页面越过数据层直接操作 sqflite。

## 设计思路

```text
core/database/
├── provider/database_provider.dart          # 数据库文件、版本、建表
├── entity/demo_entity.dart                  # 表记录与 Map 转换
└── datasource/demo/
    ├── demo_local_data_source.dart          # CRUD 契约
    └── demo_local_data_source_impl.dart     # sqflite 实现

Feature Logic → DemoRepository → DemoLocalDataSource → DatabaseProvider → sqflite
```

## DatabaseProvider

文件：`lib/core/database/provider/database_provider.dart`

| 成员 | 当前值 | 作用 |
| --- | --- | --- |
| 数据库文件 | `app_database.db` | sqflite 在平台数据库目录创建的文件 |
| 版本 | `1` | 结构变更时递增并添加升级迁移 |
| 表 | `demo_items` | 当前 Demo 表 |
| 获取入口 | `DatabaseProvider().database` | 懒初始化后的共享 `Future<Database>` |
| 释放入口 | `DatabaseProvider().close()` | 关闭当前连接并允许后续重新打开 |

```dart
/// 数据库 Provider 在首次访问时打开数据库。
class DatabaseProvider {
  /// 单例实例，避免并发打开多个数据库连接。
  static final DatabaseProvider _instance = DatabaseProvider._internal();

  /// 延迟持有已打开的 sqflite 数据库。
  Database? _database;

  /// 复用并发首次访问产生的打开任务。
  Future<Database>? _databaseFuture;

  /// 所有 DataSource 通过此 getter 获取同一实例。
  Future<Database> get database async {
    final Database? existingDatabase = _database;
    if (existingDatabase != null && existingDatabase.isOpen) {
      return existingDatabase;
    }
    final Future<Database>? openingDatabase = _databaseFuture;
    if (openingDatabase != null) return openingDatabase;

    final Future<Database> databaseFuture = _initDatabase();
    _databaseFuture = databaseFuture;
    try {
      final Database openedDatabase = await databaseFuture;
      _database = openedDatabase;
      return openedDatabase;
    } finally {
      if (identical(_databaseFuture, databaseFuture)) {
        _databaseFuture = null;
      }
    }
  }

  /// 关闭连接并清理缓存实例。
  Future<void> close() async {
    final Future<Database>? openingDatabase = _databaseFuture;
    final Database? currentDatabase = openingDatabase == null
        ? _database
        : await openingDatabase;
    _database = null;
    _databaseFuture = null;
    if (currentDatabase != null && currentDatabase.isOpen) {
      await currentDatabase.close();
    }
  }

  /// 首次打开时执行 onCreate 创建初始表结构。
  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'app_database.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }
}
```

当前 Provider 只配置了 `onCreate`。真正修改已发布表结构时，必须递增 `_databaseVersion` 并增加 `onUpgrade` 迁移逻辑；只改 `CREATE TABLE` 不会更新已安装用户的旧数据库。

当前初始表结构如下：

```dart
/// 创建 Demo 表。
Future<void> _onCreate(Database db, int version) async {
  await db.execute('''
    CREATE TABLE demo_items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''');
}
```

## 实体示例

文件：`lib/core/database/entity/demo_entity.dart`

```dart
/// Demo 表记录，对应 demo_items 的一行数据。
class DemoEntity {
  const DemoEntity({
    this.id,
    this.title = '',
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  /// 自增主键；创建前为空，插入后由 sqflite 返回。
  final int? id;

  /// 非空标题，对应 title TEXT NOT NULL。
  final String title;

  /// 转换为 sqflite 写入的 Map；更新时排除 where 条件使用的 id。
  Map<String, dynamic> toMap({bool includeId = true}) => {
    if (includeId) 'id': id,
    'title': title,
    'description': description,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  /// 从 sqflite 查询结果恢复领域实体。
  factory DemoEntity.fromMap(Map<String, dynamic> map) => DemoEntity(
    id: map['id'] as int?,
    title: (map['title'] as String?) ?? '',
    description: map['description'] as String?,
    createdAt: map['createdAt'] as String?,
    updatedAt: map['updatedAt'] as String?,
  );
}
```

Entity 是数据库行与领域对象的边界。Feature 不读取 `Map<String, dynamic>`，DataSource 实现负责调用 `fromMap()` / `toMap()`。

## 数据源接口示例

文件：`lib/core/database/datasource/demo/demo_local_data_source.dart`

| 方法 | 返回值 | 业务含义 |
| --- | --- | --- |
| `createItem(title, description:)` | `Future<int>` | 新增记录并返回主键 |
| `updateItem(entity)` | `Future<void>` | 根据实体主键更新记录；无主键是参数错误 |
| `deleteById(id)` | `Future<void>` | 删除一条记录 |
| `clearAll()` | `Future<int>` | 清表并返回受影响行数 |
| `getAllItems()` | `Future<List<DemoEntity>>` | 按更新时间、创建时间倒序查询 |
| `getItemById(id)` | `Future<DemoEntity?>` | 查询单条，不存在返回 `null` |

```dart
/// Demo 表本地数据源契约。
abstract class DemoLocalDataSource {
  /// 插入记录并返回 sqflite 生成的主键。
  Future<int> createItem(String title, {String? description});

  /// 更新带主键的记录。
  Future<void> updateItem(DemoEntity entity);

  /// 按主键删除记录。
  Future<void> deleteById(int id);

  /// 清空表并返回受影响的行数。
  Future<int> clearAll();

  /// 查询按更新时间倒序排列的所有记录。
  Future<List<DemoEntity>> getAllItems();

  /// 查询单条记录；不存在时返回 null。
  Future<DemoEntity?> getItemById(int id);
}
```

## 数据源实现示例

文件：`lib/core/database/datasource/demo/demo_local_data_source_impl.dart`

```dart
/// Demo 数据源实现，持有 Provider 而不是直接打开数据库文件。
class DemoLocalDataSourceImpl implements DemoLocalDataSource {
  /// 表名仅留在数据层实现中。
  static const String _tableName = 'demo_items';

  /// 共享数据库提供者；测试可通过构造函数注入替代实例。
  final DatabaseProvider _databaseProvider;

  /// 创建数据源实现。
  DemoLocalDataSourceImpl({DatabaseProvider? databaseProvider})
      : _databaseProvider = databaseProvider ?? DatabaseProvider();

  /// 获取已初始化的 sqflite 数据库。
  Future<Database> get _database async => _databaseProvider.database;

  /// 创建记录并补齐两类时间字段。
  @override
  Future<int> createItem(String title, {String? description}) async {
    final String now = DateTime.now().toIso8601String();
    final Database db = await _database;
    return db.insert(_tableName, {
      'title': title,
      'description': description ?? '',
      'createdAt': now,
      'updatedAt': now,
    });
  }

  /// 按主键更新记录；没有主键时拒绝执行无条件更新。
  @override
  Future<void> updateItem(DemoEntity entity) async {
    final int? id = entity.id;
    if (id == null) {
      throw ArgumentError('更新记录时主键 id 不能为空');
    }
    final Database db = await _database;
    await db.update(
      _tableName,
      entity.toMap(includeId: false)
        ..['updatedAt'] = DateTime.now().toIso8601String(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 使用 whereArgs 绑定参数删除记录，避免把输入拼接进 SQL。
  @override
  Future<void> deleteById(int id) async {
    final Database db = await _database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  /// 清空 Demo 表并返回删除行数。
  @override
  Future<int> clearAll() async {
    final Database db = await _database;
    return db.delete(_tableName);
  }

  /// 查询记录并让数据库完成排序，再转换为 Entity。
  @override
  Future<List<DemoEntity>> getAllItems() async {
    final Database db = await _database;
    final maps = await db.query(
      _tableName,
      orderBy: 'updatedAt DESC, createdAt DESC',
    );
    return maps.map((map) => DemoEntity.fromMap(map)).toList();
  }

  /// 查询单条记录；没有匹配结果时返回 null。
  @override
  Future<DemoEntity?> getItemById(int id) async {
    final Database db = await _database;
    final maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return maps.isEmpty ? null : DemoEntity.fromMap(maps.first);
  }
}
```

## 仓库实现示例

文件：`lib/core/data/repository/demo_repository.dart`

```dart
/// Demo 仓库，隔离页面 Logic 与 sqflite 数据源。
class DemoRepository {
  /// 本地 CRUD 数据源接口。
  final DemoLocalDataSource _dataSource;

  /// 默认使用 sqflite 实现，测试可以注入 fake 数据源。
  DemoRepository({DemoLocalDataSource? dataSource})
      : _dataSource = dataSource ?? DemoLocalDataSourceImpl();

  /// 新增一条 Demo 业务记录。
  Future<int> createDemo(String title, {String? description}) =>
      _dataSource.createItem(title, description: description);

  /// 获取当前所有记录。
  Future<List<DemoEntity>> getAll() => _dataSource.getAllItems();

  /// 更新编辑完成的记录。
  Future<void> updateDemo(DemoEntity entity) => _dataSource.updateItem(entity);

  /// 删除指定主键记录。
  Future<void> deleteDemo(int id) => _dataSource.deleteById(id);

  /// 清空当前 Demo 表。
  Future<int> clearAll() => _dataSource.clearAll();

  /// 查询单条记录；不存在时返回 null。
  Future<DemoEntity?> getById(int id) => _dataSource.getItemById(id);
}
```

## Logic 使用示例

文件：`lib/feature/demo/logics/database_demo_logic.dart`

```dart
/// 数据库示例页 Logic，只依赖 DemoRepository。
class DatabaseDemoLogic extends BaseLogic {
  /// 本地 Demo 数据统一入口。
  final DemoRepository _demoRepository = DemoRepository();

  /// 页面展示的记录列表。
  final RxList<DemoEntity> items = <DemoEntity>[].obs;

  /// 新增后重新读取排序后的完整列表。
  Future<void> addItem() async {
    await _demoRepository.createDemo('示例标题', description: '示例描述');
    await _loadItems();
  }

  /// 将 Repository 查询结果写入 RxList，驱动 View 刷新。
  Future<void> _loadItems() async {
    items.value = await _demoRepository.getAll();
  }
}
```

## 与数据层的关系

- `DatabaseProvider`、Entity、DataSource 只负责本地数据库技术细节。
- `DemoRepository` 对 Feature 提供创建、查询、更新、删除等业务动作。
- DatabaseDemoLogic 仅依赖 Repository 和 Entity，不持有 Database、SQL 或表名。

## 新增表的做法

1. 定义 Entity，包括字段可空性、`toMap`、`fromMap` 和必要的 copyWith。
2. 在 `DatabaseProvider` 为新安装和旧版本升级分别创建 / 迁移表。
3. 定义 `<domain>_local_data_source.dart`，只暴露领域 CRUD 方法。
4. 实现 sqflite 查询、参数化条件和 Entity 映射。
5. 在 `core/data/repository/` 新增 Repository，Feature Logic 仅依赖它。
6. 测试创建、更新、删除、排序、空结果和旧数据库升级。

## 注意事项

- `DatabaseProvider` 目前的版本升级逻辑尚未定义；新增正式表结构前必须补齐迁移方案。
- `updateItem()` 对 `id == null` 会抛 `ArgumentError`，调用前必须确保编辑对象有主键。
- 数据库读写不走 RequestHelper；如需要页面 loading / 空 / 错误状态，按页面形态选择 BaseView 或网络父类。

## 关联阅读

- [数据层](./data.md)
- [数据层](./data.md)
- [数据模型](./model.md)
