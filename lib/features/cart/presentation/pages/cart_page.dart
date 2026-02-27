import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/auth/auth_guard.dart';
import '../../../../core/animation/animation.dart';
import '../../../../core/localization/app_text.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../mock_data/cart_mock_data.dart';
import '../widgets/cart_item.dart';
import '../widgets/cart_total_section.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<CartMockItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List<CartMockItem>.from(mockCartItems);
  }

  void _onQuantityChanged(int index, int newQuantity) {
    if (newQuantity < 1) {
      _removeItem(index);
      return;
    }
    setState(() {
      final item = _items[index];
      final updated = CartMockItem(
        id: item.id,
        imageUrl: item.imageUrl,
        name: item.name,
        variant: item.variant,
        quantity: newQuantity,
        unitPrice: item.unitPrice,
      );
      _items = List<CartMockItem>.from(_items)..[index] = updated;
    });
  }

  void _onDelete(int index) {
    _removeItem(index);
  }

  void _removeItem(int index) {
    if (index < 0 || index >= _items.length) return;
    setState(() => _items = List<CartMockItem>.from(_items)..removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtotal = cartSubtotal(_items);
    final subtotalStr = formatCartPrice(subtotal);
    final totalStr = formatCartPrice(subtotal);
    //* Clear bottom nav bar (extendBody: true) + safe area / home indicator
    final bottomPadding = MediaQuery.of(context).padding.bottom + 20.h;

    return Column(
      children: [
        //* Scrollable: title + cart items (or empty state)
        Expanded(
          child: CustomScrollView(
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
              if (_items.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: AppText(
                      LocaleKeys.cart_empty,
                      translation: true,
                      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final item = _items[index];
                        final cartItem = Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: CartItem(
                            imageUrl: item.imageUrl,
                            name: item.name,
                            variant: item.variant,
                            quantity: item.quantity,
                            priceFormatted: formatCartPrice(item.lineTotal),
                            onQuantityChanged: (q) {
                              AuthGuard.requireAuth(context).then((ok) {
                                if (!ok || !mounted) return;
                                _onQuantityChanged(index, q);
                              });
                            },
                            onDelete: () {
                              AuthGuard.requireAuth(context).then((ok) {
                                if (!ok || !mounted) return;
                                _onDelete(index);
                              });
                            },
                            maxQuantity: 99,
                          ),
                        );
                        if (!AnimationConstants.shouldReduceMotion(context)) {
                          return cartItem.staggeredItem(index: index);
                        }
                        return cartItem;
                      },
                      childCount: _items.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
        //* Sticky total section (not scrollable)
        AnimatedSection(
          sectionIndex: 1,
          child: Padding(
            padding: EdgeInsets.only(top: 8.h, bottom: bottomPadding),
            child: CartTotalSection(
            subtotalFormatted: subtotalStr,
            totalFormatted: totalStr,
              onProceedToCheckout: () {
                AuthGuard.requireAuth(context).then((ok) {
                  if (!ok || !mounted) return;
                  //! TODO: Navigate to checkout
                });
              },
              enabled: _items.isNotEmpty,
            ),
          ),
        ),
      ],
    );
  }
}
