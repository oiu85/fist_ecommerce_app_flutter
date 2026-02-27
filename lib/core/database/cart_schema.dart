//* Cart table DDL and migration version for SQLite.
//? Centralizes schema definitions; used by AppDatabase.

/// Current database version; increment when adding migrations.
const int kCartDbVersion = 1;

/// Table name for cart items.
const String kCartItemsTable = 'cart_items';

/// Column names.
const String kColId = 'id';
const String kColProductId = 'product_id';
const String kColQuantity = 'quantity';
const String kColCreatedAt = 'created_at';

/// SQL to create the cart_items table.
/// One row per product; UNIQUE(product_id) enforces upsert semantics.
const String kCreateCartItemsTable = '''
CREATE TABLE $kCartItemsTable (
  $kColId INTEGER PRIMARY KEY AUTOINCREMENT,
  $kColProductId INTEGER NOT NULL UNIQUE,
  $kColQuantity INTEGER NOT NULL DEFAULT 1,
  $kColCreatedAt INTEGER NOT NULL
)
''';
