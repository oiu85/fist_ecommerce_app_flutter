import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_details_event.dart';
import 'product_details_state.dart';

//* Hysteresis thresholds (0–1) to avoid flicker when scroll is near the boundary.
const double _kShowButtonsThreshold = 0.85;
const double _kHideButtonsThreshold = 0.65;

/// BLoC for product details screen: quantity, scroll-driven overlay, add-to-cart.
class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  ProductDetailsBloc({
    int minQuantity = 1,
    int? maxQuantity,
    void Function(int quantity)? onAddToCart,
  })  : _onAddToCart = onAddToCart,
        super(ProductDetailsState(
          minQuantity: minQuantity,
          maxQuantity: maxQuantity,
        )) {
    on<ProductDetailsQuantityDecremented>(_onQuantityDecremented);
    on<ProductDetailsQuantityIncremented>(_onQuantityIncremented);
    on<ProductDetailsScrollChanged>(_onScrollChanged);
    on<ProductDetailsAddToCartRequested>(_onAddToCartRequested);
  }

  final void Function(int quantity)? _onAddToCart;

  void _onQuantityDecremented(
    ProductDetailsQuantityDecremented event,
    Emitter<ProductDetailsState> emit,
  ) {
    if (state.quantity <= state.minQuantity) return;
    emit(state.copyWith(quantity: state.quantity - 1));
  }

  void _onQuantityIncremented(
    ProductDetailsQuantityIncremented event,
    Emitter<ProductDetailsState> emit,
  ) {
    final max = state.maxQuantity;
    if (max != null && state.quantity >= max) return;
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void _onScrollChanged(
    ProductDetailsScrollChanged event,
    Emitter<ProductDetailsState> emit,
  ) {
    final h = event.scrollLeadHeight;
    if (h <= 0) return;
    final offset = event.scrollOffset;
    final showThreshold = h * _kShowButtonsThreshold;
    final hideThreshold = h * _kHideButtonsThreshold;
    final shouldShow = state.showButtonsOnContent
        ? offset > hideThreshold
        : offset >= showThreshold;
    if (shouldShow != state.showButtonsOnContent) {
      emit(state.copyWith(showButtonsOnContent: shouldShow));
    }
  }

  void _onAddToCartRequested(
    ProductDetailsAddToCartRequested event,
    Emitter<ProductDetailsState> emit,
  ) {
    _onAddToCart?.call(state.quantity);
  }
}
