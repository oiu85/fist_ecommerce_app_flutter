import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fsit_flutter_task_ecommerce/mock_data/cart_mock_data.dart' show formatCartPrice;

import '../../../../core/animation/animation.dart';
import '../../../../core/auth/auth_guard.dart';
import '../../../../core/component/app_snackbar.dart';
import '../../../../core/localization/app_text.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../widgets/cart_item.dart';
import '../widgets/cart_total_section.dart';

//* Cart tab content; uses [CartBloc] for state. No setState.
//? Product resolution from IProductRepository; persistence via SQLite.

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartBloc>.value(
      value: context.read<CartBloc>(),
      child: BlocConsumer<CartBloc, CartState>(
        listenWhen: (prev, curr) =>
            prev.errorMessage != curr.errorMessage ||
            curr.status.isSuccess(),
        listener: (context, state) {
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            AppSnackbar.showError(context, state.errorMessage!);
          }
        },
        buildWhen: (prev, curr) =>
            prev.status != curr.status ||
            prev.items != curr.items ||
            prev.itemCount != curr.itemCount,
        builder: (context, state) {
          final theme = Theme.of(context);
          final subtotal =
              state.items.fold(0.0, (sum, item) => sum + item.lineTotal);
          final subtotalStr = formatCartPrice(subtotal);
          final totalStr = formatCartPrice(subtotal);
          final bottomPadding =
              MediaQuery.of(context).padding.bottom + 20.h;
          final items = state.items;
          final isLoading = state.status.isLoading() || state.status.isInitial();

          return Column(
            children: [
              Expanded(
                child: state.status.when<Widget>(
                  initial: () => _buildEmptyOrLoading(context, theme, true),
                  loading: () => _buildEmptyOrLoading(context, theme, true),
                  success: () => items.isEmpty
                      ? _buildEmptyOrLoading(context, theme, false)
                      : _buildCartList(context, theme, items),
                  error: (_) => _buildEmptyOrLoading(context, theme, false),
                ),
              ),
              AnimatedSection(
                sectionIndex: 1,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h, bottom: bottomPadding),
                  child: CartTotalSection(
                    subtotalFormatted: subtotalStr,
                    totalFormatted: totalStr,
                    onProceedToCheckout: () {
                      AuthGuard.requireAuth(context).then((ok) {
                        if (!ok || !context.mounted) return;
                        //! TODO: Navigate to checkout
                      });
                    },
                    enabled: items.isNotEmpty && !isLoading,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyOrLoading(
    BuildContext context,
    ThemeData theme,
    bool isLoading,
  ) {
    return CustomScrollView(
      slivers: [
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
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : AppText(
                    LocaleKeys.cart_empty,
                    translation: true,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartList(
    BuildContext context,
    ThemeData theme,
    List<CartDisplayItem> items,
  ) {
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
                    onQuantityChanged: (q) {
                      AuthGuard.requireAuth(context).then((ok) {
                        if (!ok || !context.mounted) return;
                        if (q < 1) {
                          context
                              .read<CartBloc>()
                              .add(RemoveItem(productId: item.productId));
                          AppSnackbar.showInfo(
                            context,
                            LocaleKeys.cart_itemRemoved,
                          );
                        } else {
                          context.read<CartBloc>().add(
                                UpdateQuantity(
                                  productId: item.productId,
                                  quantity: q,
                                ),
                              );
                          AppSnackbar.showInfo(
                            context,
                            LocaleKeys.cart_updated,
                          );
                        }
                      });
                    },
                    onDelete: () {
                      AuthGuard.requireAuth(context).then((ok) {
                        if (!ok || !context.mounted) return;
                        context
                            .read<CartBloc>()
                            .add(RemoveItem(productId: item.productId));
                        AppSnackbar.showInfo(
                          context,
                          LocaleKeys.cart_itemRemoved,
                        );
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
              childCount: items.length,
            ),
          ),
        ),
      ],
    );
  }
}
