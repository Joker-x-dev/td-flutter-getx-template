import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

BuildContext get _context => Get.context!;

//==================== 阴影 ====================
/// 基础投影，适用于卡片、按钮等基础元素
List<BoxShadow>? get shadowBase => TDTheme.of(_context).shadowsBase;

/// 中层投影，适用于对话框、弹出菜单等中层元素
List<BoxShadow>? get shadowMiddle => TDTheme.of(_context).shadowsMiddle;

/// 上层投影，适用于抽屉、模态框等上层元素
List<BoxShadow>? get shadowTop => TDTheme.of(_context).shadowsTop;

//==================== 常用阴影样式 ====================
/// 卡片阴影，用于卡片、面板等元素
BoxDecoration get cardShadow => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(TDTheme.of(_context).radiusDefault),
  boxShadow: shadowBase,
);

/// 弹出层阴影，用于弹出菜单、下拉菜单等元素
BoxDecoration get popupShadow => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(TDTheme.of(_context).radiusLarge),
  boxShadow: shadowMiddle,
);

/// 浮层阴影，用于抽屉、模态框等覆盖元素
BoxDecoration get overlayShadow =>
    BoxDecoration(color: Colors.white, boxShadow: shadowTop);

/// 按钮阴影，用于悬浮按钮等需要强调的交互元素
BoxDecoration get buttonShadow => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(TDTheme.of(_context).radiusDefault),
  boxShadow: shadowBase,
);
