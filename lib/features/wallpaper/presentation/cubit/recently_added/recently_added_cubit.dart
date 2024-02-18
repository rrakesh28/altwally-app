import 'package:alt__wally/features/wallpaper/domain/usecases/get_recently_added_wallpapers_usecase.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_state.dart';
import 'package:bloc/bloc.dart';

class GetRecentlyAddedWallpapersCubit extends Cubit<GetRecentlyAddedState> {
  final GetRecentlyAddedUseCase getRecentlyAddedUseCase;
  GetRecentlyAddedWallpapersCubit({required this.getRecentlyAddedUseCase})
      : super(Initial());

  Future<void> fetchData() async {
    try {
      emit(Initial());
      final wallpapersResponse = await getRecentlyAddedUseCase.call();
      emit(Loaded(wallpapers: wallpapersResponse.data));
    } catch (e) {
      emit(Failed());
    }
  }
}
