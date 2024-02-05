import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:alt__wally/features/wallpaper/domain/usecases/toggle_favourite_wallpaper_usecase.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/toggle_favourite/toggle_favourite_state.dart';
import 'package:bloc/bloc.dart';

class ToggleFavouriteWallpaperCubit
    extends Cubit<ToggleFavouriteWallpaperState> {
  final ToggleFavouriteWallpapersUseCase toggleFavouriteWallpapersUseCase;
  ToggleFavouriteWallpaperCubit(
      {required this.toggleFavouriteWallpapersUseCase})
      : super(ToggleFavouriteWallpaperInitial());

  Future<void> toggle(WallpaperEntity wallpaper) async {
    try {
      await toggleFavouriteWallpapersUseCase.call(wallpaper);
      emit(ToggleFavouriteWallpaperSuccessful());
    } catch (e) {
      emit(ToggleFavouriteWallpaperFailed());
    }
  }
}
