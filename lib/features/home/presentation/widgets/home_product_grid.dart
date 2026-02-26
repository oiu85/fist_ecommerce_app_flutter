import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/animation/animation.dart';
import 'product_card.dart';

/// Placeholder image asset for product cards (default when imageUrl not provided).
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

/// Builds the product grid as a sliver for use inside [CustomScrollView].
Widget buildHomeProductGridSliver(
  BuildContext context, {
  required List<HomeProductGridItem> items,
  EdgeInsetsGeometry? padding,
  double? crossAxisSpacing,
  double? mainAxisSpacing,
  void Function(HomeProductGridItem item)? onProductTap,
  void Function(HomeProductGridItem item, int index)? onProductTapWithIndex,
}) {
  return SliverPadding(
    padding:
        padding ??
        EdgeInsets.only(left: 20.w, right: 20.w, top: 8.h, bottom: MediaQuery.of(context).viewPadding.bottom + 90.h),
    sliver: SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: mainAxisSpacing ?? 16.h,
        crossAxisSpacing: crossAxisSpacing ?? 16.w,
        childAspectRatio: 163.5 / 283.5,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = items[index];
        void Function()? tapHandler;
        if (onProductTapWithIndex != null) {
          tapHandler = () => onProductTapWithIndex(item, index);
        } else if (onProductTap != null) {
          tapHandler = () => onProductTap(item);
        }
        final card = ProductCard(
          imageUrl: item.imageUrl,
          name: item.name,
          rating: item.rating,
          reviewCount: item.reviewCount,
          priceFormatted: item.priceFormatted,
          onTap: tapHandler,
        );
        //* Staggered entrance + scroll-optimized (no delay on fast scroll)
        if (!AnimationConstants.shouldReduceMotion(context)) {
          return card.staggeredItem(index: index, scrollOptimized: true);
        }
        return card;
      }, childCount: items.length),
    ),
  );
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

    return ColoredBox(
      color: theme.colorScheme.surfaceContainerHighest,
      child: CustomScrollView(
        slivers: [
          buildHomeProductGridSliver(
            context,
            items: items,
            padding: padding,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            onProductTap: onProductTap,
          ),
        ],
      ),
    );
  }
}
