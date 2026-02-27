import 'cart_item_entity.dart';

//* Domain entity for the full cart.
//? Pure Dart — no Flutter/network imports.

/// Aggregated cart with items and total item count.
class CartEntity {
  const CartEntity({
    required this.items,
    required this.itemCount,
  });

  final List<CartItemEntity> items;
  final int itemCount;
}
