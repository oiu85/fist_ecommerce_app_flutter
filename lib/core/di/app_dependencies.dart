import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/di.dart';
import '../network/network_client.dart';
import '../storage/app_storage_service.dart';
import 'package:fsit_flutter_task_ecommerce/features/add_product/data/di.dart';
import 'package:fsit_flutter_task_ecommerce/features/auth/data/di.dart';
import 'package:fsit_flutter_task_ecommerce/features/cart/data/di.dart';
import 'package:fsit_flutter_task_ecommerce/features/coach_tour/data/di.dart';
import 'package:fsit_flutter_task_ecommerce/features/home/data/di.dart';


final getIt = GetIt.instance;

//* Configure and initialize all dependencies.
//! This must be called after WidgetsFlutterBinding.ensureInitialized()

Future<GetIt> configureDependencies() async {
  // Initialize SharedPreferences first
  final prefs = await SharedPreferences.getInstance();
  // Register SharedPreferences manually
  getIt.registerSingleton<SharedPreferences>(prefs);
  // Register storage service
  getIt.registerLazySingleton<AppStorageService>(
    () => SharedPreferencesStorageService(getIt<SharedPreferences>()),
  );

  // Register NetworkClient (requires AppStorageService)
  getIt.registerSingleton<NetworkClient>(
    NetworkClient(getIt<AppStorageService>()),
  );

  //! Database (SQLite for cart)
  registerDatabaseDependencies(getIt);
  //! Home feature (products, categories API)
  registerHomeDependencies(getIt);
  //! Cart feature (SQLite + FakeStoreAPI simulation)
  registerCartDependencies(getIt);
  //! Add product feature (POST /products, categories)
  registerAddProductDependencies(getIt);
  //! Auth feature (login API)
  registerAuthDependencies(getIt);
  //! Coach tour feature (first-launch tutorial)
  registerCoachTourDependencies(getIt);

  return getIt;
}
