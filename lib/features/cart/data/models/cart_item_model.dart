import '../../domain/entities/cart_item_entity.dart';
import '../../../../core/database/cart_schema.dart';

//* Data model for cart item (DB mapping).
//? Maps between SQLite row and CartItemEntity.

class CartItemModel {
  const CartItemModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.createdAt,
  });

  final int id;
  final int productId;
  final int quantity;
  final int createdAt;

  /// Creates from a SQLite row.
  factory CartItemModel.fromRow(Map<String, dynamic> row) {
    return CartItemModel(
      id: row[kColId] as int,
      productId: row[kColProductId] as int,
      quantity: row[kColQuantity] as int,
      createdAt: row[kColCreatedAt] as int,
    );
  }

  /// Converts to DB row for insert/update.
  Map<String, dynamic> toRow() => {
        kColProductId: productId,
        kColQuantity: quantity,
        kColCreatedAt: createdAt,
      };

  CartItemEntity toEntity() => CartItemEntity(
        productId: productId,
        quantity: quantity,
      );
}
