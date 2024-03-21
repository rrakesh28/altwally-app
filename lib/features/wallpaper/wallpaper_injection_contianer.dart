import 'package:alt__wally/features/wallpaper/data/datasource/local/wallpaper_local_data_source.dart';
import 'package:alt__wally/features/wallpaper/data/datasource/local/wallpaper_local_data_source_impl.dart';
import 'package:alt__wally/features/wallpaper/data/datasource/remote/wallpaper_remote_data_source.dart';
import 'package:alt__wally/features/wallpaper/data/datasource/remote/wallpaper_remote_data_source_impl.dart';
import 'package:alt__wally/features/wallpaper/data/repository/wallpaper_repository_impl.dart';
import 'package:alt__wally/features/wallpaper/domain/repository/wallpaper_repository.dart';
import 'package:alt__wally/features/wallpaper/domain/usecases/get_category_wallpapers.dart';
import 'package:alt__wally/features/wallpaper/domain/usecases/get_popular_wallpapers_usecase.dart';
import 'package:alt__wally/features/wallpaper/domain/usecases/get_recently_added_wallpapers_usecase.dart';
import 'package:alt__wally/features/wallpaper/domain/usecases/toggle_favourite_wallpaper_usecase.dart';
import 'package:alt__wally/features/wallpaper/domain/usecases/add_wallpaper_usecase.dart';
import 'package:alt__wally/features/wallpaper/domain/usecases/get_favourite_wallpapers_usecase.dart';
import 'package:alt__wally/features/wallpaper/domain/usecases/get_wall_of_the_month_usecase.dart';
import 'package:alt__wally/features/wallpaper/domain/usecases/get_wallpapers_by_user_id_usecase.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/get_category_wallpapers/get_category_wallpapers_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/popular_wallpapers/popular_wallpapers_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/toggle_favourite/toggle_favourite_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/add_wallpaper/add_wallpaper_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/get_favourite/get_favourite_wallpapers_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/wall_of_the_month/wall_of_the_month_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/services/notification_service.dart';

import '../../injection_container.dart';

Future<void> wallpaperInjectionContainer() async {
  sl.registerFactory<AddWallpaperCubit>(
      () => AddWallpaperCubit(addWallpaperUseCase: sl.call()));
  sl.registerFactory<WallOfTheMonthCubit>(
      () => WallOfTheMonthCubit(getWallOfTheMonthUseCase: sl.call()));
  sl.registerFactory<GetFavouriteWallpapersCubit>(() =>
      GetFavouriteWallpapersCubit(getFavouriteWallpapersUseCase: sl.call()));
  sl.registerFactory<ToggleFavouriteWallpaperCubit>(() =>
      ToggleFavouriteWallpaperCubit(
          toggleFavouriteWallpapersUseCase: sl.call()));
  sl.registerFactory<GetRecentlyAddedWallpapersCubit>(() =>
      GetRecentlyAddedWallpapersCubit(getRecentlyAddedUseCase: sl.call()));
  sl.registerFactory<GetPopularWallpapersCubit>(
      () => GetPopularWallpapersCubit(getPopularWallpapersUseCase: sl.call()));
  sl.registerFactory<GetCategoryWallpapersCubit>(() =>
      GetCategoryWallpapersCubit(getCategoryWallpapersUseCase: sl.call()));

  //UseCases
  sl.registerLazySingleton<AddWallpaperUseCase>(
      () => AddWallpaperUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetWallpapersByUserIdUseCase>(
      () => GetWallpapersByUserIdUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetWallOfTheMonthUseCase>(
      () => GetWallOfTheMonthUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetFavouriteWallpapersUseCase>(
      () => GetFavouriteWallpapersUseCase(repository: sl.call()));
  sl.registerLazySingleton<ToggleFavouriteWallpapersUseCase>(
      () => ToggleFavouriteWallpapersUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetRecentlyAddedUseCase>(
      () => GetRecentlyAddedUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetPopularWallpapersUseCase>(
      () => GetPopularWallpapersUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetCategoryWallpapersUseCase>(
      () => GetCategoryWallpapersUseCase(repository: sl.call()));

  //Repository
  sl.registerLazySingleton<WallpaperRepository>(() => WallpaperRepositoryImpl(
      supabaseClient: sl.call(),
      wallpaperLocalDataSource: sl.call(),
      wallpaperRemoteDataSource: sl.call(),
      categoryLocalDataSource: sl.call()));

  //Local DataStore
  sl.registerLazySingleton<WallpaperLocalDataSource>(() =>
      WallpaperLocalDataSourceImpl(
          userLocalDataSource: sl.call(), categoryLocalDataSource: sl.call()));

  //Remote DataStore
  sl.registerLazySingleton<WallpaperRemoteDataSource>(
      () => WallpaperRemoteDataSourceImpl(supabaseClient: sl.call()));

  sl.registerLazySingleton<NotificationService>(() => NotificationService());
}
