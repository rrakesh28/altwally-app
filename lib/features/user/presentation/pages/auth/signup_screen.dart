import 'package:alt__wally/common/toast.dart';
import 'package:alt__wally/common/widgets/custom_textfield.dart';
import 'package:alt__wally/core/common/widgets/validation_error_widget.dart';
import 'package:alt__wally/features/home/pages/home_screen.dart';
import 'package:alt__wally/core/constants/constants.dart';
import 'package:alt__wally/features/user/domain/entities/user_entity.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:alt__wally/features/user/presentation/pages/auth/login_screen_old.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/sign-up-screen';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signUpFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  bool isChecked = false;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  void _signUp() {
    if (_nameController.text.isEmpty) {
      showToast(message: 'enter your name');
      return;
    }
    if (_emailController.text.isEmpty) {
      showToast(message: 'enter your email');
      return;
    }
    if (_passwordController.text.isEmpty) {
      showToast(message: "Enter Password");
      return;
    }
    if (_confirmPasswordController.text.isEmpty) {
      showToast(message: "Enter Password");
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      showToast(message: "Both the passwords should match");
      return;
    }

    UserEntity user = UserEntity(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
    BlocProvider.of<CredentialCubit>(context).signUpSubmit(user: user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      body: BlocConsumer<CredentialCubit, CredentialState>(
          listener: (context, credentialState) {
        if (credentialState is RegisterSuccess) {
          showToast(message: "Sing Up Successful!!");
          BlocProvider.of<AuthCubit>(context).loggedIn();
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);
        }
        if (credentialState is RegisterFailed) {
          showToast(message: credentialState.errorMessage);
        }
      }, builder: (context, credentialState) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
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
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Color(0xFF5EBC8B),
                    fontSize: 50,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    height: 0,
                    letterSpacing: -0.30,
                  ),
                ),
                Container(
                  height: 3,
                  width: 120,
                  color: const Color(0xFF5EBC8B),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "We are waiting all the time. register now and enjoy a million wallpapers for free ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: GlobalVariables.grayColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: _signUpFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        prefixIcon: Icons.person,
                        controller: _nameController,
                        hintText: 'Name',
                      ),
                      if (credentialState is RegisterFailed)
                        ValidationErrorWidget(
                            state: credentialState, fieldName: 'name'),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        prefixIcon: Icons.email,
                        controller: _emailController,
                        hintText: 'Email',
                      ),
                      if (credentialState is RegisterFailed)
                        ValidationErrorWidget(
                            state: credentialState, fieldName: 'email'),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        prefixIcon: Icons.lock,
                        controller: _passwordController,
                        hintText: 'Password',
                        isObscure: true,
                      ),
                      if (credentialState is RegisterFailed)
                        ValidationErrorWidget(
                            state: credentialState, fieldName: 'password'),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        prefixIcon: Icons.lock,
                        controller: _confirmPasswordController,
                        hintText: 'Confirm Password',
                        isObscure: true,
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
                                    isChecked = newValue!;
                                  });
                                },
                              ),
                              const Text(
                                "I agree to the terms to use",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: GlobalVariables.grayColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FilledButton(
                        onPressed: () {
                          if (_signUpFormKey.currentState!.validate()) {
                            _signUp();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: credentialState is RegisterLoading
                            ? const SizedBox(
                                width: 30.0,
                                height: 30.0, // Ser a smaller height
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth:
                                      3.0, // Set the thickness of the circle
                                ),
                              )
                            : const Text(
                                "Sign Up",
                              ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Row(children: <Widget>[
                        Expanded(child: Divider()),
                        Text("OR"),
                        Expanded(child: Divider()),
                      ]),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                            style: TextStyle(
                                fontSize: 18, color: GlobalVariables.grayColor),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, LoginScreen.routeName);
                              },
                              child: const Text('Log in'))
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
