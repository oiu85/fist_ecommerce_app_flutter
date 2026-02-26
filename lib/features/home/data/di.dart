import 'package:fsit_flutter_task_ecommerce/core/network/network_client.dart';
import 'package:fsit_flutter_task_ecommerce/features/home/data/datasources/product_remote_data_source.dart';
import 'package:fsit_flutter_task_ecommerce/features/home/data/repositories/product_repository_impl.dart';
import 'package:fsit_flutter_task_ecommerce/features/home/domain/repositories/product_repository.dart';
import 'package:fsit_flutter_task_ecommerce/features/home/domain/usecases/get_categories_use_case.dart';
import 'package:fsit_flutter_task_ecommerce/features/home/domain/usecases/get_products_use_case.dart';
import 'package:fsit_flutter_task_ecommerce/features/home/presentation/bloc/home_bloc.dart';
import 'package:get_it/get_it.dart';



//* Home feature dependency registration.
//? Called from app_dependencies.dart. BLoC is factory (new per screen).

void registerHomeDependencies(GetIt sl) {
  //! Data layer
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSource(sl<NetworkClient>()),
  );

  sl.registerLazySingleton<IProductRepository>(
    () => ProductRepositoryImpl(sl<ProductRemoteDataSource>()),
  );

  //! Domain layer — use cases
  sl.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(sl<IProductRepository>()),
  );
  sl.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(sl<IProductRepository>()),
  );

  //! Presentation — BLoC as factory (new instance per HomePage)
  sl.registerFactory<HomeBloc>(
    () => HomeBloc(
      getProductsUseCase: sl<GetProductsUseCase>(),
      getCategoriesUseCase: sl<GetCategoriesUseCase>(),
    ),
  );
}
