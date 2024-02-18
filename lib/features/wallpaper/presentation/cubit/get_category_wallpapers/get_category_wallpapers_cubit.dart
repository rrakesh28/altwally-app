import 'package:alt__wally/features/wallpaper/domain/usecases/get_category_wallpapers.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/get_category_wallpapers/get_category_wallpapers_state.dart';
import 'package:bloc/bloc.dart';

class GetCategoryWallpapersCubit extends Cubit<GetWallpapersState> {
  final GetCategoryWallpapersUseCase getCategoryWallpapersUseCase;
  GetCategoryWallpapersCubit({required this.getCategoryWallpapersUseCase})
      : super(Initial());

  Future<void> fetchData(categoryId) async {
    try {
      emit(Initial());
      final wallpapersResponse =
          await getCategoryWallpapersUseCase.call(categoryId);
      emit(Loaded(wallpapers: wallpapersResponse.data));
    } catch (e) {
      emit(Failed());
    }
  }
}
