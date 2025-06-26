import 'package:flutter/material.dart';
import 'package:td_flutter_getx_template/core/base/base_list/base_list_view.dart';

import '../../../core/design_system/theme/color.dart';
import '../../../core/model/entity/goods/goods.dart';
import '../../../core/ui/widgets/goods/goods_list_card.dart';
import '../logics/base_list_demo_logic.dart';

class BaseListDemoView extends BaseListView<BaseListDemoLogic, Goods> {
  const BaseListDemoView({super.key});

  @override
  String? get navTitle => 'BaseList 示例';

  @override
  Color? get backgroundColor => backgroundSecondaryContainer;

  @override
  Widget itemWidget(Goods item, int index) {
    return GoodsListCard(goods: item, onTap: () {});
  }
}
