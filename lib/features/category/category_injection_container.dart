import 'package:alt__wally/features/category/data/repository/category_repository_impl.dart';
import 'package:alt__wally/features/category/domain/repository/category_repository.dart';
import 'package:alt__wally/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:alt__wally/features/category/presentation/cubit/get_categories_cubit/category_cubit.dart';

import '../../injection_container.dart';

Future<void> categoryInjectionContainer() async {
  sl.registerFactory<CategoryCubit>(
      () => CategoryCubit(getCategoriesUseCase: sl.call()));

  //UseCases
  sl.registerLazySingleton<GetCategoriesUseCase>(
      () => GetCategoriesUseCase(repository: sl.call()));

  //Repository
  sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(firestore: sl.call()));

  //Remote DataSource
}
