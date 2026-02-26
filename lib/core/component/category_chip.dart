import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../haptic/app_haptic.dart';
import '../localization/app_text.dart';
import '../theme/app_color_extension.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    this.onTap,
    this.selected = false,
    this.labelIsLocaleKey = false,
    this.width,
    this.height,
    this.horizontalPadding,
    this.backgroundColor,
    this.borderColor,
    this.textStyle,
  });

  final String label;
  final VoidCallback? onTap;
  final bool selected;
  final bool labelIsLocaleKey;
  final double? width;
  final double? height;
  final double? horizontalPadding;
  final Color? backgroundColor;
  final Color? borderColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final appColors = theme.extension<AppColorExtension>();

    final child = Container(
      width: width ?? 106.w,
      height: height ?? 42.h,
      decoration: ShapeDecoration(
        color: backgroundColor ?? (selected ? colorScheme.primaryContainer : colorScheme.surfaceContainerHighest),
        shape: RoundedRectangleBorder(
          side: selected
              ? BorderSide.none
              : BorderSide(
                  color: borderColor ?? appColors?.borderColor ?? colorScheme.outline,
                ),
          borderRadius: BorderRadius.circular(9999.r),
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 18.w),
          child: AppText(
            label,
            translation: labelIsLocaleKey,
            style:
                textStyle ??
                textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: selected && appColors?.primaryNavy != null
                      ? appColors!.primaryNavy
                      : (selected ? colorScheme.onPrimaryContainer : colorScheme.onSurface),
                ),
            textAlign: TextAlign.center,
            isAutoScale: true,
            maxLines: 1,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: () {
          AppHaptic.selection();
          onTap!();
        },
        behavior: HitTestBehavior.opaque,
        child: child,
      );
    }

    return child;
  }
}
