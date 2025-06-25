import 'package:flutter/material.dart';

import '../theme/size.dart';

/// 间距组件库
/// 提供预设的水平和垂直间距组件，简化布局代码
/// 使用示例：
/// ```dart
/// [
///   TDText('第一行', font: fontBodyLarge),
///   const SpaceVerticalMedium(),
///   TDText('第二行', font: fontBodyLarge),
/// ].toColumnStart()
/// ```

//region 水平间距组件

/// 创建一个超小水平间距(4dp)的间隔组件
class SpaceHorizontalXSmall extends StatelessWidget {
  const SpaceHorizontalXSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: spaceHorizontalXSmall);
  }
}

/// 创建一个小水平间距(8dp)的间隔组件
class SpaceHorizontalSmall extends StatelessWidget {
  const SpaceHorizontalSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: spaceHorizontalSmall);
  }
}

/// 创建一个中等水平间距(12dp)的间隔组件
class SpaceHorizontalMedium extends StatelessWidget {
  const SpaceHorizontalMedium({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: spaceHorizontalMedium);
  }
}

/// 创建一个大水平间距(16dp)的间隔组件
class SpaceHorizontalLarge extends StatelessWidget {
  const SpaceHorizontalLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: spaceHorizontalLarge);
  }
}

/// 创建一个特大水平间距(24dp)的间隔组件
class SpaceHorizontalXLarge extends StatelessWidget {
  const SpaceHorizontalXLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: spaceHorizontalXLarge);
  }
}

/// 创建一个超大水平间距(32dp)的间隔组件
class SpaceHorizontalXXLarge extends StatelessWidget {
  const SpaceHorizontalXXLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: spaceHorizontalXXLarge);
  }
}

//endregion

//region 垂直间距组件

/// 创建一个超小垂直间距(4dp)的间隔组件
class SpaceVerticalXSmall extends StatelessWidget {
  const SpaceVerticalXSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: spaceVerticalXSmall);
  }
}

/// 创建一个小垂直间距(8dp)的间隔组件
class SpaceVerticalSmall extends StatelessWidget {
  const SpaceVerticalSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: spaceVerticalSmall);
  }
}

/// 创建一个中等垂直间距(12dp)的间隔组件
class SpaceVerticalMedium extends StatelessWidget {
  const SpaceVerticalMedium({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: spaceVerticalMedium);
  }
}

/// 创建一个大垂直间距(16dp)的间隔组件
class SpaceVerticalLarge extends StatelessWidget {
  const SpaceVerticalLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: spaceVerticalLarge);
  }
}

/// 创建一个特大垂直间距(24dp)的间隔组件
class SpaceVerticalXLarge extends StatelessWidget {
  const SpaceVerticalXLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: spaceVerticalXLarge);
  }
}

/// 创建一个超大垂直间距(32dp)的间隔组件
class SpaceVerticalXXLarge extends StatelessWidget {
  const SpaceVerticalXXLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: spaceVerticalXXLarge);
  }
}

//endregion
