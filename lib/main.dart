import 'package:alt__wally/features/splash_screen.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'features/welcome/screens/welcome_screen.dart';
import 'firebase_options.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: 'Alt Wally',
          theme: ThemeData(
            colorScheme: lightDynamic,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic,
            brightness: Brightness.dark,
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: (settings) => generateRoute(settings),
          home: const SplashScreen(),
        );
      },
    );
  }
}
