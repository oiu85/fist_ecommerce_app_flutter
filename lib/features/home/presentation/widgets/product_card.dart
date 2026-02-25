import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/component/star_rating.dart';
import '../../../../core/localization/app_text.dart';
import '../../../../core/theme/app_color_extension.dart';

import 'product_card_image.dart';


/// Displays product image, name, star rating, review count, and price.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.priceFormatted,
    this.width,
    this.onTap,
  });


  final String imageUrl;
  final String name;
  final double rating;
  final int reviewCount;
  final String priceFormatted;
  final double? width;

  final VoidCallback? onTap;

  static const double _designCardWidth = 163.5;
  static const double _designCardHeight = 283.5;
  static const double _designImageSize = 161.5;
  static const double _designRadius = 12;
  static const double _imagePadding = 16;
  static const double _contentPadding = 12;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final appColors = theme.extension<AppColorExtension>();
    final borderColor = appColors?.borderColor ?? colorScheme.outline;
    final starColor = appColors?.warning ?? colorScheme.tertiary;

    final cardWidth = width ?? _designCardWidth.w;
    final imageSize = (cardWidth - 2).clamp(0.0, _designImageSize.w);

    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: cardWidth,
          height: _designCardHeight.h,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: colorScheme.surface,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: borderColor),
              borderRadius: BorderRadius.circular(_designRadius.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              //* Image section — square area with light background and bordered image.
              ProductCardImage(
                imageUrl: imageUrl,
                size: imageSize,
                borderColor: borderColor,
                backgroundColor: colorScheme.surfaceContainerHighest,
                imagePadding: _imagePadding,
              ),
              //* Details section — name, rating, price.
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(_contentPadding.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //? Product name — theme titleMedium, max 2 lines.
                      AppText(
                        name,
                        translation: false,
                        style: textTheme.titleMedium?.copyWith(
                          height: 1.43,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      //? Rating row — stars + localized review count (core component).
                      StarRatingRow(
                        rating: rating,
                        reviewCount: reviewCount,
                        starColor: starColor,
                        textStyle: textTheme.bodySmall?.copyWith(
                          height: 1.33,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Spacer(),
                      //? Price — theme headlineSmall with primary color and bold.
                      AppText(
                        priceFormatted,
                        translation: false,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                          height: 1.56,
                          letterSpacing: -0.5,
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
    );
  }
}
