import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'product_card.dart';

const String kHomeProductPlaceholderAsset = 'assets/images/png/prototype1.png';
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

    return ColoredBox(
      color: surfaceColor,
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
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

/// Default list of placeholder products for the home grid (Figma/spec).
List<HomeProductGridItem> get defaultHomeProductGridItems =>
    <HomeProductGridItem>[
      const HomeProductGridItem(
        name: 'Wireless Bluetooth ',
        rating: 4,
        reviewCount: 124,
        priceFormatted: r'$89.99',
      ),
      const HomeProductGridItem(
        name: 'Gold Plated Chain Necklace',
        rating: 4,
        reviewCount: 89,
        priceFormatted: r'$45.50',
      ),
      const HomeProductGridItem(
        name: 'Classic Denim Jacket for Men',
        rating: 4,
        reviewCount: 203,
        priceFormatted: r'$79.00',
      ),
      const HomeProductGridItem(
        name: 'Floral Summer Dress',
        rating: 4,
        reviewCount: 156,
        priceFormatted: r'$54.99',
      ),
      const HomeProductGridItem(
        name: 'Smart Fitness Watch Pro',
        rating: 4,
        reviewCount: 342,
        priceFormatted: r'$199.99',
      ),
      const HomeProductGridItem(
        name: 'Sterling Silver Bracelet',
        rating: 4,
        reviewCount: 67,
        priceFormatted: r'$129.00',
      ),
      const HomeProductGridItem(
        name: "Men's Casual Sneakers",
        rating: 4,
        reviewCount: 278,
        priceFormatted: r'$69.99',
      ),
      const HomeProductGridItem(
        name: 'Leather Crossbody Bag',
        rating: 4,
        reviewCount: 192,
        priceFormatted: r'$149.00',
      ),
    ];
