import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_text.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/theme/app_color_extension.dart';
import '../../../../gen/assets.gen.dart';

import 'cart_total_row.dart';
import 'proceed_to_checkout_button.dart';

class CartTotalSection extends StatelessWidget {
  const CartTotalSection({
    super.key,
    required this.subtotalFormatted,
    required this.totalFormatted,
    required this.onProceedToCheckout,
    this.enabled = true,
  });

  final String subtotalFormatted;
  final String totalFormatted;
  final VoidCallback? onProceedToCheckout;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();

    final labelColor = colorScheme.onSurfaceVariant;
    final primaryNavy = appColors?.primaryNavy ?? colorScheme.onSurface;
    final dividerColor = appColors?.borderColor ?? colorScheme.outline;
    final secureTextColor = colorScheme.onSurfaceVariant;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //* Subtotal row
          CartTotalRow(
            labelKey: LocaleKeys.cart_subtotal,
            value: subtotalFormatted,
            valueStyle: textTheme.bodyLarge?.copyWith(color: primaryNavy, fontWeight: FontWeight.w600),
            labelStyle: textTheme.bodyLarge?.copyWith(color: labelColor, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 12.h),
          //* Shipping row
          CartTotalRow(
            labelKey: LocaleKeys.cart_shipping,
            valueKey: LocaleKeys.cart_calculatedAtCheckout,
            labelStyle: textTheme.bodyMedium?.copyWith(color: labelColor),
            valueStyle: textTheme.bodyMedium?.copyWith(color: secureTextColor),
          ),
          SizedBox(height: 12.h),
          //* Divider
          Divider(height: 1, color: dividerColor, thickness: 1),
          SizedBox(height: 13.h),
          //* Total row
          CartTotalRow(
            labelKey: LocaleKeys.cart_total,
            value: totalFormatted,
            labelStyle: textTheme.titleLarge?.copyWith(color: primaryNavy, fontWeight: FontWeight.w600),
            valueStyle: textTheme.headlineSmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 20.h),
          //* Proceed to Checkout (reuse existing button)
          ProceedToCheckoutButton(onPressed: onProceedToCheckout, enabled: enabled),
          SizedBox(height: 16.h),
          //* Secure checkout message + lock icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.images.icons.lock.svg(
                width: 12.w,
                height: 12.h,
                colorFilter: ColorFilter.mode(secureTextColor, BlendMode.srcIn),
              ),
              SizedBox(width: 8.w),
              AppText(
                LocaleKeys.cart_secureCheckoutStripe,
                translation: true,
                style: textTheme.labelSmall?.copyWith(color: secureTextColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
