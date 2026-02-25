import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/fonts.gen.dart';
import '../localization/app_text.dart';


class CustomSmallActionButton extends StatelessWidget {
  const CustomSmallActionButton({
    super.key,
    this.onTap,
    required this.labelKey,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.width,
    this.borderRadius,
    this.fontSize,
  });

  final VoidCallback? onTap;
  final String labelKey;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 29.h,
        width: width ?? 97.w,
        decoration: ShapeDecoration(
          color: backgroundColor ?? colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8.r),
          ),
        ),
        child: Center(
          child: AppText(
            labelKey,
            translation: true,
            style: textTheme.bodySmall?.copyWith(
              color: textColor ?? colorScheme.onSurface,
              fontSize: fontSize ?? 12.sp,
              fontFamily: FontFamily.sora,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

