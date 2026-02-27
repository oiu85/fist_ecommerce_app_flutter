//* Coach tour completion state storage abstraction.
//? Delegates to AppStorageService for persistence.

import '../../../../core/storage/app_storage_service.dart';

/// Abstraction for coach tour completion flag.
abstract class CoachTourStorage {
  Future<bool> isCompleted();
  Future<void> setCompleted(bool value);
}

class CoachTourStorageImpl implements CoachTourStorage {
  CoachTourStorageImpl(this._storage);

  final AppStorageService _storage;

  @override
  Future<bool> isCompleted() => _storage.isCoachTourCompleted();

  @override
  Future<void> setCompleted(bool value) => _storage.setCoachTourCompleted(value);
}
