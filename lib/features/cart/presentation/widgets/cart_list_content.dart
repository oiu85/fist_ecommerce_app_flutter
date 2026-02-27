import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fsit_flutter_task_ecommerce/mock_data/cart_mock_data.dart'
    show formatCartPrice;

import '../../../../core/animation/animation.dart';
import '../../../../core/auth/auth_guard.dart';
import '../../../../core/component/app_snackbar.dart';
import '../../../../core/localization/app_text.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import 'cart_item.dart';

//* Cart list content — header + scrollable list of cart items.
//? Handles quantity updates and remove; CartBloc provided by ancestor.

class CartListContent extends StatelessWidget {
  const CartListContent({
    super.key,
    required this.items,
  });

  final List<CartDisplayItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: AnimatedSection(
            sectionIndex: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
              child: AppText(
                LocaleKeys.home_navCart,
                translation: true,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final item = items[index];
                final cartItem = Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: CartItem(
                    imageUrl: item.imageUrl.isNotEmpty
                        ? item.imageUrl
                        : 'assets/images/png/prototype3.png',
                    name: item.title,
                    variant: item.product?.category ?? '',
                    quantity: item.quantity,
                    priceFormatted: formatCartPrice(item.lineTotal),
                    onQuantityChanged: (q) => _onQuantityChanged(
                      context,
                      item.productId,
                      q,
                    ),
                    onDelete: () => _onDelete(context, item.productId),
                    maxQuantity: 99,
                  ),
                );
                if (!AnimationConstants.shouldReduceMotion(context)) {
                  return cartItem.staggeredItem(index: index);
                }
                return cartItem;
              },
              childCount: items.length,
            ),
          ),
        ),
      ],
    );
  }

  void _onQuantityChanged(BuildContext context, int productId, int q) {
    AuthGuard.requireAuth(context).then((ok) {
      if (!ok || !context.mounted) return;
      if (q < 1) {
        context.read<CartBloc>().add(RemoveItem(productId: productId));
        AppSnackbar.showInfo(context, LocaleKeys.cart_itemRemoved);
      } else {
        context.read<CartBloc>().add(
              UpdateQuantity(productId: productId, quantity: q),
            );
        AppSnackbar.showInfo(context, LocaleKeys.cart_updated);
      }
    });
  }

  void _onDelete(BuildContext context, int productId) {
    AuthGuard.requireAuth(context).then((ok) {
      if (!ok || !context.mounted) return;
      context.read<CartBloc>().add(RemoveItem(productId: productId));
      AppSnackbar.showInfo(context, LocaleKeys.cart_itemRemoved);
    });
  }
}
