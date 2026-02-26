import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/animation/animation.dart';
import '../../../../core/component/star_rating.dart';
import '../../../../core/component/text_with_highlight.dart';
import '../../../../core/haptic/app_haptic.dart';
import '../../../../core/localization/app_text.dart';
import '../../../../core/theme/app_color_extension.dart';

import 'product_card_image.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.priceFormatted,
    this.width,
    this.searchHighlight,
    this.onTap,
  });

  final String imageUrl;
  final String name;
  final double rating;
  final int reviewCount;
  final String priceFormatted;
  final double? width;
  final String? searchHighlight;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final appColors = theme.extension<AppColorExtension>();

    return RepaintBoundary(
      child: HoverAnimationWrapper(
        scaleAmount: 1.03,
        duration: AnimationConstants.fast,
        elevationOnHover: 6,
        borderRadius: BorderRadius.circular(12.r),
        child: Material(
          color: colorScheme.surfaceContainerHighest,
          elevation: 1,
          shadowColor: colorScheme.shadow.withValues(alpha: 0.12),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 0.5,
              color: appColors?.primaryNavy != null
                  ? appColors!.primaryNavy.withValues(alpha: 0.25)
                  : (appColors?.borderColor ?? colorScheme.outline),
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap != null
                ? () {
                    AppHaptic.selection();
                    onTap!();
                  }
                : null,
            borderRadius: BorderRadius.circular(12.r),
            child: SizedBox(
              width: width ?? 163.5.w,
              height: 283.5.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProductCardImage(
                    imageUrl: imageUrl,
                    size: ((width ?? 163.5.w) - 2).clamp(0.0, double.infinity),
                    borderColor: appColors?.borderColor ?? colorScheme.outline,
                    backgroundColor: colorScheme.surfaceContainer,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
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
                                  ),
                                  maxLines: 2,
                                )
                              : AppText(
                                  name,
                                  translation: false,
                                  style: textTheme.titleMedium?.copyWith(
                                    color: appColors?.primaryNavy ?? colorScheme.onSurface,
                                  ),
                                  maxLines: 2,
                                  isAutoScale: true,
                                ),
                          SizedBox(height: 8.h),
                          StarRatingRow(
                            rating: rating,
                            reviewCount: reviewCount,
                            starColor: appColors?.starRating ?? colorScheme.tertiary,
                            textStyle: textTheme.bodySmall?.copyWith(
                              color: appColors?.primaryNavy ?? colorScheme.onSurface,
                            ),
                          ),
                          const Spacer(),
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
