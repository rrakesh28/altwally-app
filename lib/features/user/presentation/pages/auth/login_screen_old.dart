import 'package:alt__wally/common/toast.dart';
import 'package:alt__wally/common/widgets/custom_button.dart';
import 'package:alt__wally/common/widgets/custom_textfield.dart';
import 'package:alt__wally/constants/global_variables.dart';
import 'package:alt__wally/features/home/pages/home_screen.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_state.dart';
import 'package:alt__wally/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:alt__wally/features/user/presentation/pages/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _signInFormKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  bool isChecked = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      body: BlocConsumer<CredentialCubit, CredentialState>(
        listener: (context, credentialState) {
          if (credentialState is LoginSuccess) {
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }
          if (credentialState is LoginFailed) {
            showToast(message: "Invalid Credentials");
          }
        },
        builder: (context, credentialState) {
          if (credentialState is LoginLoading) {
            return const Scaffold(
              body: CircularProgressIndicator(),
            );
          }
          if (credentialState is LoginSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return HomeScreen();
                } else {
                  return _bodyWidget();
                }
              },
            );
          }
          return _bodyWidget();
        },
      ),
    );
  }

  _bodyWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 100.0,
              ),
            ),
            const Text(
              "Login to your Account",
              style: TextStyle(
                fontSize: 40,
                color: Color(0xFF5EBC8B),
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(height: 3, width: 120, color: const Color(0xFF5EBC8B)),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Nice to see you again!",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: GlobalVariables.grayColor,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _signInFormKey,
              child: Column(
                children: [
                  CustomTextField(
                    prefixIcon: Icons.email,
                    controller: _emailController,
                    hintText: 'Email',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    prefixIcon: Icons.lock,
                    controller: _passwordController,
                    hintText: 'Password',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (bool? newValue) {
                              setState(() {
                                isChecked = newValue!; // Use newValue here
                              });
                            },
                          ),
                          const Text(
                            "Remember Me",
                            style: TextStyle(
                                fontSize: 12, color: GlobalVariables.grayColor),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Forgot Passowrd'),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                      text: "Sign In",
                      onTap: () {
                        if (_signInFormKey.currentState!.validate()) {
                          _signIn();
                        }
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(children: <Widget>[
                    Expanded(child: Divider()),
                    Text("or continue with"),
                    Expanded(child: Divider()),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Dont have an account?',
                        style: TextStyle(
                            fontSize: 18, color: GlobalVariables.grayColor),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, SignUpScreen.routeName);
                          },
                          child: const Text('Sing up'))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _signIn() {
    if (_emailController.text.isEmpty) {
      showToast(message: 'enter your email');
      return;
    }
    if (_passwordController.text.isEmpty) {
      showToast(message: "Enter Password");
      return;
    }
    BlocProvider.of<CredentialCubit>(context).signInSubmit(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }
}
