
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/fonts.gen.dart';
import '../localization/app_text.dart';

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({
    super.key,
    required this.onTap,
    required this.labelKey,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
    this.icon,
    this.iconSpacing,
  });

  final VoidCallback onTap;
  final String labelKey;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final double? borderRadius;
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
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular((borderRadius ?? 40).r),
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
              color: colorScheme.onPrimary,
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

