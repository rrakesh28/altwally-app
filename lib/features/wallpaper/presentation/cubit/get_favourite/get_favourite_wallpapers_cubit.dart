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
      emit(GetFavouriteWallpapersFailed());
    }
  }
}
