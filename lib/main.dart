import 'package:alt__wally/features/app/presentation/pages/app_screen.dart';
import 'package:alt__wally/features/category/data/model/category_model.dart';
import 'package:alt__wally/features/category/presentation/cubit/get_categories_cubit/category_cubit.dart';
import 'package:alt__wally/features/splash/pages/splash_screen.dart';
import 'package:alt__wally/features/user/data/model/user_model.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_state.dart';
import 'package:alt__wally/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/profile/profile_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/update/update_user_cubit.dart';
import 'package:alt__wally/features/user/presentation/pages/auth/login_screen.dart';
import 'package:alt__wally/features/wallpaper/data/model/wallpaper_model.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/add_wallpaper/add_wallpaper_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/get_category_wallpapers/get_category_wallpapers_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/get_favourite/get_favourite_wallpapers_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/popular_wallpapers/popular_wallpapers_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/toggle_favourite/toggle_favourite_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/wall_of_the_month/wall_of_the_month_cubit.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import 'injection_container.dart' as di;

import 'router.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:path_provider/path_provider.dart' as path_provider;

class CustomCacheManager {
  static final BaseCacheManager _instance = _createCustomCacheManager();

  static BaseCacheManager get instance => _instance;
  static const key = 'wallpapers';

  static BaseCacheManager _createCustomCacheManager() {
    return CacheManager(
      Config(
        key,
        stalePeriod: const Duration(days: 7),
        maxNrOfCacheObjects: 20,
        repo: JsonCacheInfoRepository(databaseName: key),
        fileService: HttpFileService(),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(WallpaperModelAdapter());

  CustomCacheManager.instance;
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => di.sl<AuthCubit>()..appStarted(),
        ),
        BlocProvider<CredentialCubit>(
          create: (_) => di.sl<CredentialCubit>(),
        ),
        BlocProvider<CategoryCubit>(
          create: (_) => di.sl<CategoryCubit>(),
        ),
        BlocProvider<AddWallpaperCubit>(
          create: (_) => di.sl<AddWallpaperCubit>(),
        ),
        BlocProvider<ProfileCubit>(
          create: (_) => di.sl<ProfileCubit>(),
        ),
        BlocProvider<UpdateUserCubit>(
          create: (_) => di.sl<UpdateUserCubit>(),
        ),
        BlocProvider<WallOfTheMonthCubit>(
          create: (_) => di.sl<WallOfTheMonthCubit>(),
        ),
        BlocProvider<ToggleFavouriteWallpaperCubit>(
          create: (_) => di.sl<ToggleFavouriteWallpaperCubit>(),
        ),
        BlocProvider<GetFavouriteWallpapersCubit>(
          create: (_) => di.sl<GetFavouriteWallpapersCubit>(),
        ),
        BlocProvider<GetCategoryWallpapersCubit>(
          create: (_) => di.sl<GetCategoryWallpapersCubit>(),
        ),
        BlocProvider<GetRecentlyAddedWallpapersCubit>(
          create: (_) => di.sl<GetRecentlyAddedWallpapersCubit>(),
        ),
        BlocProvider<GetPopularWallpapersCubit>(
          create: (_) => di.sl<GetPopularWallpapersCubit>(),
        ),
        BlocProvider<ForgotPasswordCubit>(
          create: (_) => di.sl<ForgotPasswordCubit>(),
        ),
      ],
      child: DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          return MaterialApp(
            title: 'Alt Wally',
            theme: ThemeData(
              colorScheme: lightDynamic,
              useMaterial3: true,
              textTheme: GoogleFonts.hindTextTheme(),
            ),
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            onGenerateRoute: (settings) => generateRoute(settings),
            // home: const SplashScreen(),
            routes: {
              "/": (context) {
                return BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                    if (authState is Authenticated) {
                      return const AppScreen();
                    } else if (authState is AuthInitial) {
                      return const SplashScreen();
                    } else {
                      return LoginScreen();
                    }
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
