import 'package:alt__wally/features/wallpaper/domain/usecases/get_wall_of_the_month_usecase.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/wall_of_the_month/wall_of_the_month_state.dart';
import 'package:bloc/bloc.dart';

class WallOfTheMonthCubit extends Cubit<WallOfTheMonthState> {
  final GetWallOfTheMonthUseCase getWallOfTheMonthUseCase;
  WallOfTheMonthCubit({required this.getWallOfTheMonthUseCase})
      : super(WallOfTheMonthInitial());

  Future<void> fetchData() async {
    try {
      final wallpapersResponse = await getWallOfTheMonthUseCase.call();
      emit(WallOfTheMonthLoaded(wallpapers: wallpapersResponse.data));
    } catch (e) {
      emit(WallOfTheMonthLoadingFailed());
    }
  }
}
