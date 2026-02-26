import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/animation/animation.dart';
import '../../../../core/component/star_rating.dart';
import '../../../../core/component/text_with_highlight.dart';
import '../../../../core/haptic/app_haptic.dart';
import '../../../../core/localization/app_text.dart';
import '../../../../core/theme/app_color_extension.dart';

import 'product_card_image.dart';

/// Horizontal list card for product display — image left, details right.
/// Use in [SliverList] for list view mode; complements [ProductCard] (grid).
class ProductListCard extends StatelessWidget {
  const ProductListCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.priceFormatted,
    this.searchHighlight,
    this.onTap,
  });

  final String imageUrl;
  final String name;
  final double rating;
  final int reviewCount;
  final String priceFormatted;
  /// When set, highlights matching text in [name] (e.g. search results).
  final String? searchHighlight;
  final VoidCallback? onTap;

  /// Image size for list layout (square).
  static const double kImageSize = 96;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final appColors = theme.extension<AppColorExtension>();

    final borderColor = appColors?.borderColor ?? colorScheme.outline;
    final surfaceHighest = colorScheme.surfaceContainerHighest;

    return RepaintBoundary(
      child: HoverAnimationWrapper(
        scaleAmount: 1.01,
        duration: AnimationConstants.fast,
        elevationOnHover: 4,
        borderRadius: BorderRadius.circular(16.r),
        child: Material(
          color: colorScheme.surfaceContainerHighest,
          elevation: 1,
          shadowColor: colorScheme.shadow.withValues(alpha: 0.12),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 0.5,
              color: appColors?.primaryNavy != null
                  ? appColors!.primaryNavy.withValues(alpha: 0.25)
                  : borderColor,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap != null
                ? () {
                    AppHaptic.selection();
                    onTap!();
                  }
                : null,
            borderRadius: BorderRadius.circular(16.r),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //* Image (left)
                  ProductCardImage(
                    imageUrl: imageUrl,
                    size: kImageSize.r,
                    borderColor: borderColor,
                    backgroundColor: surfaceHighest,
                  ),
                  SizedBox(width: 16.w),
                  //* Content (right)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        searchHighlight != null && searchHighlight!.isNotEmpty
                            ? TextWithHighlight(
                                text: name,
                                highlight: searchHighlight!,
                                style: textTheme.titleMedium?.copyWith(
                                  color: appColors?.primaryNavy ?? colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                              )
                            : AppText(
                                name,
                                translation: false,
                                style: textTheme.titleMedium?.copyWith(
                                  color: appColors?.primaryNavy ?? colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                isAutoScale: true,
                              ),
                        SizedBox(height: 6.h),
                        StarRatingRow(
                          rating: rating,
                          reviewCount: reviewCount,
                          starColor: appColors?.starRating ?? colorScheme.tertiary,
                          textStyle: textTheme.bodySmall?.copyWith(
                            color: appColors?.primaryNavy ?? colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        AppText(
                          priceFormatted,
                          translation: false,
                          maxLines: 1,
                          isAutoScale: true,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
