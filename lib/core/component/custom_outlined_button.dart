
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/fonts.gen.dart';
import '../localization/app_text.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    super.key,
    required this.onTap,
    required this.labelKey,
    this.isFilled = false,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.borderWidth,
    this.fontSize,
    this.fontWeight,
    this.icon,
    this.iconSpacing,
  });

  final VoidCallback onTap;
  final String labelKey;
  final bool isFilled;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final double? borderRadius;
  final double? borderWidth;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Widget? icon;
  final double? iconSpacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 146.w,
        height: height ?? 34.h,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular((borderRadius ?? 40).r),
          color: isFilled ? colorScheme.primary : Colors.transparent,
          border: Border.all(
            width: (borderWidth ?? 0.79).w,
            color: isFilled
                ? colorScheme.primary
                : colorScheme.primary,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                SizedBox(width: iconSpacing ?? 8.w),
              ],
              AppText(
                textAlign: TextAlign.center,
                labelKey,
                translation: true,
                style: textTheme.bodySmall?.copyWith(
                  fontSize: (fontSize ?? 10).sp,
                  fontFamily: FontFamily.sora,
                  color: isFilled ? colorScheme.onPrimary : colorScheme.primary,
                  fontWeight: fontWeight ?? FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

