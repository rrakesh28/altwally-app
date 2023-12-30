import 'package:alt__wally/features/auth/screens/login_screen.dart';
import 'package:alt__wally/features/auth/screens/singup_screen.dart';
import 'package:alt__wally/features/categories/categories_screen.dart';
import 'package:alt__wally/features/home/screens/home_screen.dart';
import 'package:alt__wally/features/wallpaper/screens/add_wallpaper_screen.dart';
import 'package:alt__wally/features/welcome/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case WelcomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const WelcomeScreen(),
      );
    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginScreen(),
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
    case CategoryScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const CategoryScreen(),
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
