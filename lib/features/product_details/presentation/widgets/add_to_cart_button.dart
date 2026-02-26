import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/component/app_filled_button.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../gen/assets.gen.dart';


class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    super.key,
    required this.onPressed,
    this.enabled = true,
  });

  final VoidCallback? onPressed;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppFilledButton(
      labelKey: LocaleKeys.product_addToCart,
      onPressed: enabled ? onPressed : null,
      icon: Assets.images.icons.bag.svg(
        width: 22.r,
        height: 22.r,
        colorFilter: ColorFilter.mode(
          colorScheme.onPrimary,
          BlendMode.srcIn,
        ),
      ),
      iconSize: 22.r,
      iconSpacing: 10.w,
      foregroundColor: colorScheme.onPrimary,
      backgroundColor: colorScheme.primary,
      height: 56.h,
      borderRadius: 16,
      width: double.infinity,
    );
  }
}
