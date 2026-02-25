import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../localization/app_text.dart';
import '../localization/locale_keys.g.dart';
import '../theme/app_color_extension.dart';

//* Reusable star-rating widget for product cards, reviews, etc.
/// Renders up to [maxStars] stars: filled, half, or outline based on [rating].
/// Uses theme [AppColorExtension.warning] when [color] is null.
class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.rating,
    this.color,
    this.size,
    this.maxStars = _defaultMaxStars,
    this.spacing,
  });

  /// Rating value in range [0, maxStars]; supports half steps (e.g. 4.5).
  final double rating;

  /// Star color; when null uses [Theme] extension [AppColorExtension.warning]
  /// or [ColorScheme.tertiary].
  final Color? color;

  /// Icon size; when null uses [_defaultSize].
  final double? size;

  /// Maximum number of stars to display (default 5).
  final int maxStars;

  /// Horizontal spacing between stars; when null uses 2.w.
  final double? spacing;

  static const int _defaultMaxStars = 5;
  static const double _defaultSize = 12;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ??
        theme.extension<AppColorExtension>()?.warning ??
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

//* Rating row: stars + localized review count (e.g. "(120)").
/// Use on product cards, review summaries, etc. Uses [LocaleKeys.product_reviewsCount].
class StarRatingRow extends StatelessWidget {
  const StarRatingRow({
    super.key,
    required this.rating,
    required this.reviewCount,
    this.starColor,
    this.textStyle,
    this.gap,
  });

  /// Star rating in range [0, 5]; supports half steps (e.g. 4.5).
  final double rating;

  /// Number of reviews; shown via localized "({count})" string.
  final int reviewCount;

  /// Star color; when null uses theme [AppColorExtension.warning].
  final Color? starColor;

  /// Style for the review count text; when null uses [TextTheme.bodySmall].
  final TextStyle? textStyle;

  /// Space between stars and review count; when null uses 4.w.
  final double? gap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveStyle = textStyle ??
        theme.textTheme.bodySmall?.copyWith(
          height: 1.33,
          letterSpacing: -0.5,
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
