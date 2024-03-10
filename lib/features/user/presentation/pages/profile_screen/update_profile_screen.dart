import 'dart:io';

import 'package:alt__wally/common/toast.dart';
import 'package:alt__wally/common/widgets/custom_textfield.dart';
import 'package:alt__wally/core/common/widgets/validation_error_widget.dart';
import 'package:alt__wally/features/user/domain/entities/user_entity.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_state.dart';
import 'package:alt__wally/features/user/presentation/cubit/update/update_user_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/update/update_user_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';

class UpdateProfileScreen extends StatefulWidget {
  static const String routeName = '/update-profile-screen';
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  File? bannerImage;
  File? profileImage;

  final _updateUserFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    AuthState authState = context.read<AuthCubit>().state;

    if (authState is Authenticated) {
      _nameController.text = authState.user.name!;
      _emailController.text = authState.user.email!;
    }
  }

  Future<void> pickBanner() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          bannerImage = File(result.files.single.path!);
        });
        _cropBannerImage();
      }
    } catch (e) {
      showToast(message: 'Error $e');
    }
  }

  Future<void> picProfileImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          profileImage = File(result.files.single.path!);
        });
        _cropProfileImage();
      }
    } catch (e) {
      showToast(message: 'Error $e');
    }
  }

  void _update() {
    if (_passwordController.text != _confirmPasswordController.text) {
      showToast(message: "Both the passwords should match");
      return;
    }
    UserEntity user = UserEntity(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      bannerImage: bannerImage,
      profileImage: profileImage,
    );

    BlocProvider.of<UpdateUserCubit>(context)
        .updateUser(user, _currentPasswordController.text);
  }

  Future<void> _cropBannerImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: bannerImage!.path,
      aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    if (croppedFile != null) {
      File? convertedFile = File(croppedFile.path);
      setState(() {
        bannerImage = convertedFile;
      });
    }
  }

  Future<void> _cropProfileImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: profileImage!.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    if (croppedFile != null) {
      File? convertedFile = File(croppedFile.path);
      setState(() {
        profileImage = convertedFile;
      });
    } else {
      setState(() {
        profileImage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      body: BlocConsumer<UpdateUserCubit, UpdateUserState>(
        listener: (context, state) {
          if (state is UpdateUserSuccess) {
            showToast(message: "Update User Successful!!");
            Navigator.pop(context);
          }
          if (state is UpdateUserFailed) {
            showToast(message: state.errorMessage);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                if (bannerImage == null)
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is Authenticated) {
                        return Stack(
                          children: [
                            CachedNetworkImage(
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              imageUrl: state.user.bannerImageUrl!,
                              placeholder: (context, url) => const Center(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.red,
                                child: const Center(
                                  child: Icon(Icons.error, color: Colors.white),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 5,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 5,
                              child: IconButton(
                                onPressed: () {
                                  pickBanner();
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                if (bannerImage != null)
                  Stack(
                    children: [
                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Image.file(
                          bannerImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 5,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              bannerImage = null;
                            });
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (state is UpdateUserFailed)
                  ValidationErrorWidget(state: state, fieldName: 'bannerImage'),
                const SizedBox(
                  height: 20,
                ),
                if (profileImage == null)
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is Authenticated) {
                        return Column(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 4.0,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  state.user.profileImageUrl!,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Center(
                              child: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  picProfileImage();
                                },
                              ),
                            ),
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                if (profileImage != null)
                  Column(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                            width: 4.0,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.file(
                            profileImage!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Center(
                        child: IconButton(
                          icon: const Icon(Icons.cancel),
                          onPressed: () {
                            setState(() {
                              profileImage = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _updateUserFormKey,
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
                          hintText: 'Enter your Name',
                        ),
                        if (state is UpdateUserFailed)
                          ValidationErrorWidget(
                              state: state, fieldName: 'name'),
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
                          hintText: 'Enter your Email',
                        ),
                        if (state is UpdateUserFailed)
                          ValidationErrorWidget(
                              state: state, fieldName: 'email'),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Current Password",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        CustomTextField(
                          controller: _currentPasswordController,
                          hintText: 'Enter Current Password',
                          isObscure: true,
                          required: true,
                        ),
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
                          required: false,
                        ),
                        if (state is UpdateUserFailed)
                          ValidationErrorWidget(
                              state: state, fieldName: 'password'),
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
                          required: false,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FilledButton(
                          onPressed: () {
                            if (_updateUserFormKey.currentState!.validate()) {
                              _update();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.black,
                          ),
                          child: state is UpdateUserLoading
                              ? const SizedBox(
                                  height: 30.0,
                                  width: 30.0,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Save",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
