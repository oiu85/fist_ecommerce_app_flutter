import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/component/app_filled_button.dart';
import '../../../../core/localization/locale_keys.g.dart';

//* Primary "Add Product" button — uses theme primary.
class AddProductButton extends StatelessWidget {
  const AddProductButton({
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
      labelKey: LocaleKeys.addProduct_addProduct,
      onPressed: enabled ? onPressed : null,
      foregroundColor: colorScheme.onPrimary,
      backgroundColor: colorScheme.primary,
      height: 56.h,
      borderRadius: 12,
      width: double.infinity,
    );
  }
}
