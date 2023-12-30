import 'package:alt__wally/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeName = "/welcome-screen";
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   _checkWelcomeAndUserStatus();
  // }

  // Future<void> _checkWelcomeAndUserStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool welcome = prefs.getBool('welcome') ?? false;

  //   if (welcome) {
  //     Navigator.pushNamed(context, LoginScreen.routeName);
  //   }

  //   User? authenticatedUser = UserService().authUser;

  //   if (authenticatedUser != null) {
  //     Navigator.pushNamed(context, HomeScreen.routeName);
  //   }
  // }

  void _navigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('welcome', true);
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Image.asset(
          'assets/images/banner.png',
          width: double.infinity,
        ),
        const SizedBox(
          height: 40,
        ),
        const Text("welcome !",
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w400,
            )),
        const Padding(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
          child: Text(
            "Ready to redefine your screen? Dive in and let the wallpaper journey begin. Happy browsing!",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center, // Aligns the text to the center
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {
            _navigate();
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: const Icon(Icons.arrow_forward, color: Colors.white),
          ),
        )
      ],
    ));
  }
}
