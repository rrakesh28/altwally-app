import 'dart:io';

import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:alt__wally/features/wallpaper/domain/usecases/add_wallpaper_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'add_wallpaper_state.dart';

class AddWallpaperCubit extends Cubit<AddWallpaperState> {
  final AddWallpaperUseCase addWallpaperUseCase;

  AddWallpaperCubit({
    required this.addWallpaperUseCase,
  }) : super(AddWallpaperInitial());

  Future<void> submit(WallpaperEntity wallpaper) async {
    emit((AddWallpaperLoading()));
    try {
      final resource = await addWallpaperUseCase.call(wallpaper);
      if (resource.success) {
        emit(AddWallpaperSuccess());
      } else {
        emit(AddWallpaperFailed(
            validationErrors: resource.validationErrors,
            errorMessage: resource.errorMessage));
      }
    } on SocketException catch (_) {
      emit(const AddWallpaperFailed(
          errorMessage: 'Error in submitting the wallpaper'));
    } catch (e) {
      emit(const AddWallpaperFailed(
          errorMessage: "Error in submitting the wallpaper"));
    }
  }
}
