import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/component/app_filled_button.dart';
import '../../../../core/localization/locale_keys.g.dart';

class ProceedToCheckoutButton extends StatelessWidget {
  const ProceedToCheckoutButton({super.key, required this.onPressed, this.enabled = true});

  final VoidCallback? onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppFilledButton(
      labelKey: LocaleKeys.cart_proceedToCheckout,
      onPressed: enabled ? onPressed : null,
      foregroundColor: colorScheme.onPrimary,
      backgroundColor: colorScheme.primary,
      height: 56.h,
      borderRadius: 16,
      width: double.infinity,
    );
  }
}
