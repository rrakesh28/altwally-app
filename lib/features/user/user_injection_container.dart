import 'package:alt__wally/features/user/data/repository/user_repository_impl.dart';
import 'package:alt__wally/features/user/domain/repository/user_repository.dart';
import 'package:alt__wally/features/user/domain/usecases/forgot_password_usecase.dart';
import 'package:alt__wally/features/user/domain/usecases/get_current_id_usecase.dart';
import 'package:alt__wally/features/user/domain/usecases/get_update_user_usecase.dart';
import 'package:alt__wally/features/user/domain/usecases/get_user_by_id_usecase.dart';
import 'package:alt__wally/features/user/domain/usecases/is_sign_in_usecase.dart';
import 'package:alt__wally/features/user/domain/usecases/sign_in_usecase.dart';
import 'package:alt__wally/features/user/domain/usecases/sign_up_usecase.dart';
import 'package:alt__wally/features/user/domain/usecases/sing_out_usecase.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/profile/profile_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/update/update_user_cubit.dart';

import '../../injection_container.dart';

Future<void> userInjectionContainer() async {
  sl.registerFactory<AuthCubit>(() => AuthCubit(
        isSignInUseCase: sl.call(),
        signOutUseCase: sl.call(),
        getCurrentUIDUseCase: sl.call(),
        getUserByIdUseCase: sl.call(),
      ));

  sl.registerFactory<CredentialCubit>(() => CredentialCubit(
        forgotPasswordUseCase: sl.call(),
        signInUseCase: sl.call(),
        signUpUseCase: sl.call(),
      ));
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(
      getUserByIdUseCase: sl.call(), getWallpapersByUserIdUseCase: sl.call()));
  sl.registerFactory<UpdateUserCubit>(
      () => UpdateUserCubit(getUpdateUserUseCase: sl.call()));

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
  sl.registerLazySingleton<GetUserByIdUseCase>(
      () => GetUserByIdUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetUpdateUserUseCase>(
      () => GetUpdateUserUseCase(repository: sl.call()));

  //Repository
  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(auth: sl.call(), fireStore: sl.call()));
}
