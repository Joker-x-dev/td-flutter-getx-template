import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:td_flutter_getx_template/core/base/base_refresh/base_refresh_view.dart';
import 'package:td_flutter_getx_template/core/design_system/extensions/extensions.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../core/design_system/theme/color.dart';
import '../../../core/design_system/theme/shape.dart';
import '../../../core/design_system/theme/size.dart';
import '../../../core/design_system/theme/type.dart';
import '../../../core/design_system/widgets/space.dart';
import '../../../core/model/entity/goods/goods.dart';
import '../logics/base_refresh_demo_logic.dart';

class BaseRefreshDemoView extends BaseRefreshView<BaseRefreshDemoLogic> {
  const BaseRefreshDemoView({super.key});

  @override
  String? get navTitle => 'BaseRefresh 示例';

  @override
  Color? get backgroundColor => backgroundSecondaryContainer;

  @override
  List<Widget> pageContent(controller) {
    final Goods goods = controller.baseRefreshDemoState.goods.value;
    return [
      // 商品图片轮播
      Swiper(
        itemCount: goods.pics!.length,
        pagination: SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: TDSwiperPagination.dotsBar,
        ),
        itemBuilder: (BuildContext context, int index) {
          return TDImage(imgUrl: goods.pics![index], fit: BoxFit.cover);
        },
      ).height(340).clipRadius(radiusExtraLarge),

      const SpaceVerticalLarge(),

      // 商品基本信息
      [
            // 商品标题
            TDText(
              goods.title,
              font: fontTitleLarge,
              textColor: textPrimary,
              fontWeight: fontWeightBold,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // 副标题（如果有）
            if (goods.subTitle?.isNotEmpty == true) ...[
              const SpaceVerticalSmall(),
              TDText(
                goods.subTitle!,
                font: fontBodyMedium,
                textColor: textSecondary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SpaceVerticalLarge(),

            // 价格和销量
            [
              TDText(
                "¥${goods.price.toStringAsFixed(2)}",
                font: fontTitleLarge,
                textColor: error,
                fontWeight: fontWeightBold,
              ),
              TDText(
                "已售${goods.sold}件",
                font: fontBodyMedium,
                textColor: textSecondary,
              ),
            ].toRowBetween(crossAxisAlignment: CrossAxisAlignment.end),
          ]
          .toColumnStart()
          .padAll(spacePaddingLarge)
          .backgroundColor(backgroundContainer)
          .clipRadius(radiusExtraLarge),

      const SpaceVerticalLarge(),

      // 商品详情部分
      [
            // 详情标题
            TDText(
              "商品详情",
              font: fontTitleMedium,
              textColor: textPrimary,
              fontWeight: fontWeightBold,
            ).pad(horizontal: spacePaddingLarge, vertical: spacePaddingMedium),

            // 详情图片列表
            ...goods.contentPics!.map(
              (imageUrl) => TDImage(
                imgUrl: imageUrl,
                type: TDImageType.fitWidth,
                width: double.infinity,
              ),
            ),
          ]
          .toColumnStart()
          .backgroundColor(backgroundContainer)
          .clipRadius(radiusExtraLarge),
    ];
  }
}
