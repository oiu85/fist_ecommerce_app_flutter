import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_text.dart';
import '../../../../core/theme/app_color_extension.dart';

/// Category card — label only, no icons. Matches API format
/// (e.g. ["electronics", "jewelery", "men's clothing", "women's clothing"]).
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.label,
    this.labelIsLocaleKey = false,
    this.selected = false,
    this.width,
    this.height,
    this.onTap,
  });

  final String label;
  final bool labelIsLocaleKey;
  final bool selected;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final appColors = theme.extension<AppColorExtension>();

    final effectiveBorder = appColors?.borderColor ?? colorScheme.outline;
    final effectiveBg = selected
        ? colorScheme.primaryContainer
        : colorScheme.surface;

    final cardWidth = width ?? 88.w;
    final cardHeight = height ?? 72.h;

    final child = RepaintBoundary(
      child: Container(
        width: cardWidth,
        height: cardHeight,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: effectiveBg,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: effectiveBorder),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: AppText(
              label,
              translation: labelIsLocaleKey,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: selected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              isAutoScale: true,
            ),
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
