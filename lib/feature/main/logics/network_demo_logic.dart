import 'package:td_flutter_getx_template/core/base/base/base_logic.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../models/demo_item.dart';
import '../states/network_demo_state.dart';

class NetworkDemoLogic extends BaseLogic {
  final NetworkDemoState networkDemoState = NetworkDemoState();

  @override
  void onInit() {
    super.onInit();
    _initNetworkDemoItems();
  }

  /// 初始化网络Demo项目数据
  void _initNetworkDemoItems() {
    networkDemoState.networkDemoItems = [
      DemoItem(
        title: 'API Service 示例',
        description: '展示 API 接口服务的使用',
        icon: TDIcons.api,
        onTap: _onApiServiceTap,
      ),
      DemoItem(
        title: '网络拦截器示例',
        description: '展示请求和响应拦截器的使用',
        icon: TDIcons.filter,
        onTap: _onInterceptorTap,
      ),
      DemoItem(
        title: '错误处理示例',
        description: '展示网络请求错误处理机制',
        icon: TDIcons.error_circle,
        onTap: _onErrorHandlingTap,
      ),
      DemoItem(
        title: '数据序列化示例',
        description: '展示 JSON 数据的序列化和反序列化',
        icon: TDIcons.transform,
        onTap: _onSerializationTap,
      ),
      DemoItem(
        title: 'Alice 调试示例',
        description: '展示网络请求调试工具的使用',
        icon: TDIcons.bug,
        onTap: _onAliceDebuggerTap,
      ),
    ];
  }

  /// API Service 示例点击
  void _onApiServiceTap() {
    // TODO: 展示 API 接口调用示例
  }

  /// 网络拦截器示例点击
  void _onInterceptorTap() {
    // TODO: 展示拦截器功能
  }

  /// 错误处理示例点击
  void _onErrorHandlingTap() {
    // TODO: 展示错误处理机制
  }

  /// 数据序列化示例点击
  void _onSerializationTap() {
    // TODO: 展示数据序列化功能
  }

  /// Alice 调试工具点击
  void _onAliceDebuggerTap() {
    // TODO: 打开 Alice 调试页面
  }
} 