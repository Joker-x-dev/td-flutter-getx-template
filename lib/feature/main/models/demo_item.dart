import 'package:flutter/material.dart';

/// Demo项目数据模型
/// 用于存放Demo卡片的相关信息
class DemoItem {
  /// 标题
  final String title;
  
  /// 描述
  final String description;
  
  /// 图标
  final IconData icon;
  
  /// 点击事件
  final VoidCallback onTap;

  const DemoItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });
} 