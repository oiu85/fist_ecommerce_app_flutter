import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/assets.gen.dart';
import '../localization/app_text.dart';

class AppCheckButton extends StatelessWidget {
  const AppCheckButton({
    super.key,
    required this.isSelected,
    required this.onChanged,
    this.labelKey,
    this.label,
  });

  final bool isSelected;
  final ValueChanged<bool> onChanged;
  final String? labelKey;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return InkWell(
      onTap: () => onChanged(!isSelected),
      borderRadius: BorderRadius.circular(8.r),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Checkbox
          SizedBox(
            width: 24.w,
            height: 24.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background fill when selected
                if (isSelected)
                  Container(
                    width: 18.5.w,
                    height: 18.5.h,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                // Border (SVG)
                Assets.images.icons.checkBox.svg(
                  width: 24.w,
                  height: 24.h,
                  colorFilter: ColorFilter.mode(
                    isSelected ? colorScheme.primary : colorScheme.outline,
                    BlendMode.srcIn,
                  ),
                ),
                // Check icon when selected
                if (isSelected)
                  Icon(
                    Icons.check,
                    size: 14.r,
                    color: colorScheme.onPrimary,
                  ),
              ],
            ),
          ),
          // Label
          if (labelKey != null || label != null) ...[
            SizedBox(width: 8.w),
            AppText(
              labelKey ?? label!,
              translation: labelKey != null,
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 24 / 14, // line-height 24px / font-size 14px
                letterSpacing: 0,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

