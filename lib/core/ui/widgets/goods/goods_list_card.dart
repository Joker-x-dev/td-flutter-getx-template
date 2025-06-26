import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:td_flutter_getx_template/core/design_system/widgets/column.dart';
import 'package:td_flutter_getx_template/core/design_system/widgets/row.dart';
import 'package:td_flutter_getx_template/core/extensions/interaction_extensions.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../design_system/theme/color.dart';
import '../../../design_system/theme/shape.dart';
import '../../../design_system/theme/size.dart';
import '../../../design_system/theme/type.dart';
import '../../../design_system/widgets/space.dart';
import '../../../model/entity/goods/goods.dart';

/// 商品卡片组件
class GoodsListCard extends StatelessWidget {
  final Goods goods;
  final VoidCallback onTap;

  const GoodsListCard({super.key, required this.goods, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return [
          // 左侧商品图片
          _buildProductImage(),

          const SpaceHorizontalMedium(),

          // 中间商品信息区域
          _buildProductInfo().expanded(),
        ]
        .toRowTop()
        .padding(all: spacePaddingLarge)
        .ripple()
        .backgroundColor(backgroundContainer)
        .clipRRect(all: radiusLarge)
        .tapScale(onTap: onTap);
  }

  /// 构建商品图片
  Widget _buildProductImage() {
    // 如果有主图，显示图片
    return TDImage(imgUrl: goods.mainPic, width: 100, height: 100);
  }

  /// 构建商品信息
  Widget _buildProductInfo() {
    return [
      // 商品标题和标签行
      _buildTitleWithTags(),

      const SpaceVerticalSmall(),

      // 副标题（如果有）
      if (goods.subTitle?.isNotEmpty == true) ...[
        TDText(
          goods.subTitle!,
          font: fontBodySmall,
          textColor: textSecondary,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SpaceVerticalXSmall(),
      ],

      [
        _buildPriceInfo(),
        TDText(
          '已售 ${goods.sold}',
          font: fontMarkSmall,
          textColor: textPlaceholder,
        ),
      ].toRowBetween(),
    ].toColumnStart();
  }

  /// 构建标题和标签
  Widget _buildTitleWithTags() {
    return [
      // 商品标题
      TDText(
        goods.title,
        font: fontTitleMedium,
        textColor: textPrimary,
        fontWeight: fontWeightBold,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ).expanded(),
    ].toRowTop();
  }

  /// 构建价格信息
  Widget _buildPriceInfo() {
    return TDText(
      '¥${(goods.price).toStringAsFixed(2)}',
      font: fontTitleLarge,
      textColor: error,
      fontWeight: fontWeightBold,
    );
  }
}
