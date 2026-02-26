import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/animation/animation.dart';
import 'home_product_grid.dart';
import 'product_list_card.dart';

/// Builds the product list as a sliver for use inside [CustomScrollView].
/// Uses [ProductListCard] in a [SliverList] for horizontal-list layout.
Widget buildHomeProductListSliver(
  BuildContext context, {
  required List<HomeProductGridItem> items,
  EdgeInsetsGeometry? padding,
  double? itemSpacing,
  void Function(HomeProductGridItem item)? onProductTap,
}) {
  final bottomPadding = MediaQuery.of(context).viewPadding.bottom + 90.h;
  final spacing = itemSpacing ?? 12.h;

  return SliverPadding(
    padding: padding ??
        EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 8.h,
          bottom: bottomPadding,
        ),
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final item = items[index];
          final tapCallback = onProductTap;
          final card = Padding(
            padding: EdgeInsets.only(bottom: spacing),
            child: ProductListCard(
              imageUrl: item.imageUrl,
              name: item.name,
              rating: item.rating,
              reviewCount: item.reviewCount,
              priceFormatted: item.priceFormatted,
              onTap: tapCallback != null ? () => tapCallback(item) : null,
            ),
          );
          if (!AnimationConstants.shouldReduceMotion(context)) {
            return card.staggeredItem(index: index);
          }
          return card;
        },
        childCount: items.length,
      ),
    ),
  );
}
