import 'package:alt__wally/common/toast.dart';
import 'package:alt__wally/common/widgets/custom_button.dart';
import 'package:alt__wally/common/widgets/custom_textfield.dart';
import 'package:alt__wally/constants/global_variables.dart';
import 'package:alt__wally/features/auth/screens/singup_screen.dart';
import 'package:alt__wally/features/auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _signInFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isChecked = false;

  bool _isSigning = false;

  final FirebaseAuthService _auth = FirebaseAuthService();

  // @override
  // void initState() {
  //   super.initState();
  //   _checkUserStatus();
  // }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      showToast(message: "User is successfully signed in");
      Navigator.pushNamed(context, "/home-screen");
    } else {
      showToast(message: "some error occured");
    }
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
                                  fontSize: 12,
                                  color: GlobalVariables.grayColor),
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
                    Visibility(
                      visible: !_isSigning,
                      replacement:
                          const CircularProgressIndicator(color: Colors.black),
                      child: CustomButton(
                          text: "Sign In",
                          onTap: () {
                            if (_signInFormKey.currentState!.validate()) {
                              _signIn();
                            }
                          }),
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
      ),
    );
  }
}
