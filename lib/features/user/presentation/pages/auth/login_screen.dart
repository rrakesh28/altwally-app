import 'package:alt__wally/common/toast.dart';
import 'package:alt__wally/common/widgets/custom_textfield.dart';
import 'package:alt__wally/constants/global_variables.dart';
import 'package:alt__wally/core/common/widgets/validation_error_widget.dart';
import 'package:alt__wally/features/home/presentation/pages/home_screen.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_cubit.dart';
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
                context, HomeScreen.routeName, (route) => false);
          }
          if (credentialState is LoginFailed) {
            showToast(message: credentialState.errorMessage);
          }
        },
        builder: (context, credentialState) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/gradient.png'), // Use your actual asset image path
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      height: 300.0,
                      width: 300,
                      child: Image.asset(
                        'assets/images/name.png', // Use your actual asset image path
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
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
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          'Find a clean and Minimal Collection which you wont find!!',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
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
                                "Email",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: isChecked,
                                        onChanged: (bool? newValue) {
                                          setState(() {
                                            isChecked =
                                                newValue!; // Use newValue here
                                          });
                                        },
                                      ),
                                      const Text(
                                        "Remember Me",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: GlobalVariables.grayColor),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Forgot Password',
                                      style: TextStyle(color: Colors.black),
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
                                        "Sign In",
                                      ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Row(children: <Widget>[
                                Expanded(child: Divider()),
                                Text("or continue with"),
                                Expanded(child: Divider()),
                              ]),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Dont have an account?',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: GlobalVariables.grayColor),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, SignUpScreen.routeName);
                                      },
                                      child: const Text(
                                        'Sing up',
                                        style: TextStyle(color: Colors.black),
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
