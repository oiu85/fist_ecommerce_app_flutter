import 'package:equatable/equatable.dart';

/// Base type for product details screen events.
sealed class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object?> get props => [];
}

/// User tapped decrement; quantity must stay >= min (1).
final class ProductDetailsQuantityDecremented extends ProductDetailsEvent {
  const ProductDetailsQuantityDecremented();
}

/// User tapped increment; quantity may be capped by [maxValue] if set.
final class ProductDetailsQuantityIncremented extends ProductDetailsEvent {
  const ProductDetailsQuantityIncremented();
}

/// Scroll position changed; bloc computes whether to show overlay buttons (hysteresis).
class ProductDetailsScrollChanged extends ProductDetailsEvent {
  const ProductDetailsScrollChanged({
    required this.scrollOffset,
    required this.scrollLeadHeight,
  });

  final double scrollOffset;
  final double scrollLeadHeight;

  @override
  List<Object?> get props => [scrollOffset, scrollLeadHeight];
}

/// User tapped Add to Cart; bloc invokes callback with current quantity.
final class ProductDetailsAddToCartRequested extends ProductDetailsEvent {
  const ProductDetailsAddToCartRequested();
}
