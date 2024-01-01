import 'package:alt__wally/features/home/pages/home_screen.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_state.dart';
import 'package:alt__wally/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:alt__wally/features/user/presentation/pages/auth/login_screen.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection_container.dart' as di;

import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      ],
      child: DynamicColorBuilder(
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
            initialRoute: '/',
            onGenerateRoute: (settings) => generateRoute(settings),
            // home: const SplashScreen(),
            routes: {
              "/": (context) {
                return BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                    if (authState is Authenticated) {
                      return const HomeScreen();
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
