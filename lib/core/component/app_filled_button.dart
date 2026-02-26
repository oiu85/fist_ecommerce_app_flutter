import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../haptic/app_haptic.dart';
import '../localization/app_text.dart';
import '../theme/app_color_extension.dart';

/// Use for primary CTAs (e.g. "Proceed to Checkout").
class AppFilledButton extends StatelessWidget {
  AppFilledButton({
    super.key,
    this.label,
    required this.onPressed,
    this.icon,
    this.iconSize,
    this.iconSpacing,
    this.backgroundColor,
    this.foregroundColor,
    this.labelKey,
    this.width,
    this.height,
    this.borderRadius,
    this.borderColor,
  }) : assert(labelKey != null || (label != null && label.isNotEmpty), 'Either labelKey or label must be provided.');

  final String? label;
  final String? labelKey;
  final VoidCallback? onPressed;

  final Widget? icon;
  final double? iconSize;
  final double? iconSpacing;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final appColors = theme.extension<AppColorExtension>();

    final fg = foregroundColor ?? colorScheme.onPrimary;
    final radius = BorderRadius.circular((borderRadius ?? 16).r);

    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: labelKey != null ? null : (label ?? ''),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed != null
              ? () {
                  AppHaptic.mediumTap();
                  onPressed!();
                }
              : null,
          borderRadius: radius,
          splashColor: fg.withValues(alpha: 0.26),
          highlightColor: fg.withValues(alpha: 0.13),
          hoverColor: fg.withValues(alpha: 0.12),
          child: Ink(
            width: width ?? 335.w,
            height: height ?? 56.h,
            decoration: ShapeDecoration(
              color: backgroundColor ?? colorScheme.primary,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: borderColor ?? appColors?.borderColor ?? colorScheme.outline),
                borderRadius: radius,
              ),
              shadows: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.1),
                  blurRadius: 15.r,
                  offset: Offset(0, 10.h),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.1),
                  blurRadius: 6.r,
                  offset: Offset(0, 4.h),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: icon != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconTheme(
                          data: IconThemeData(color: fg, size: (iconSize ?? 20).r),
                          child: icon!,
                        ),
                        SizedBox(width: iconSpacing ?? 8.w),
                        Flexible(
                          child: AppText(
                            labelKey ?? label ?? '',
                            translation: labelKey != null,
                            style: textTheme.labelLarge?.copyWith(
                              color: fg,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  : AppText(
                      labelKey ?? label ?? '',
                      translation: labelKey != null,
                      style: textTheme.labelLarge?.copyWith(color: fg, fontWeight: FontWeight.w600, fontSize: 16.sp),
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
