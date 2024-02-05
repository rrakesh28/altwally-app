import 'package:alt__wally/features/category/domain/usecases/get_wallpapers_usecase.dart';
import 'package:alt__wally/features/category/presentation/cubit/wallpapers/wallpapers_state.dart';
import 'package:bloc/bloc.dart';

class WallpapersCubit extends Cubit<WallPapersState> {
  final GetWallpapersUseCase getWallpapersUseCase;
  WallpapersCubit({required this.getWallpapersUseCase})
      : super(WallpapersInitial());

  Future<void> fetchData(categoryId) async {
    try {
      emit(WallpapersInitial());
      final wallpapersResponse = await getWallpapersUseCase.call(categoryId);
      emit(WallpapersLoaded(wallpapers: wallpapersResponse.data));
    } catch (e) {
      emit(WallpapersLoadingFailed());
    }
  }
}
