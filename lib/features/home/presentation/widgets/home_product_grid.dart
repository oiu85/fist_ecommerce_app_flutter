import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'product_card.dart';

/// Placeholder image asset for product cards (default when imageUrl not provided).
const String kHomeProductPlaceholderAsset =
    'assets/images/png/prototype1.png';

@immutable
class HomeProductGridItem {
  const HomeProductGridItem({
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.priceFormatted,
    this.imageUrl = kHomeProductPlaceholderAsset,
  });

  final String name;
  final double rating;
  final int reviewCount;
  final String priceFormatted;
  final String imageUrl;
}


class HomeProductGrid extends StatelessWidget {
  const HomeProductGrid({
    super.key,
    required this.items,
    this.padding,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.onProductTap,
  });

  final List<HomeProductGridItem> items;
  final EdgeInsetsGeometry? padding;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final void Function(HomeProductGridItem item)? onProductTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surfaceContainerHighest;
    final crossSpacing = crossAxisSpacing ?? 16.w;
    final mainSpacing = mainAxisSpacing ?? 16.h;

    //* Bottom padding to prevent last rows from hiding behind the nav bar.
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom + 90.h;

    return ColoredBox(
      color: surfaceColor,
      child: GridView.builder(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 8.h,
          bottom: bottomPadding,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: mainSpacing,
          crossAxisSpacing: crossSpacing,
          childAspectRatio: 163.5 / 283.5,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ProductCard(
            imageUrl: item.imageUrl,
            name: item.name,
            rating: item.rating,
            reviewCount: item.reviewCount,
            priceFormatted: item.priceFormatted,
            onTap: onProductTap != null
                ? () => onProductTap!(item)
                : null,
          );
        },
      ),
    );
  }
}
