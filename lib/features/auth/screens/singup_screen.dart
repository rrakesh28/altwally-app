import 'package:alt__wally/common/toast.dart';
import 'package:alt__wally/common/widgets/custom_button.dart';
import 'package:alt__wally/common/widgets/custom_textfield.dart';
import 'package:alt__wally/constants/global_variables.dart';
import 'package:alt__wally/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alt__wally/features/auth/services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/singup-screen';
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

  bool isChecked = false;

  bool _isSignUp = false;

  final FirebaseAuthService _auth = FirebaseAuthService();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  void _singUp() async {
    setState(() {
      _isSignUp = true;
    });

    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (confirmPassword != password) {
      showToast(message: "Both the passwords should match");
      setState(() {
        _isSignUp = false;
      });
      return;
    }

    if (!isChecked) {
      showToast(message: "Aggree the terms and conditions");
      setState(() {
        _isSignUp = false;
      });
      return;
    }


    User? user = await _auth.signUpWithEmailAndPassword(email, password, name);

    if (user == null) {
      showToast(message: "Some Error Occured");
      setState(() {
        _isSignUp = true;
      });
      return;
    }
    setState(() {
      _isSignUp = true;
    });

    showToast(message: "Registered Successfully!!");
    Navigator.pushNamed(context, "/home-screen");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
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
                  children: [
                    CustomTextField(
                      prefixIcon: Icons.person,
                      controller: _nameController,
                      hintText: 'Name',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      prefixIcon: Icons.lock,
                      controller: _confirmPasswordController,
                      hintText: 'Confirm Password',
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
                    Visibility(
                      visible: !_isSignUp,
                      replacement: const CircularProgressIndicator(),
                      child: CustomButton(
                          text: "Sign Up",
                          onTap: () {
                            if (_signUpFormKey.currentState!.validate()) {
                              _singUp();
                            }
                          }),
                    ),
                    // CustomButton(
                    //     text: "Sign Up",
                    //     onTap: () {
                    //       if (_signUpFormKey.currentState!.validate()) {
                    //         _singUp();
                    //       }
                    //     }),
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
      ),
    );
  }
}
