import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/component/star_rating.dart';
import '../../../../core/localization/app_text.dart';
import '../../../../core/theme/app_color_extension.dart';
import '../../../../gen/fonts.gen.dart';

class ProductDetailsTitlePriceRating extends StatelessWidget {
  const ProductDetailsTitlePriceRating({
    super.key,
    required this.categoryName,
    required this.title,
    required this.priceFormatted,
    required this.rating,
    required this.reviewCount,
  });

  final String categoryName;
  final String title;
  final String priceFormatted;
  final double rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final appColors = theme.extension<AppColorExtension>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
        AppText(
          categoryName,
          translation: false,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 12.h),
        AppText(
          title,
          translation: false,
          maxLines: 2,
          isAutoScale: true,
          style: textTheme.headlineMedium?.copyWith(
            fontFamily: FontFamily.cormorantGaramond,
            fontWeight: FontWeight.w400,
            fontSize: 36.sp,
            color: appColors?.primaryNavy ?? colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: AppText(
                priceFormatted,
                translation: false,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 30.sp,
                ),
              ),
            ),
            StarRatingRow(
              rating: rating,
              reviewCount: reviewCount,
            ),
          ],
        ),
      ],
    );
  }
}
