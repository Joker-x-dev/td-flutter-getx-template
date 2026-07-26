import 'package:flutter/material.dart';

import 'animation_context.dart';

/// 旧版位置参数动画配置兼容入口。

/// 旧版动画配置模型。
@Deprecated('请使用 ExtensionAnimationConfig。')
class AnimationModel extends ExtensionAnimationConfig {
  /// 创建旧版动画配置模型。
  ///
  /// [duration] 动画时长。
  /// [curve] 动画曲线。
  const AnimationModel({
    required super.duration,
    super.curve = Curves.easeInOut,
  });
}

/// 旧版位置参数动画扩展。
extension AnimationExtension on Widget {
  /// 使用位置参数为链式动画提供配置。
  ///
  /// [duration] 动画时长。
  /// [curve] 动画曲线。
  ///
  /// 新代码使用统一导出入口中的 `animate(duration:, curve:)`。
  Widget animate(Duration duration, {Curve curve = Curves.easeInOut}) {
    return ExtensionAnimationScope(
      config: AnimationModel(duration: duration, curve: curve),
      child: this,
    );
  }
}
