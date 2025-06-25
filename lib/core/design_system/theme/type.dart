import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

BuildContext get _context => Get.context!;

/// 超大号显示文字 (64/72)，用于特别重要的页面标题，活动页大标题
Font? get fontDisplayLarge => TDTheme.of(_context).fontDisplayLarge;

/// 大号显示文字 (48/56)，用于重要页面的主标题，开屏页标题
Font? get fontDisplayMedium => TDTheme.of(_context).fontDisplayMedium;

/// 大型标题 (36/44)，用于重要信息的一级标题，产品名称
Font? get fontHeadlineLarge => TDTheme.of(_context).fontHeadlineLarge;

/// 中型标题 (28/36)，用于页面主要标题，重要内容区标题
Font? get fontHeadlineMedium => TDTheme.of(_context).fontHeadlineMedium;

/// 小型标题 (24/32)，用于次级页面标题，模块标题
Font? get fontHeadlineSmall => TDTheme.of(_context).fontHeadlineSmall;

/// 特大号标题 (20/28)，用于内容区域的主标题，卡片标题
Font? get fontTitleExtraLarge => TDTheme.of(_context).fontTitleExtraLarge;

/// 大号标题 (18/26)，用于对话框标题，列表标题
Font? get fontTitleLarge => TDTheme.of(_context).fontTitleLarge;

/// 中号标题 (16/24)，用于表单标题，内容区小标题
Font? get fontTitleMedium => TDTheme.of(_context).fontTitleMedium;

/// 小号标题 (14/22)，用于辅助性标题，小卡片标题
Font? get fontTitleSmall => TDTheme.of(_context).fontTitleSmall;

/// 超大号正文 (18/26)，用于重要内容文本，突出显示的信息
Font? get fontBodyExtraLarge => TDTheme.of(_context).fontBodyExtraLarge;

/// 大号正文 (16/24)，用于主要内容文本，对话框内容
Font? get fontBodyLarge => TDTheme.of(_context).fontBodyLarge;

/// 中号正文 (14/22)，用于常规内容文本，列表内容，表单内容
Font? get fontBodyMedium => TDTheme.of(_context).fontBodyMedium;

/// 小号正文 (12/20)，用于次要内容文本，辅助说明文字
Font? get fontBodySmall => TDTheme.of(_context).fontBodySmall;

/// 超小号正文 (10/16)，用于极小的辅助文字，版权信息，免责声明
Font? get fontBodyExtraSmall => TDTheme.of(_context).fontBodyExtraSmall;

/// 大号标记文字 (16/24)，用于重要提示信息，状态标签
Font? get fontMarkLarge => TDTheme.of(_context).fontMarkLarge;

/// 中号标记文字 (14/22)，用于普通提示信息，标签文本
Font? get fontMarkMedium => TDTheme.of(_context).fontMarkMedium;

/// 小号标记文字 (12/20)，用于小型标签，辅助提示
Font? get fontMarkSmall => TDTheme.of(_context).fontMarkSmall;

/// 超小号标记文字 (10/16)，用于微型标签，角标文字
Font? get fontMarkExtraSmall => TDTheme.of(_context).fontMarkExtraSmall;

/// 大号链接文字 (16/24)，用于主要操作链接，强调性链接
Font? get fontLinkLarge => TDTheme.of(_context).fontLinkLarge;

/// 中号链接文字 (14/22)，用于常规链接文字，可点击文本
Font? get fontLinkMedium => TDTheme.of(_context).fontLinkMedium;

/// 小号链接文字 (12/20)，用于辅助链接，次要操作链接
Font? get fontLinkSmall => TDTheme.of(_context).fontLinkSmall;

//==================== 字重 ====================
/// 常规字重，用于普通文本内容，正文文本
FontWeight get fontWeightRegular => FontWeight.normal;

/// 中等字重，用于需要轻微强调的文本，如副标题
FontWeight get fontWeightMedium => FontWeight.w500;

/// 加粗字重，用于标题、重点强调文本
FontWeight get fontWeightBold => FontWeight.w600;
