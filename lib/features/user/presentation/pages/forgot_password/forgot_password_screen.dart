import 'package:alt__wally/common/toast.dart';
import 'package:alt__wally/common/widgets/custom_textfield.dart';
import 'package:alt__wally/core/common/widgets/validation_error_widget.dart';
import 'package:alt__wally/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/forgot_password/forgot_password_state.dart';
import 'package:alt__wally/features/user/presentation/pages/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgot-password-screen';
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  final _forgotPasswordFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            showToast(message: "Mail sent to your email please check!!");
            Navigator.pushNamedAndRemoveUntil(
                context, LoginScreen.routeName, (route) => false);
          }
          if (state is ForgotPasswordFailed) {
            showToast(message: 'Something went wrong');
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/gradient.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      height: 400.0,
                      width: 300,
                      child: Image.asset(
                        'assets/images/name.png',
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
                          "Verify your Email Id",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'You will receive an password reset link',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black38,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: _forgotPasswordFormKey,
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
                              if (state is LoginFailed)
                                ValidationErrorWidget(
                                    state: state, fieldName: 'email'),
                              const SizedBox(
                                height: 20,
                              ),
                              FilledButton(
                                onPressed: () {
                                  if (_forgotPasswordFormKey.currentState!
                                      .validate()) {
                                    _submit();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  backgroundColor: Colors.black,
                                ),
                                child: state is ForgotPasswordLoading
                                    ? const SizedBox(
                                        height: 30.0,
                                        width: 30.0,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        "Submit",
                                      ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
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

  void _submit() {
    if (_emailController.text.isEmpty) {
      showToast(message: 'enter your email');
      return;
    }
    BlocProvider.of<ForgotPasswordCubit>(context).submit(_emailController.text);
  }
}
