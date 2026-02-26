import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/fonts.gen.dart';
import '../localization/app_text.dart';

/// Status badge component for displaying status information
/// Reusable badge with customizable text, color, and styling
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.text,
    required this.color,
    this.backgroundColor,
    this.height,
    this.width,
    this.borderRadius,
    this.horizontalPadding,
    this.fontSize,
    this.fontWeight,
  });

  final String text;
  final Color color;
  final Color? backgroundColor;
  final double? height;
  final double? width; // Fixed width for consistent sizing
  final BorderRadius? borderRadius;
  final double? horizontalPadding;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 10.w),
      height: height ?? 29.h,
      decoration: ShapeDecoration(
        color: backgroundColor ?? colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: borderRadius ?? BorderRadius.circular(8.r)),
      ),
      child: Center(
        child: AppText(
          text,
          translation: false, // Text is already translated/formatted
          style: textTheme.bodySmall?.copyWith(
            color: color,
            fontSize: fontSize ?? 12.sp,
            fontFamily: FontFamily.sora,
            fontWeight: fontWeight ?? FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
