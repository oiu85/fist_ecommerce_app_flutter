import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../localization/app_text.dart';

//* Secondary button with background, no border — for Cancel / secondary actions.
class AppGhostButton extends StatelessWidget {
  AppGhostButton({
    super.key,
    this.label,
    this.labelKey,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.borderRadius,
  }) : assert(
         labelKey != null || (label != null && label.isNotEmpty),
         'Either labelKey or label must be provided.',
       );

  final String? label;
  final String? labelKey;
  final VoidCallback onPressed;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bg =
        backgroundColor ?? colorScheme.surfaceContainerHighest;
    final fg = foregroundColor ?? colorScheme.onSurface;
    final radius = BorderRadius.circular((borderRadius ?? 12).r);

    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 52.h,
        decoration: ShapeDecoration(
          color: bg,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
          ),
        ),
        child: Center(
          child: AppText(
            labelKey ?? label ?? '',
            translation: labelKey != null,
            style: textTheme.labelLarge?.copyWith(
              color: fg,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
