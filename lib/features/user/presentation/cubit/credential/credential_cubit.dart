import 'dart:io';

import 'package:alt__wally/features/user/domain/entities/user_entity.dart';
import 'package:alt__wally/features/user/domain/usecases/forgot_password_usecase.dart';
import 'package:alt__wally/features/user/domain/usecases/sign_in_usecase.dart';
import 'package:alt__wally/features/user/domain/usecases/sign_up_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final SignUpUseCase signUpUseCase;
  final SignInUseCase signInUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;

  CredentialCubit({
    required this.signUpUseCase,
    required this.signInUseCase,
    required this.forgotPasswordUseCase,
  }) : super(CredentialInitial());

  // Future<void> forgotPassword({required String email}) async {
  //   try {
  //     await forgotPasswordUseCase.call(email);
  //   } on SocketException catch (_) {
  //     emit(CredentialFailure());
  //   } catch (_) {
  //     emit(CredentialFailure());
  //   }
  // }

  Future<void> signInSubmit({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      final resource = await signInUseCase
          .call(UserEntity(email: email, password: password));
      if (resource.success) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailed(
            validationErrors: resource.validationErrors,
            errorMessage: resource.errorMessage));
      }
    } on SocketException catch (_) {
      emit(const LoginFailed(errorMessage: 'Login Failed'));
    } catch (e) {
      emit(const LoginFailed(errorMessage: "Login Failed"));
    }
  }

  Future<void> signUpSubmit({required UserEntity user}) async {
    emit(RegisterLoading());
    try {
      final resource = await signUpUseCase.call(UserEntity(
          name: user.name, email: user.email, password: user.password));
      if (resource.success) {
        emit(RegisterSuccess());
      } else {
        emit(RegisterFailed(
            validationErrors: resource.validationErrors,
            errorMessage: resource.errorMessage));
      }
    } on SocketException catch (_) {
      emit(const RegisterFailed(errorMessage: "Registration failed"));
    } catch (_) {
      emit(const RegisterFailed(errorMessage: "Registration failed"));
    }
  }
}
