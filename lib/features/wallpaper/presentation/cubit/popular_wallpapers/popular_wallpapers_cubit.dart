import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:alt__wally/features/wallpaper/domain/usecases/get_popular_wallpapers_usecase.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/popular_wallpapers/popular_wallpapers_state.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetPopularWallpapersCubit extends Cubit<GetPopularWallpapersState> {
  final GetPopularWallpapersUseCase getPopularWallpapersUseCase;
  final GetRecentlyAddedWallpapersCubit getRecentlyAddedWallpapersCubit;
  GetPopularWallpapersCubit(
      {required this.getPopularWallpapersUseCase,
      required this.getRecentlyAddedWallpapersCubit})
      : super(PopularInitial());

  Future<void> fetchData(BuildContext context) async {
    try {
      emit(PopularInitial());
      print('a');

      final otherCubitState = getRecentlyAddedWallpapersCubit.state;
      if (otherCubitState is Initial || otherCubitState is Failed) {
        BlocProvider.of<GetRecentlyAddedWallpapersCubit>(context).fetchData();
      }

      print(otherCubitState);

      if (otherCubitState is Initial || otherCubitState is Failed) {
        BlocProvider.of<GetRecentlyAddedWallpapersCubit>(context).fetchData();
      } else if (otherCubitState is Loaded) {
        final shuffledWallpapers = List<WallpaperEntity?>.from(otherCubitState
                .wallpapers
                .map((dynamic wallpaper) => wallpaper as WallpaperEntity?)
                .where(
                    (wallpaper) => wallpaper != null) // Filter out null values
            )
          ..shuffle();

        emit(PopularLoaded(wallpapers: shuffledWallpapers));
      }

      // final wallpapersResponse = await getPopularWallpapersUseCase.call();
      // emit(PopularLoaded(wallpapers: wallpapersResponse.data));
    } catch (e) {
      print(e);
      emit(PopularFailed());
    }
  }
}
