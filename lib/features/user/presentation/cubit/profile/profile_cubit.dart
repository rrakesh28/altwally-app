import 'package:alt__wally/features/user/domain/usecases/get_user_by_id_usecase.dart';
import 'package:alt__wally/features/user/presentation/cubit/profile/profile_state.dart';
import 'package:alt__wally/features/wallpaper/domain/usecases/get_wallpapers_by_user_id_usecase.dart';
import 'package:bloc/bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserByIdUseCase getUserByIdUseCase;
  final GetWallpapersByUserIdUseCase getWallpapersByUserIdUseCase;
  ProfileCubit(
      {required this.getUserByIdUseCase,
      required this.getWallpapersByUserIdUseCase})
      : super(ProfileInitial());

  Future<void> fetchData(userId) async {
    try {
      // final user = getUserByIdUseCase.call(userId);
      final wallpapersResponse =
          await getWallpapersByUserIdUseCase.call(userId);
      emit(ProfileLoaded(wallpapers: wallpapersResponse.data, user: null));
    } catch (e) {
      emit(ProfileLoadingFailed());
    }
  }
}
