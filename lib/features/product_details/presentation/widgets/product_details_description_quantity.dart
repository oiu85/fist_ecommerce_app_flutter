import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/component/quantity_counter_chip.dart';
import '../../../../core/localization/app_text.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/theme/app_color_extension.dart';

class ProductDetailsDescriptionQuantity extends StatelessWidget {
  const ProductDetailsDescriptionQuantity({
    super.key,
    required this.description,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  final String description;
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final appColors = theme.extension<AppColorExtension>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          description,
          translation: false,
          style: textTheme.bodyLarge?.copyWith(
            color: appColors?.primaryNavy ?? colorScheme.onSurface,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 24.h),
        Divider(height: 1.h, color: colorScheme.outline),
        SizedBox(height: 32.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText(
              LocaleKeys.product_quantity,
              translation: true,
              style: textTheme.titleMedium?.copyWith(
                color: appColors?.primaryNavy ?? colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
            const Spacer(),
            QuantityCounterChip(
              value: quantity,
              onDecrement: onDecrement,
              onIncrement: onIncrement,
              width: 170.w,
              height: 62.h,
              backgroundColor: colorScheme.surfaceContainerHighest,
            ),
          ],
        ),
      ],
    );
  }
}
