import 'package:alt__wally/features/category/data/remote/category_api_service.dart';
import 'package:alt__wally/features/category/data/repository/category_repository_impl.dart';
import 'package:alt__wally/features/category/domain/repository/category_repository.dart';
import 'package:alt__wally/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:alt__wally/features/category/domain/usecases/get_wallpapers_usecase.dart';
import 'package:alt__wally/features/category/presentation/cubit/wallpapers/wallpapers_cubit.dart';
import 'package:alt__wally/features/explore/presentation/cubit/category/category_cubit.dart';

import '../../injection_container.dart';

Future<void> categoryInjectionContainer() async {
  sl.registerFactory<CategoryCubit>(
      () => CategoryCubit(getCategoriesUseCase: sl.call()));
  sl.registerFactory<WallpapersCubit>(
      () => WallpapersCubit(getWallpapersUseCase: sl.call()));

  //UseCases
  sl.registerLazySingleton<GetCategoriesUseCase>(
      () => GetCategoriesUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetWallpapersUseCase>(
      () => GetWallpapersUseCase(repository: sl.call()));

  //Repository
  sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(api: sl.call()));

  //Remote DataSource

  //API
  sl.registerLazySingleton<CategoryApiService>(
      () => CategoryApiService(sl.call()));
}
