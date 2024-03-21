import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:alt__wally/features/wallpaper/domain/usecases/get_favourite_wallpapers_usecase.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/get_favourite/get_favourite_wallpapers_state.dart';
import 'package:bloc/bloc.dart';

class GetFavouriteWallpapersCubit extends Cubit<GetFavouriteWallpapersState> {
  final GetFavouriteWallpapersUseCase getFavouriteWallpapersUseCase;
  GetFavouriteWallpapersCubit({required this.getFavouriteWallpapersUseCase})
      : super(GetFavouriteWallpapersInitial());

  Future<void> fetchData() async {
    try {
      emit(GetFavouriteWallpapersInitial());
      final wallpapersResponse = await getFavouriteWallpapersUseCase.call();
      emit(GetFavouriteWallpapersLoaded(wallpapers: wallpapersResponse.data));
    } catch (e) {
      print(e);
      emit(GetFavouriteWallpapersFailed());
    }
  }

  void add(WallpaperEntity wallpaper) {
    try {
      if (state is GetFavouriteWallpapersLoaded) {
        final currentState = state as GetFavouriteWallpapersLoaded;
        final List<WallpaperEntity?> currentWallpapers =
            currentState.wallpapers;

        bool isDuplicate = currentWallpapers
            .any((existingWallpaper) => existingWallpaper?.id == wallpaper.id);

        if (!isDuplicate) {
          final updatedList = List<WallpaperEntity?>.from(currentWallpapers)
            ..add(wallpaper);

          print(updatedList);
          emit(GetFavouriteWallpapersLoaded(wallpapers: updatedList));
        } else {
          print(
              "Wallpaper with ID ${wallpaper.id} already exists in the list.");
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void remove(WallpaperEntity wallpaper) {
    if (state is GetFavouriteWallpapersLoaded) {
      final currentState = state as GetFavouriteWallpapersLoaded;
      final updatedList =
          currentState.wallpapers.where((w) => w?.id != wallpaper.id).toList();
      emit(GetFavouriteWallpapersLoaded(wallpapers: updatedList));
    }
  }
}
