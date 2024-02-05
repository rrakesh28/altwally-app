import 'package:alt__wally/features/category/category_injection_container.dart';
import 'package:alt__wally/features/user/user_injection_container.dart';
import 'package:alt__wally/features/wallpaper/wallpaper_injection_contianer.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //API
  sl.registerLazySingleton<Dio>(() => Dio());

  await userInjectionContainer();
  await categoryInjectionContainer();
  await wallpaperInjectionContainer();
}
