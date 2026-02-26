import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_text.dart';
import '../../../../core/theme/app_color_extension.dart';


class ProductAdvantageCard extends StatelessWidget {
  const ProductAdvantageCard({
    super.key,
    required this.icon,
    required this.labelKey,
  });

  final Widget icon;
  final String labelKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 12.w),
      decoration: ShapeDecoration(
        color: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: appColors?.borderColor ?? colorScheme.outline),
          borderRadius: BorderRadius.circular(27.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 30.r, height: 30.r, child: Center(child: icon)),
          SizedBox(height: 8.h),
          AppText(
            labelKey,
            translation: true,
            style: theme.textTheme.bodySmall?.copyWith(
              color: appColors?.primaryNavy ?? colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
              height: 1.33,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
