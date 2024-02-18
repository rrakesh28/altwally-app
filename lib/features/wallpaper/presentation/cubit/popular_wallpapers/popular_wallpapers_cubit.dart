import 'package:alt__wally/features/wallpaper/domain/usecases/get_popular_wallpapers_usecase.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/popular_wallpapers/popular_wallpapers_state.dart';
import 'package:bloc/bloc.dart';

class GetPopularWallpapersCubit extends Cubit<GetPopularWallpapersState> {
  final GetPopularWallpapersUseCase getPopularWallpapersUseCase;
  GetPopularWallpapersCubit({required this.getPopularWallpapersUseCase})
      : super(PopularInitial());

  Future<void> fetchData() async {
    try {
      emit(PopularInitial());
      final wallpapersResponse = await getPopularWallpapersUseCase.call();
      emit(PopularLoaded(wallpapers: wallpapersResponse.data));
    } catch (e) {
      emit(PopularFailed());
    }
  }
}
