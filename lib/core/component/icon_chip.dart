import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconChip extends StatelessWidget {
  const IconChip({
    super.key,
    this.iconPath,
    this.icon,
    this.svgIcon,
    this.pngIcon,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.iconSize,
    this.padding,
    this.spacing,
    this.borderRadius,
    this.child,
  }) : assert(
         iconPath != null || icon != null || svgIcon != null || pngIcon != null,
         'Either iconPath, icon, svgIcon, or pngIcon must be provided.',
       );

  final String? iconPath;
  final Widget? icon;
  final Widget? svgIcon;
  final ImageProvider? pngIcon;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final double? spacing;
  final double? borderRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    //* Main Container
    return GestureDetector(
      onTap: onTap,
      child: Container(
        //* Container Decoration
        decoration: ShapeDecoration(
          color: backgroundColor ?? colorScheme.surfaceVariant,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? 500.r)),
        ),
        //* Container Content
        padding: padding ?? EdgeInsets.all(8.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //* Icon Container
            SizedBox(width: iconSize ?? 24.w, height: iconSize ?? 24.h, child: _buildIcon(colorScheme)),
            //* Additional Child Widget
            if (child != null) ...[SizedBox(width: spacing ?? 10.w), child!],
          ],
        ),
      ),
    );
  }

  //* Build Icon Widget
  Widget _buildIcon(ColorScheme colorScheme) {
    //* Handle iconPath (auto-detect SVG or PNG)
    if (iconPath != null) {
      final isSvg = iconPath!.toLowerCase().endsWith('.svg');
      if (isSvg) {
        return SvgPicture.asset(
          iconPath!,
          width: iconSize ?? 24.w,
          height: iconSize ?? 24.h,
          colorFilter: iconColor != null ? ColorFilter.mode(iconColor!, BlendMode.srcIn) : null,
        );
      } else {
        return Image.asset(
          iconPath!,
          width: iconSize ?? 24.w,
          height: iconSize ?? 24.h,
          fit: BoxFit.contain,
          color: iconColor ?? colorScheme.onSurfaceVariant,
          colorBlendMode: iconColor != null ? BlendMode.srcIn : BlendMode.dst,
        );
      }
    }

    //* Handle Widget icon
    if (icon != null) {
      return IconTheme(
        data: IconThemeData(color: iconColor ?? colorScheme.onSurfaceVariant, size: iconSize ?? 24.r),
        child: icon!,
      );
    }

    //* Handle SVG widget
    if (svgIcon != null) {
      return svgIcon!;
    }

    //* Handle PNG ImageProvider
    if (pngIcon != null) {
      return Image(
        image: pngIcon!,
        width: iconSize ?? 24.w,
        height: iconSize ?? 24.h,
        fit: BoxFit.contain,
        color: iconColor ?? colorScheme.onSurfaceVariant,
        colorBlendMode: iconColor != null ? BlendMode.srcIn : BlendMode.dst,
      );
    }

    return const SizedBox.shrink();
  }
}
