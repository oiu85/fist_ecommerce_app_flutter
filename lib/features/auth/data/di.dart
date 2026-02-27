import 'package:fsit_flutter_task_ecommerce/core/network/network_client.dart';
import 'package:fsit_flutter_task_ecommerce/core/storage/app_storage_service.dart';
import 'package:fsit_flutter_task_ecommerce/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fsit_flutter_task_ecommerce/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fsit_flutter_task_ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:fsit_flutter_task_ecommerce/features/auth/domain/usecases/login_use_case.dart';
import 'package:fsit_flutter_task_ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

//* Auth feature dependency registration.

void registerAuthDependencies(GetIt sl) {
  //! Data layer
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl<NetworkClient>()),
  );

  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(
      sl<AuthRemoteDataSource>(),
      sl<AppStorageService>(),
    ),
  );

  //! Domain layer — use cases
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<IAuthRepository>()),
  );

  //! Presentation — BLoC as factory (new instance per LoginPage)
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(loginUseCase: sl<LoginUseCase>()),
  );
}
