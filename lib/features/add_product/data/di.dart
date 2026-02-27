import 'package:fsit_flutter_task_ecommerce/features/add_product/domain/usecases/add_product_use_case.dart';
import 'package:fsit_flutter_task_ecommerce/features/add_product/presentation/bloc/add_product_bloc.dart';
import 'package:fsit_flutter_task_ecommerce/features/home/domain/repositories/product_repository.dart';
import 'package:fsit_flutter_task_ecommerce/features/home/domain/usecases/get_categories_use_case.dart';
import 'package:get_it/get_it.dart';

//* Add product feature dependency registration.
//? AddProductBloc is lazy singleton (provided at MainContainerPage); categories load once.

void registerAddProductDependencies(GetIt sl) {
  //! Domain — use cases (AddProductUseCase; GetCategoriesUseCase from home)
  sl.registerLazySingleton<AddProductUseCase>(
    () => AddProductUseCase(sl<IProductRepository>()),
  );

  //! Presentation — BLoC as lazy singleton (same instance across tab switches; no reload)
  sl.registerLazySingleton<AddProductBloc>(
    () => AddProductBloc(
      addProductUseCase: sl<AddProductUseCase>(),
      getCategoriesUseCase: sl<GetCategoriesUseCase>(),
    ),
  );
}
