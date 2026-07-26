import 'package:get/get.dart';
import 'package:flutter_kit/core/base/base/base_logic.dart';
import 'package:flutter_kit/core/data/repository/demo_repository.dart';
import 'package:flutter_kit/core/database/entity/demo_entity.dart';

import '../localization/demo_keys.dart';

/// 数据库示例页 Logic
///
/// 管理本地 Demo 表的增删查操作。
class DatabaseDemoLogic extends BaseLogic {
  /// 创建数据库示例页 Logic
  ///
  /// [demoRepository] 可选 Demo 仓库，测试与预览可注入隔离实现。
  DatabaseDemoLogic({DemoRepository? demoRepository})
    : _demoRepository = demoRepository ?? DemoRepository();

  /// Demo 数据仓库
  final DemoRepository _demoRepository;

  /// Demo 记录列表
  final RxList<DemoEntity> items = <DemoEntity>[].obs;

  /// 示例记录编号
  int _counter = 0;

  /// 初始化数据库记录
  @override
  void onInit() {
    super.onInit();
    _loadItems();
  }

  /// 新增一条示例记录
  Future<void> addItem() async {
    _counter++;
    await _demoRepository.createDemo(
      '${DemoKeys.dbItemTitle.tr} $_counter',
      description: DemoKeys.dbItemDesc.tr,
    );
    await _loadItems();
  }

  /// 删除指定记录
  Future<void> deleteItem(int id) async {
    await _demoRepository.deleteDemo(id);
    await _loadItems();
  }

  /// 清空全部记录
  Future<void> clearAll() async {
    await _demoRepository.clearAll();
    await _loadItems();
  }

  /// 加载全部数据库示例记录
  Future<void> _loadItems() async {
    items.value = await _demoRepository.getAll();
  }
}
