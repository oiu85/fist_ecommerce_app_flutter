import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../localization/app_text.dart';
import '../theme/app_color_extension.dart';

class QuantityCounterChip extends StatelessWidget {
  const QuantityCounterChip({
    super.key,
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
    this.minValue = 1,
    this.maxValue,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.textStyle,
    this.width,
    this.height,
  });

  final int value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final int minValue;
  final int? maxValue;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final TextStyle? textStyle;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final appColors = theme.extension<AppColorExtension>();

    return Container(
      width: width ?? 112.w,
      height: height ?? 40.h,
      decoration: ShapeDecoration(
        color: backgroundColor ?? colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor ?? appColors?.borderColor ?? colorScheme.outline),
          borderRadius: BorderRadius.circular(9999.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _CounterButton(
              icon: Icons.remove,
              iconColor: iconColor ?? colorScheme.onSurface,
              borderColor: borderColor ?? appColors?.borderColor ?? colorScheme.outline,
              size: 32.r,
              onTap: value > minValue ? onDecrement : null,
              iconSize: 12.r,
            ),
            Expanded(
              child: Center(
                child: AppText(
                  '$value',
                  translation: false,
                  style:
                      textStyle ??
                      textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        height: 1.5,
                        letterSpacing: -0.5,
                        color: colorScheme.onSurface,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            _CounterButton(
              icon: Icons.add,
              iconColor: iconColor ?? colorScheme.onSurface,
              borderColor: borderColor ?? appColors?.borderColor ?? colorScheme.outline,
              size: 32.r,
              onTap: maxValue == null || value < maxValue! ? onIncrement : null,
              iconSize: 12.r,
            ),
          ],
        ),
      ),
    );
  }
}

/// Circular bordered button for minus/plus with centered icon.
class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.icon,
    required this.iconColor,
    required this.borderColor,
    required this.size,
    required this.onTap,
    required this.iconSize,
  });

  final IconData icon;
  final Color iconColor;
  final Color borderColor;
  final double size;
  final VoidCallback? onTap;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      width: size,
      height: size,
      decoration: ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(9999),
        ),
      ),
      child: Center(
        child: Icon(icon, size: iconSize, color: onTap != null ? iconColor : iconColor.withValues(alpha: 0.4)),
      ),
    );

    if (onTap == null) {
      return child;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9999),
        splashColor: iconColor.withValues(alpha: 0.16),
        highlightColor: iconColor.withValues(alpha: 0.08),
        child: child,
      ),
    );
  }
}
