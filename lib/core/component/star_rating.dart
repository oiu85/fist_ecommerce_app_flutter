import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../localization/app_text.dart';
import '../localization/locale_keys.g.dart';
import '../theme/app_color_extension.dart';

class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.rating,
    this.color,
    this.size,
    this.maxStars = _defaultMaxStars,
    this.spacing,
  });

  final double rating;
  final Color? color;
  final double? size;
  final int maxStars;
  final double? spacing;

  static const int _defaultMaxStars = 5;
  static const double _defaultSize = 12;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ??
        theme.extension<AppColorExtension>()?.starRating ??
        theme.colorScheme.tertiary;
    final effectiveSize = (size ?? _defaultSize).r;
    final effectiveSpacing = spacing ?? 2.w;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (index) {
        final value = index + 1;
        IconData icon;
        if (rating >= value) {
          icon = Icons.star;
        } else if (rating >= value - 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return Padding(
          padding: EdgeInsets.only(
            right: index < maxStars - 1 ? effectiveSpacing : 0,
          ),
          child: Icon(icon, size: effectiveSize, color: effectiveColor),
        );
      }),
    );
  }
}

class StarRatingRow extends StatelessWidget {
  const StarRatingRow({
    super.key,
    required this.rating,
    required this.reviewCount,
    this.starColor,
    this.textStyle,
    this.gap,
  });

  final double rating;
  final int reviewCount;
  final Color? starColor;
  final TextStyle? textStyle;

  final double? gap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveStyle = textStyle ??
        theme.textTheme.bodySmall?.copyWith(
    
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StarRating(rating: rating, color: starColor),
        SizedBox(width: gap ?? 4.w),
        AppText(
          LocaleKeys.product_reviewsCount.tr(
            namedArgs: {'count': reviewCount.toString()},
          ),
          translation: false,
          style: effectiveStyle,
        ),
      ],
    );
  }
}
