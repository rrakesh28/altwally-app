import 'dart:io';

import 'package:alt__wally/features/user/domain/entities/user_entity.dart';
import 'package:alt__wally/features/user/domain/usecases/get_update_user_usecase.dart';
import 'package:alt__wally/features/user/presentation/cubit/update/update_user_state.dart';
import 'package:bloc/bloc.dart';

class UpdateUserCubit extends Cubit<UpdateUserState> {
  final GetUpdateUserUseCase getUpdateUserUseCase;

  UpdateUserCubit({required this.getUpdateUserUseCase})
      : super((UpdateUserInitial()));

  Future<void> updateUser(UserEntity user) async {
    emit(UpdateUserLoading());
    try {
      final resource = await getUpdateUserUseCase.call(user);
      if (resource.success) {
        emit(UpdateUserSuccess());
      } else {
        emit(UpdateUserFailed(
            validationErrors: resource.validationErrors,
            errorMessage: resource.errorMessage));
      }
    } on SocketException catch (_) {
      emit(const UpdateUserFailed(errorMessage: 'Update User Failed'));
    } catch (e) {
      emit(const UpdateUserFailed(errorMessage: "Update User Failed"));
    }
  }
}
