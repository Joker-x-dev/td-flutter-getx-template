import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../core/base/base_dialog/base_dialog.dart';
import '../../../core/util/common/common_util.dart';

/// 列表选择对话框示例
class ListDialog extends BaseDialog {
  final String dialogTitle;
  final List<String> items;
  final Function(int, String)? onItemSelected;

  const ListDialog({
    super.key,
    this.dialogTitle = '请选择',
    required this.items,
    this.onItemSelected,
  });

  @override
  String get title => dialogTitle;

  @override
  List<Widget> body() {
    return [
      TDCellGroup(
        cells: items
            .map((item) => _buildCityCell(item, items.indexOf(item)))
            .toList(),
      ),
    ];
  }

  /// 构建城市单元格
  TDCell _buildCityCell(String item, int index) {
    return TDCell(
      title: item,
      leftIcon: TDIcons.location,
      arrow: true,
      onClick: (cell) {
        CommonUtil.closePop();
        onItemSelected?.call(index, item);
      },
    );
  }
}
