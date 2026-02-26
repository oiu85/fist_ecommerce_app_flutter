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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final appColors = theme.extension<AppColorExtension>();
    final borderColor = appColors?.borderColor ?? colorScheme.outline;
    final starColor = appColors?.starRating ?? colorScheme.tertiary;

    final cardWidth = width ?? 163.5.w;
    final imageSize = (cardWidth - 2).clamp(0.0, double.infinity);

    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: cardWidth,
          height: 283.5.h,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: colorScheme.surface,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: borderColor),
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ProductCardImage(
                imageUrl: imageUrl,
                size: imageSize,
                borderColor: borderColor,
                backgroundColor: colorScheme.surfaceContainerHighest,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //? Product name — theme titleMedium, max 2 lines.
                      AppText(
                        name,
                        translation: false,
                        style: textTheme.titleMedium,
                        maxLines: 2,
                        isAutoScale: true,
                      ),
                      SizedBox(height: 8.h),
                      StarRatingRow(
                        rating: rating,
                        reviewCount: reviewCount,
                        starColor: starColor,
                        textStyle: textTheme.bodySmall?.copyWith(
                        ),
                      ),
                      const Spacer(),
                      //? Price — theme headlineSmall with primary color and bold.
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
    );
  }
}
