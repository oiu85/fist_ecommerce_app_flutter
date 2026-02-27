import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/animation/animation.dart';
import 'home_product_grid.dart';
import 'product_list_card.dart';

/// [firstItemKey] when set attaches to the first product card (e.g. for coach tour).
Widget buildHomeProductListSliver(
  BuildContext context, {
  required List<HomeProductGridItem> items,
  EdgeInsetsGeometry? padding,
  double? itemSpacing,
  String? searchHighlight,
  GlobalKey? firstItemKey,
  void Function(HomeProductGridItem item)? onProductTap,
  void Function(HomeProductGridItem item, int index)? onProductTapWithIndex,
}) {
  final bottomPadding = MediaQuery.of(context).viewPadding.bottom + 90.h;
  final spacing = itemSpacing ?? 12.h;

  return SliverPadding(
    padding: padding ?? EdgeInsets.only(left: 20.w, right: 20.w, top: 8.h, bottom: bottomPadding),
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        final item = items[index];
        void Function()? tapHandler;
        if (onProductTapWithIndex != null) {
          tapHandler = () => onProductTapWithIndex(item, index);
        } else if (onProductTap != null) {
          tapHandler = () => onProductTap(item);
        }
        final card = Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: ProductListCard(
            imageUrl: item.imageUrl,
            name: item.name,
            rating: item.rating,
            reviewCount: item.reviewCount,
            priceFormatted: item.priceFormatted,
            searchHighlight: searchHighlight,
            heroTag: item.heroTag,
            onTap: tapHandler,
          ),
        );
        final child = !AnimationConstants.shouldReduceMotion(context)
            ? card.staggeredItem(index: index, scrollOptimized: true)
            : card;
        final key = index == 0 && firstItemKey != null
            ? firstItemKey
            : ValueKey<int>(index);
        return KeyedSubtree(key: key, child: child);
      }, childCount: items.length),
    ),
  );
}
