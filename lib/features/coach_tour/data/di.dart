import 'package:get_it/get_it.dart';

import '../../../../core/storage/app_storage_service.dart';
import 'coach_tour_storage.dart';
import '../presentation/coach_tour_controller.dart';
import '../presentation/coach_tour_target_keys.dart';

void registerCoachTourDependencies(GetIt sl) {
  sl.registerLazySingleton<CoachTourStorage>(
    () => CoachTourStorageImpl(sl<AppStorageService>()),
  );
  sl.registerLazySingleton<CoachTourTargetKeys>(() => CoachTourTargetKeys());
  sl.registerLazySingleton<CoachTourController>(() => CoachTourController());
}
