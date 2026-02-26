import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/theme/app_color_extension.dart';
import 'product_advantage_card.dart';

class ProductDetailsAdvantageRow extends StatelessWidget {
  const ProductDetailsAdvantageRow({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();
    final iconColor = appColors?.primaryNavy ?? colorScheme.onSurface;

    return Row(
      children: [
        Expanded(
          child: ProductAdvantageCard(
            icon: Icon(
              Icons.local_shipping_outlined,
              size: 30.r,
              color: iconColor,
            ),
            labelKey: LocaleKeys.product_freeShipping,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: ProductAdvantageCard(
            icon: Icon(
              Icons.verified_user_outlined,
              size: 30.r,
              color: iconColor,
            ),
            labelKey: LocaleKeys.product_twoYearWarranty,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: ProductAdvantageCard(
            icon: Icon(
              Icons.replay_rounded,
              size: 30.r,
              color: iconColor,
            ),
            labelKey: LocaleKeys.product_thirtyDayReturns,
          ),
        ),
      ],
    );
  }
}
