import 'package:alt__wally/features/user/data/remote/user_api_service.dart';
import 'package:alt__wally/features/user/data/repository/user_repository_impl.dart';
import 'package:alt__wally/features/user/domain/repository/user_repository.dart';
import 'package:alt__wally/features/user/domain/usecases/forgot_password_usecase.dart';
import 'package:alt__wally/features/user/domain/usecases/get_current_id_usecase.dart';
import 'package:alt__wally/features/user/domain/usecases/is_sign_in_usecase.dart';
import 'package:alt__wally/features/user/domain/usecases/sign_in_usecase.dart';
import 'package:alt__wally/features/user/domain/usecases/sign_up_usecase.dart';
import 'package:alt__wally/features/user/domain/usecases/sing_out_usecase.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Future bloc
  sl.registerFactory<AuthCubit>(() => AuthCubit(
        isSignInUseCase: sl.call(),
        signOutUseCase: sl.call(),
        getCurrentUIDUseCase: sl.call(),
      ));

  sl.registerFactory<CredentialCubit>(() => CredentialCubit(
        forgotPasswordUseCase: sl.call(),
        signInUseCase: sl.call(),
        signUpUseCase: sl.call(),
      ));

  //UseCases
  sl.registerLazySingleton<GetCurrentUIDUseCase>(
      () => GetCurrentUIDUseCase(repository: sl.call()));
  sl.registerLazySingleton<IsSignInUseCase>(
      () => IsSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignInUseCase>(
      () => SignInUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignUpUseCase>(
      () => SignUpUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(repository: sl.call()));
  sl.registerLazySingleton<ForgotPasswordUseCase>(
      () => ForgotPasswordUseCase(repository: sl.call()));

  //Repository
  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(api: sl.call()));

  //Remote DataSource

  //API
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<UserApiService>(() => UserApiService(sl.call()));
}
