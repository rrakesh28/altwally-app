import 'package:alt__wally/features/home/presentation/pages/home_screen.dart';
import 'package:alt__wally/features/user/presentation/pages/auth/login_screen.dart';
import 'package:alt__wally/features/user/presentation/pages/auth/signup_screen.dart';
import 'package:alt__wally/features/wallpaper/presentation/pages/add_wallpaper_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => LoginScreen(),
      );
    case SignUpScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignUpScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case AddWallpaperScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddWallpaperScreen(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
