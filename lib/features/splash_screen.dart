import 'package:alt__wally/common/services/user_service.dart';
import 'package:alt__wally/features/auth/screens/login_screen.dart';
import 'package:alt__wally/features/home/screens/home_screen.dart';
import 'package:alt__wally/features/welcome/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkWelcomeAndUserStatus();
  }

  Future<void> _checkWelcomeAndUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool welcome = prefs.getBool('welcome') ?? false;

    if (welcome) {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
    }

    User? authenticatedUser = UserService().authUser;

    if (authenticatedUser != null) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
