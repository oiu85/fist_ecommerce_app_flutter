import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  }) : assert(
          labelKey != null || (label != null && label.isNotEmpty),
          'Either labelKey or label must be provided.',
        );

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

  static const double _designWidth = 335;
  static const double _designHeight = 56;
  static const double _designRadius = 16;
  static const double _shadowOpacity = 0.1;
  static const double _defaultIconSize = 20;
  static const double _defaultIconSpacing = 8;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final appColors = theme.extension<AppColorExtension>();

    final resolvedBackground = backgroundColor ?? colorScheme.primary;
    final resolvedForeground = foregroundColor ?? colorScheme.onPrimary;
    final resolvedBorder = borderColor ?? appColors?.borderColor ?? colorScheme.outline;
    final resolvedRadius = BorderRadius.circular((borderRadius ?? _designRadius).r);
    final shadowColor = theme.shadowColor.withValues(alpha: _shadowOpacity);

    final buttonWidth = width ?? _designWidth.w;
    final buttonHeight = height ?? _designHeight.h;

    final textWidget = AppText(
      labelKey ?? label ?? '',
      translation: labelKey != null,
      style: textTheme.labelLarge?.copyWith(
        color: resolvedForeground,
        fontWeight: FontWeight.w600,
        fontSize: 16.sp,
        height: 1.25,
        letterSpacing: -0.5,
      ),
      textAlign: TextAlign.center,
    );

    final effectiveIconSize = (iconSize ?? _defaultIconSize).r;
    final effectiveIconSpacing = iconSpacing ?? _defaultIconSpacing.w;

    final content = icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconTheme(
                data: IconThemeData(
                  color: resolvedForeground,
                  size: effectiveIconSize,
                ),
                child: icon!,
              ),
              SizedBox(width: effectiveIconSpacing),
              Flexible(child: textWidget),
            ],
          )
        : textWidget;

    final decoration = ShapeDecoration(
      color: resolvedBackground,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: resolvedBorder),
        borderRadius: resolvedRadius,
      ),
      shadows: [
        BoxShadow(
          color: shadowColor,
          blurRadius: 15.r,
          offset: Offset(0, 10.h),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: shadowColor,
          blurRadius: 6.r,
          offset: Offset(0, 4.h),
          spreadRadius: 0,
        ),
      ],
    );

    final child = Container(
      width: buttonWidth,
      height: buttonHeight,
      decoration: decoration,
      child: Center(child: content),
    );

    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: labelKey != null ? null : (label ?? ''),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: resolvedRadius,
          splashColor: resolvedForeground.withValues(alpha: 0.26),
          highlightColor: resolvedForeground.withValues(alpha: 0.13),
          child: child,
        ),
      ),
    );
  }
}
