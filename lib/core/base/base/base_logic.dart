import 'package:get/get.dart';

abstract class BaseLogic extends SuperController {
  /// 其他页面传递过来的参数
  final dynamic args = Get.arguments;

  /// 其他页面传递过来的 id (假如有)
  dynamic get id {
    if (args is Map<String, dynamic>) {
      return args["id"];
    }
    return null;
  }

  /// 当控制器准备就绪时调用此方法
  /// 通常用于初始化数据
  @override
  void onReady() {
    super.onReady();
    initData();
  }

  /// 当控制器从视图树中分离时调用此方法
  /// 可以在这里进行资源释放等操作
  @override
  void onDetached() {}

  /// 当控制器初始化时调用此方法
  /// 通常用于相关数据的初始设置
  @override
  void onInit() {
    super.onInit();
  }

  /// 当控制器处于非活动状态时调用此方法
  /// 适合进行一些状态监听或暂停操作
  @override
  void onInactive() {}

  /// 当控制器彻底离开时调用此方法
  /// 适合进行一些退出前的清理工作
  @override
  void onPaused() {}

  /// 当控制器彻底恢复时调用此方法
  /// 适合进行恢复时的数据加载或状态更新
  @override
  void onResumed() {}

  /// 当控制器被隐藏时调用此方法
  @override
  void onHidden() {}

  /// 初始化数据的方法
  /// 子类可以选择实现此方法以进行数据加载或初始化操作
  /// 若不需要初始化操作，可以直接使用默认实现
  void initData() {}
}
