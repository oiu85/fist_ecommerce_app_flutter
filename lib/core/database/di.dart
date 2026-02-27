import 'package:get_it/get_it.dart';

//* Dependency registration for core database.
//? AppDatabase is accessed statically; no get_it registration needed.
//! Cart feature's CartLocalDataSource uses AppDatabase.database directly.

/// Registers database-related dependencies.
/// Currently AppDatabase uses static access; extend when needed.
void registerDatabaseDependencies(GetIt sl) {
  //* Reserved for future DB-related singletons (e.g. migration runner).
}
