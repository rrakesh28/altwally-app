import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:alt__wally/features/wallpaper/domain/usecases/get_recently_added_wallpapers_usecase.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_state.dart';
import 'package:bloc/bloc.dart';

class GetRecentlyAddedWallpapersCubit extends Cubit<GetRecentlyAddedState> {
  final GetRecentlyAddedUseCase getRecentlyAddedUseCase;
  GetRecentlyAddedWallpapersCubit({required this.getRecentlyAddedUseCase})
      : super(Initial());

  Future<void> fetchData({bool fetchFromRemote = false}) async {
    try {
      emit(Initial());

      Stream<Resource> wallpapersStream =
          getRecentlyAddedUseCase.call(fetchFromRemote);

      wallpapersStream.listen((wallpapersResponse) {
        if (wallpapersResponse.success) {
          emit(Loaded(wallpapers: wallpapersResponse.data));
        } else {
          emit(Failed());
        }
      });
    } catch (e) {
      print(e);
      emit(Failed());
    }
  }

  void updateWallpapers(List<WallpaperEntity?> updatedWallpapers) {
    emit(state.copyWith(wallpapers: updatedWallpapers));
  }
}
