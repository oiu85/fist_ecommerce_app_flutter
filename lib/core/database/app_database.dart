import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'cart_schema.dart';

//* SQLite database helper for cart persistence.
//? Opens DB, runs migrations; used by CartLocalDataSource.

class AppDatabase {
  AppDatabase._();

  static Database? _db;

  /// Returns the opened database; opens and migrates if needed.
  static Future<Database> get database async {
    if (_db != null && _db!.isOpen) return _db!;
    _db = await _openDatabase();
    return _db!;
  }

  /// Closes the database (e.g. for tests or app dispose).
  static Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }

  static Future<Database> _openDatabase() async {
    final appDir = await getApplicationDocumentsDirectory();
    final dbPath = path.join(appDir.path, 'cart.db');
    return openDatabase(
      dbPath,
      version: kCartDbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute(kCreateCartItemsTable);
  }

  static Future<void> _onUpgrade(Database db, int from, int to) async {
    //* Add future migrations here when kCartDbVersion increases.
    if (from < 1) {
      await db.execute(kCreateCartItemsTable);
    }
  }
}
