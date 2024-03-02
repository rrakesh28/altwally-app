import 'package:alt__wally/common/toast.dart';
import 'package:alt__wally/common/widgets/custom_textfield.dart';
import 'package:alt__wally/constants/global_variables.dart';
import 'package:alt__wally/core/common/widgets/validation_error_widget.dart';
import 'package:alt__wally/features/app/presentation/pages/app_screen.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:alt__wally/features/user/presentation/pages/auth/signup_screen.dart';
import 'package:alt__wally/features/user/presentation/pages/forgot_password/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _signInFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
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
            showToast(message: "Login Successful!!");
            BlocProvider.of<AuthCubit>(context).loggedIn();
            Navigator.pushNamedAndRemoveUntil(
                context, AppScreen.routeName, (route) => false);
          }
          if (credentialState is LoginFailed) {
            showToast(message: credentialState.errorMessage);
          }
        },
        builder: (context, credentialState) {
          return SingleChildScrollView(
            reverse: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 400,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/gradient.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.only(top: 10),
                      width: 300,
                      child: Image.asset(
                        'assets/images/name.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome to Alt Wally.",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Find a clean and Minimal Collection which you wont find!!',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black38,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: _signInFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Email Address",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                controller: _emailController,
                                hintText: 'Enter your email address',
                              ),
                              if (credentialState is LoginFailed)
                                ValidationErrorWidget(
                                    state: credentialState, fieldName: 'email'),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                "Password",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                controller: _passwordController,
                                hintText: 'Enter your password',
                                isObscure: true,
                              ),
                              if (credentialState is LoginFailed)
                                ValidationErrorWidget(
                                    state: credentialState,
                                    fieldName: 'password'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context,
                                          ForgotPasswordScreen.routeName);
                                    },
                                    child: const Text(
                                      'Reset Password',
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1F71ED)),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              FilledButton(
                                onPressed: () {
                                  if (_signInFormKey.currentState!.validate()) {
                                    _signIn();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  backgroundColor: Colors.black,
                                ),
                                child: credentialState is LoginLoading
                                    ? const SizedBox(
                                        height: 30.0,
                                        width: 30.0,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        "Login",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'New to Alt Wally?',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: GlobalVariables.grayColor),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, SignUpScreen.routeName);
                                      },
                                      child: const Text(
                                        'Sign up',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1F71ED)),
                                      ))
                                ],
                              )
                            ],
                          ),
                        )
                      ]),
                ),
              ],
            ),
          );
        },
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
