import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/cart_schema.dart';
import '../models/cart_item_model.dart';

//* Local cart data source backed by SQLite.
//? Source of truth for cart; used by CartRepositoryImpl.

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getAll();
  Future<void> addOrUpdate(int productId, int quantity);
  Future<void> updateQuantity(int productId, int quantity);
  Future<void> remove(int productId);
  Future<int> getItemCount();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  @override
  Future<List<CartItemModel>> getAll() async {
    final db = await AppDatabase.database;
    final rows = await db.query(
      kCartItemsTable,
      orderBy: '$kColCreatedAt ASC',
    );
    return rows.map(CartItemModel.fromRow).toList();
  }

  @override
  Future<void> addOrUpdate(int productId, int quantity) async {
    final db = await AppDatabase.database;
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.insert(
      kCartItemsTable,
      {
        kColProductId: productId,
        kColQuantity: quantity,
        kColCreatedAt: now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateQuantity(int productId, int quantity) async {
    final db = await AppDatabase.database;
    await db.update(
      kCartItemsTable,
      {kColQuantity: quantity},
      where: '$kColProductId = ?',
      whereArgs: [productId],
    );
  }

  @override
  Future<void> remove(int productId) async {
    final db = await AppDatabase.database;
    await db.delete(
      kCartItemsTable,
      where: '$kColProductId = ?',
      whereArgs: [productId],
    );
  }

  @override
  Future<int> getItemCount() async {
    final items = await getAll();
    return items.fold<int>(0, (sum, item) => sum + item.quantity);
  }
}
