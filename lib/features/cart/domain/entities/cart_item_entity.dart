//* Domain entity for a single cart line item.
//? Pure Dart — no Flutter/network imports.

/// A cart line item: product reference and quantity.
class CartItemEntity {
  const CartItemEntity({
    required this.productId,
    required this.quantity,
  });

  final int productId;
  final int quantity;
}
