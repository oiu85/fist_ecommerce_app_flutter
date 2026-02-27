import 'package:equatable/equatable.dart';

//* Cart BLoC events.
//? All cart actions flow through these events.

sealed class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

/// Load cart items and resolve product info for display.
final class LoadCart extends CartEvent {
  const LoadCart();
}

/// Add product to cart (or update quantity if already present).
final class AddToCart extends CartEvent {
  const AddToCart({required this.productId, required this.quantity});

  final int productId;
  final int quantity;

  @override
  List<Object?> get props => [productId, quantity];
}

/// Update quantity for an existing cart item.
final class UpdateQuantity extends CartEvent {
  const UpdateQuantity({required this.productId, required this.quantity});

  final int productId;
  final int quantity;

  @override
  List<Object?> get props => [productId, quantity];
}

/// Remove product from cart.
final class RemoveItem extends CartEvent {
  const RemoveItem({required this.productId});

  final int productId;

  @override
  List<Object?> get props => [productId];
}
