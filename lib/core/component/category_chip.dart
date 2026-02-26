import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    final effectiveBg = backgroundColor ??
        (selected ? colorScheme.primaryContainer : colorScheme.surfaceContainerHighest);
    final effectiveBorder = borderColor ?? appColors?.borderColor ?? colorScheme.outline;
    final effectiveTextStyle = textStyle ??
        textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: selected ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
        );

    final chipWidth = width ?? 106.w;
    final chipHeight = height ?? 42.h;
    final paddingH = horizontalPadding ?? 18.w;

    final child = Container(
      width: chipWidth,
      height: chipHeight,
      decoration: ShapeDecoration(
        color: effectiveBg,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: effectiveBorder),
          borderRadius: BorderRadius.circular(9999.r),
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingH),
          child: AppText(
            label,
            translation: labelIsLocaleKey,
            style: effectiveTextStyle,
            textAlign: TextAlign.center,
            isAutoScale: true,
            maxLines: 1,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: child,
      );
    }

    return child;
  }
}
