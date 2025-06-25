import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// GetX Obx 包裹扩展
extension ObxExtensions on Widget {
  /// 简化 Obx 包裹的扩展方法
  ///
  /// 使用示例:
  /// ```dart
  /// Text('Hello World').obx()
  /// ```
  Widget obx() {
    return Obx(() => this);
  }

  /// 带条件的 Obx 包裹
  ///
  /// 使用示例:
  /// ```dart
  /// Text('Hello World').obxIf(condition.value)
  /// ```
  Widget obxIf(bool condition) {
    return condition ? Obx(() => this) : this;
  }

  /// 带错误处理的 Obx 包裹
  ///
  /// 使用示例:
  /// ```dart
  /// Text(controller.text.value).obxSafe(
  ///   onError: (error) => Text('Error: $error')
  /// )
  /// ```
  Widget obxSafe({Widget Function(dynamic error)? onError}) {
    return Obx(() {
      try {
        return this;
      } catch (e) {
        return onError?.call(e) ?? const SizedBox.shrink();
      }
    });
  }

  /// 带加载状态的 Obx 包裹
  ///
  /// 使用示例:
  /// ```dart
  /// Text(controller.data.value).obxLoading(
  ///   isLoading: controller.isLoading,
  ///   loadingWidget: CircularProgressIndicator()
  /// )
  /// ```
  Widget obxLoading({required RxBool isLoading, Widget? loadingWidget}) {
    return Obx(() {
      if (isLoading.value) {
        return loadingWidget ??
            const TDLoading(
              size: TDLoadingSize.small,
              icon: TDLoadingIcon.circle,
            );
      }
      return this;
    });
  }

  /// 带空状态检查的 Obx 包裹
  ///
  /// 使用示例:
  /// ```dart
  /// ListView.builder(...).obxEmpty(
  ///   isEmpty: controller.list.isEmpty,
  ///   emptyWidget: Text('No data')
  /// )
  /// ```
  Widget obxEmpty({required bool isEmpty, Widget? emptyWidget}) {
    return Obx(() {
      if (isEmpty) {
        return emptyWidget ?? const SizedBox.shrink();
      }
      return this;
    });
  }
}
