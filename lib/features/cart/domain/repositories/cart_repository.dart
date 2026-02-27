import '../entities/cart_item_entity.dart';

//* Abstract cart repository contract.
//? Pure Dart — no Flutter/network. Implemented in data layer.

abstract class ICartRepository {
  /// Returns all cart items.
  Future<List<CartItemEntity>> getCartItems();

  /// Adds or updates quantity for the given product.
  Future<void> addOrUpdateItem(int productId, int quantity);

  /// Updates quantity for an existing product.
  Future<void> updateQuantity(int productId, int quantity);

  /// Removes the product from the cart.
  Future<void> removeItem(int productId);

  /// Returns total number of items (sum of quantities).
  Future<int> getItemCount();
}
