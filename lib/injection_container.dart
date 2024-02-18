import 'package:alt__wally/features/category/category_injection_container.dart';
import 'package:alt__wally/features/user/user_injection_container.dart';
import 'package:alt__wally/features/wallpaper/wallpaper_injection_contianer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => fireStore);

  await userInjectionContainer();
  await categoryInjectionContainer();
  await wallpaperInjectionContainer();
}
