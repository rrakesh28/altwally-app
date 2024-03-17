import 'package:alt__wally/features/category/data/datasources/local/category_local_data_source_impl.dart';
import 'package:alt__wally/features/category/data/datasources/local/cateogry_local_data_source.dart';
import 'package:alt__wally/features/category/data/datasources/remote/category_remote_data_source.dart';
import 'package:alt__wally/features/category/data/datasources/remote/category_remote_data_source_impl.dart';
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
  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(
      localDataSource: sl.call(), remoteDataSource: sl.call()));

  //Local DataSource
  sl.registerLazySingleton<CategoryLocalDataSource>(
      () => CategoryLocalDataSourceImpl());

  //Remote DataSource
  sl.registerLazySingleton<CategoryRemoteDataSource>(
      () => CategoryRemoteDataSourceImpl(supabaseClient: sl.call()));
}
