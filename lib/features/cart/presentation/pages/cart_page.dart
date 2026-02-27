import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fsit_flutter_task_ecommerce/mock_data/cart_mock_data.dart'
    show formatCartPrice;

import '../../../../core/animation/animation.dart';
import '../../../../core/auth/auth_guard.dart';
import '../../../../core/component/app_snackbar.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/shared/app_scaffold.dart';
import '../../../../core/status/ui_helper.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../../../../skeleton_features/skeleton_features.dart';
import '../widgets/cart_empty_widget.dart';
import '../widgets/cart_list_content.dart';
import '../widgets/cart_total_section.dart';

//* Cart tab content; uses [CartBloc] for state. No setState.
//? Product resolution from IProductRepository; persistence via SQLite.

class CartPage extends StatelessWidget {
  const CartPage({
    super.key,
    this.cartListKey,
    this.cartItemsKey,
    this.cartTotalKey,
  });

  final GlobalKey? cartListKey;
  final GlobalKey? cartItemsKey;
  final GlobalKey? cartTotalKey;

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
            prev.itemCount != curr.itemCount ||
            (curr.status.isFail() && prev.cartStatus != curr.cartStatus),
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

          return AppScaffold.clean(
            backgroundColor: theme.colorScheme.surface,
            body: Column(
              children: [
                Expanded(
                  child: _wrapWithKey(
                    cartListKey,
                    state.status.when<Widget>(
                    //* Same pattern as HomePage: skeleton + UiHelperStatus.
                    initial: () => CartSkeleton(status: state.status),
                    loading: () => CartSkeleton(status: state.status),
                    success: () => items.isEmpty
                        ? CartEmptyWidget(
                            isLoading: false,
                            cartItemsKey: cartItemsKey,
                          )
                        : CartListContent(
                            items: items,
                            cartItemsKey: cartItemsKey,
                          ),
                    error: (_) => UiHelperStatus(
                      state: state.cartStatus,
                      onRetry: () =>
                          context.read<CartBloc>().add(const LoadCart()),
                    ),
                  ),
                ),
                ),
                AnimatedSection(
                  sectionIndex: 1,
                  child: _wrapWithKey(
                    cartTotalKey,
                    Padding(
                      padding: EdgeInsets.only(top: 8.h, bottom: bottomPadding),
                      child: CartTotalSection(
                      subtotalFormatted: subtotalStr,
                      totalFormatted: totalStr,
                      onProceedToCheckout: () {
                        AuthGuard.requireAuth(context).then((ok) {
                          if (!ok || !context.mounted) return;
                          AppSnackbar.showInfo(
                            context,
                            LocaleKeys.cart_stripeMaintenance,
                          );
                        });
                      },
                      enabled: items.isNotEmpty && !isLoading,
                    ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _wrapWithKey(GlobalKey? key, Widget child) {
    if (key == null) return child;
    return KeyedSubtree(key: key, child: child);
  }
}
