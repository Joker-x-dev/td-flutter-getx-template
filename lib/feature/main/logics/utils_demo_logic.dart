import 'package:td_flutter_getx_template/core/base/base/base_logic.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../models/demo_item.dart';
import '../states/utils_demo_state.dart';

class UtilsDemoLogic extends BaseLogic {
  final UtilsDemoState utilsDemoState = UtilsDemoState();

  @override
  void onInit() {
    super.onInit();
    _initUtilsDemoItems();
  }

  /// 初始化工具类Demo项目数据
  void _initUtilsDemoItems() {
    utilsDemoState.utilsDemoItems = [
      DemoItem(
        title: '路由管理工具',
        description: '展示路由跳转和管理功能',
        icon: TDIcons.location,
        onTap: _onRouteManagerTap,
      ),
      DemoItem(
        title: '存储工具示例',
        description: '展示本地数据存储和读取',
        icon: TDIcons.folder,
        onTap: _onStorageUtilTap,
      ),
      DemoItem(
        title: '屏幕适配工具',
        description: '展示屏幕尺寸适配功能',
        icon: TDIcons.desktop,
        onTap: _onSizeUtilTap,
      ),
      DemoItem(
        title: '弹窗提示工具',
        description: '展示 Toast 和 Alert 提示功能',
        icon: TDIcons.notification,
        onTap: _onAlertUtilTap,
      ),
      DemoItem(
        title: '通用工具方法',
        description: '展示各种通用的工具方法',
        icon: TDIcons.tools,
        onTap: _onCommonUtilTap,
      ),
      DemoItem(
        title: '包信息工具',
        description: '展示应用包信息获取功能',
        icon: TDIcons.info_circle,
        onTap: _onPackageInfoUtilTap,
      ),
    ];
  }

  /// 路由管理工具点击
  void _onRouteManagerTap() {
    // TODO: 展示路由管理功能
  }

  /// 存储工具示例点击
  void _onStorageUtilTap() {
    // TODO: 展示存储工具功能
  }



  /// 屏幕适配工具点击
  void _onSizeUtilTap() {
    // TODO: 展示屏幕适配功能
  }

  /// 弹窗提示工具点击
  void _onAlertUtilTap() {
    // TODO: 展示弹窗提示功能
  }

  /// 通用工具方法点击
  void _onCommonUtilTap() {
    // TODO: 展示通用工具方法
  }

  /// 包信息工具点击
  void _onPackageInfoUtilTap() {
    // TODO: 展示包信息功能
  }
}
