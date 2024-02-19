import 'package:alt__wally/features/user/domain/usecases/forgot_password_usecase.dart';
import 'package:alt__wally/features/user/presentation/cubit/forgot_password/forgot_password_state.dart';
import 'package:bloc/bloc.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUseCase forgotPasswordUseCase;
  ForgotPasswordCubit({required this.forgotPasswordUseCase})
      : super(ForgotPasswordInitial());

  Future<void> submit(emailId) async {
    try {
      await forgotPasswordUseCase.call(emailId);
      emit(ForgotPasswordSuccess());
    } catch (e) {
      emit(ForgotPasswordFailed());
    }
  }
}
