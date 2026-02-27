import 'package:fsit_flutter_task_ecommerce/core/network/network_client.dart';
import 'package:fsit_flutter_task_ecommerce/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:fsit_flutter_task_ecommerce/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:fsit_flutter_task_ecommerce/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:fsit_flutter_task_ecommerce/features/cart/domain/repositories/cart_repository.dart';
import 'package:fsit_flutter_task_ecommerce/features/home/domain/repositories/product_repository.dart';
import 'package:fsit_flutter_task_ecommerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:get_it/get_it.dart';

//* Cart feature dependency registration.
//? CartBloc is lazy singleton (app-wide). Source of truth: SQLite.

void registerCartDependencies(GetIt sl) {
  //! Data layer
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(sl<NetworkClient>()),
  );
  sl.registerLazySingleton<ICartRepository>(
    () => CartRepositoryImpl(sl<CartLocalDataSource>(), sl<CartRemoteDataSource>()),
  );

  //! Presentation — CartBloc as singleton (app-wide, provided at root)
  sl.registerLazySingleton<CartBloc>(
    () => CartBloc(
      cartRepository: sl<ICartRepository>(),
      productRepository: sl<IProductRepository>(),
    ),
  );
}
