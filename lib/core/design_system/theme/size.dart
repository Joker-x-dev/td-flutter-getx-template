import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

BuildContext get _context => Get.context!;

//==================== 基础间距 ====================
/// 4dp间距，最小间隔，如紧凑排列的元素间距
double get spacer4 => TDTheme.of(_context).spacer4;

/// 8dp间距，小间距，如图标与文字之间、紧凑布局的元素间距
double get spacer8 => TDTheme.of(_context).spacer8;

/// 12dp间距，中等间距，如列表项间距、中型组件的内边距
double get spacer12 => TDTheme.of(_context).spacer12;

/// 16dp间距，常规间距，如卡片内边距、按钮内边距
double get spacer16 => TDTheme.of(_context).spacer16;

/// 24dp间距，大间距，用于大型容器内部分隔、模块间间距
double get spacer24 => TDTheme.of(_context).spacer24;

/// 32dp间距，超大间距，用于页面主要区块之间的分隔
double get spacer32 => TDTheme.of(_context).spacer32;

/// 40dp间距，特大间距，用于页面大区块的分隔
double get spacer40 => TDTheme.of(_context).spacer40;

/// 48dp间距，极大间距，用于页面大区块的分隔
double get spacer48 => TDTheme.of(_context).spacer48;

/// 64dp间距，巨大间距，用于页面重要区域的强调分隔
double get spacer64 => TDTheme.of(_context).spacer64;

/// 96dp间距，超巨大间距，用于重要内容的突出显示
double get spacer96 => TDTheme.of(_context).spacer96;

/// 160dp间距，最大间距，用于特殊设计场景
double get spacer160 => TDTheme.of(_context).spacer160;

//==================== 语义化垂直间距 ====================
/// 超小垂直间距(4dp)，用于最小的垂直间隔，如紧凑排列的元素间距
double get spaceVerticalXSmall => spacer4;

/// 小垂直间距(8dp)，用于紧凑布局中的间距，如图标与文字之间
double get spaceVerticalSmall => spacer8;

/// 中等垂直间距(12dp)，用于内容区域的常规间距，如列表项之间的间距
double get spaceVerticalMedium => spacer12;

/// 大垂直间距(16dp)，用于卡片内部主要内容块之间的间距
double get spaceVerticalLarge => spacer16;

/// 特大垂直间距(24dp)，用于大模块内部的分隔，如卡片组之间的间距
double get spaceVerticalXLarge => spacer24;

/// 超大垂直间距(32dp)，用于页面块与块之间的大间距，如不同功能模块之间的分隔
double get spaceVerticalXXLarge => spacer32;

//==================== 语义化水平间距 ====================
/// 超小水平间距(4dp)，用于最小的水平间隔，如紧凑排列的元素间距
double get spaceHorizontalXSmall => spacer4;

/// 小水平间距(8dp)，用于紧凑布局的水平间距，如图标与文字之间
double get spaceHorizontalSmall => spacer8;

/// 中等水平间距(12dp)，用于中等容器的水平间距，如列表项的左右间距
double get spaceHorizontalMedium => spacer12;

/// 大水平间距(16dp)，用于常规容器的左右边距，如卡片的内边距
double get spaceHorizontalLarge => spacer16;

/// 特大水平间距(24dp)，用于大型容器内部的水平分隔
double get spaceHorizontalXLarge => spacer24;

/// 超大水平间距(32dp)，用于页面左右边距，大型容器的内边距
double get spaceHorizontalXXLarge => spacer32;

//==================== 内边距 ====================
/// 超小内边距(4dp)，用于最小的内边距，如标签、徽章等小组件
double get spacePaddingXSmall => spacer4;

/// 小内边距(8dp)，用于紧凑型组件的内边距，如小型按钮
double get spacePaddingSmall => spacer8;

/// 中等内边距(12dp)，用于按钮、输入框等中型组件的内边距
double get spacePaddingMedium => spacer12;

/// 大内边距(16dp)，用于卡片、对话框等容器的内边距
double get spacePaddingLarge => spacer16;

//==================== 其他常用尺寸 ====================
/// 分割线高度(0.5dp)，用于列表项之间的分割线、边框线等
double get spaceDivider => 0.5;

/// 指示器高度(2dp)，用于选中指示器、进度条等
double get spaceIndicator => 2.0;

//==================== 边距对象 ====================
/// 页面标准边距(水平16dp、垂直16dp)
EdgeInsets get pagePadding => EdgeInsets.symmetric(
  horizontal: spaceHorizontalLarge,
  vertical: spaceVerticalLarge,
);

/// 卡片标准内边距(16dp)
EdgeInsets get cardPadding => EdgeInsets.all(spacePaddingLarge);

/// 列表项标准内边距(水平16dp、垂直12dp)
EdgeInsets get listItemPadding => EdgeInsets.symmetric(
  horizontal: spaceHorizontalLarge,
  vertical: spaceVerticalMedium,
);

/// 表单项垂直间距(16dp)
SizedBox get formItemSpacer => SizedBox(height: spaceVerticalLarge);

/// 按钮间水平间距(8dp)
SizedBox get buttonHorizontalSpacer => SizedBox(width: spaceHorizontalSmall);

/// 文本与图标间距(4dp)
SizedBox get textIconSpacer => SizedBox(width: spaceHorizontalXSmall);
