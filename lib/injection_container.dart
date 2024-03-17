import 'package:alt__wally/features/category/category_injection_container.dart';
import 'package:alt__wally/features/user/user_injection_container.dart';
import 'package:alt__wally/features/wallpaper/wallpaper_injection_contianer.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  const supabaseUrl = 'https://xdfkorpwpouwhyfvfheq.supabase.co';
  const supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhkZmtvcnB3cG91d2h5ZnZmaGVxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTAxNDU5OTcsImV4cCI6MjAyNTcyMTk5N30.Dnb8Y7mFi94iW8L3fB5CtgHWj0gXIsI_c6TgdwNE5ag';

  final supabase = await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );
  sl.registerLazySingleton(() => supabase.client);

  await userInjectionContainer();
  await categoryInjectionContainer();
  await wallpaperInjectionContainer();
}
