import 'package:alt__wally/features/user/domain/usecases/get_user_by_id_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:alt__wally/features/user/domain/usecases/get_current_id_usecase.dart';
import 'package:alt__wally/features/user/domain/usecases/is_sign_in_usecase.dart';
import 'package:alt__wally/features/user/domain/usecases/sing_out_usecase.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IsSignInUseCase isSignInUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUIDUseCase getCurrentUIDUseCase;
  final GetUserByIdUseCase getUserByIdUseCase;
  AuthCubit(
      {required this.isSignInUseCase,
      required this.signOutUseCase,
      required this.getUserByIdUseCase,
      required this.getCurrentUIDUseCase})
      : super(AuthInitial());

  Future<void> appStarted() async {
    try {
      final isSignIn = await isSignInUseCase.call();
      if (isSignIn == true) {
        final uid = await getCurrentUIDUseCase.call();
        final resource = await getUserByIdUseCase.call(uid);
        emit(Authenticated(uid: uid, user: resource.data));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedIn() async {
    try {
      final uid = await getCurrentUIDUseCase.call();
      final resource = await getUserByIdUseCase.call(uid);
      emit(Authenticated(uid: uid, user: resource.data));
    } catch (_) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedOut() async {
    try {
      await signOutUseCase.call();
      emit(UnAuthenticated());
    } catch (_) {
      emit(UnAuthenticated());
    }
  }
}
