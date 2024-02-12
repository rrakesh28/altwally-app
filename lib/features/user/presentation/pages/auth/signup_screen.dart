import 'package:alt__wally/common/toast.dart';
import 'package:alt__wally/common/widgets/custom_textfield.dart';
import 'package:alt__wally/core/common/widgets/validation_error_widget.dart';
import 'package:alt__wally/features/home/presentation/pages/home_screen.dart';
import 'package:alt__wally/core/constants/constants.dart';
import 'package:alt__wally/features/user/domain/entities/user_entity.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:alt__wally/features/user/presentation/pages/auth/login_screen.dart';
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
                    height: 250.0,
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
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      'We are waiting all the time. register now and enjoy wallpapers for free',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _signUpFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Name",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          CustomTextField(
                            controller: _nameController,
                            hintText: 'Enter you Name',
                          ),
                          if (credentialState is RegisterFailed)
                            ValidationErrorWidget(
                                state: credentialState, fieldName: 'name'),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          CustomTextField(
                            controller: _emailController,
                            hintText: 'Enter you Email',
                          ),
                          if (credentialState is RegisterFailed)
                            ValidationErrorWidget(
                                state: credentialState, fieldName: 'email'),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Password",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          CustomTextField(
                            controller: _passwordController,
                            hintText: 'Your Password',
                            isObscure: true,
                          ),
                          if (credentialState is RegisterFailed)
                            ValidationErrorWidget(
                                state: credentialState, fieldName: 'password'),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Confirm Password",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          CustomTextField(
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
                                backgroundColor: Colors.black),
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
                                    fontSize: 16,
                                    color: GlobalVariables.grayColor),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, LoginScreen.routeName);
                                  },
                                  child: const Text(
                                    'Log in',
                                    style: TextStyle(color: Colors.black),
                                  ))
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
