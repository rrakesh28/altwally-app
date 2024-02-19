// ignore_for_file: prefer_const_constructors

import 'package:alt__wally/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_state.dart';
import 'package:alt__wally/features/user/presentation/pages/auth/login_screen.dart';
import 'package:alt__wally/features/user/presentation/pages/profile_screen/update_profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings-screen';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: ShapeDecoration(
                  color: const Color(0xFFE8E8E8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        if (state is Authenticated) {
                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: Transform(
                              transform: Matrix4.identity()
                                ..translate(0.0, 0.0),
                              child: ClipPath(
                                clipper: OvalClipper(),
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(0.22, -0.97),
                                      end: Alignment(-0.22, 0.97),
                                      transform: GradientRotation(-45),
                                      colors: [
                                        Color(0xFFA5D0BA),
                                        Color(0xFFFCA36A)
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              height: 150,
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  state.user.profileImageUrl!,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child: SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                color: Colors.red,
                                                child: const Center(
                                                  child: Icon(Icons.error,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                    const SizedBox(width: 20),
                    BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                      if (state is Authenticated) {
                        return Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 12, top: 4, right: 12, bottom: 4),
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(51, 51, 51, 0.22),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: const Text(
                                    'Basic',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                ),
                                Text(
                                  state.user.name!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    state.user.email!,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xFF727272),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 14,
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                      left: 20, top: 14, bottom: 14),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                      )),
                                  child: Text(
                                    'Upgrade to Pro',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                )
                              ]),
                        );
                      }
                      return Container();
                    })
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/award.png'),
                    Text(
                      'Unlock and enjoy the best Alt Wally experience',
                      style: TextStyle(color: Color.fromRGBO(0, 0, 0, 50)),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color.fromRGBO(255, 100, 0, 50)),
                  child: Center(
                    child: Icon(
                      Icons.person_outline,
                      size: 30,
                    ),
                  ),
                ),
                title: const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                subtitle: Text('You can change the details here.'),
                onTap: () {
                  Navigator.pushNamed(context, UpdateProfileScreen.routeName);
                },
              ),
              ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color.fromRGBO(29, 161, 242, 50)),
                  child: Image.asset(
                    'assets/images/twitter.png',
                  ),
                ),
                title: const Text(
                  'X.COM',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                subtitle: Text('Read our tweets. Let’s have some fun.'),
                onTap: () {},
              ),
              ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color.fromRGBO(205, 72, 107, 50)),
                  child: Image.asset(
                    'assets/images/instagram.png',
                  ),
                ),
                title: const Text(
                  'Instagram',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                subtitle: Text('Find some inspiration for your setup.'),
                onTap: () {},
              ),
              ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color.fromRGBO(242, 78, 32, 50)),
                  child: Image.asset(
                    'assets/images/pintrest.png',
                  ),
                ),
                title: const Text(
                  'Pintrest',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                subtitle: Text('Follow for exclusive Pinterest walls.'),
                onTap: () {},
              ),
              ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color.fromRGBO(94, 188, 139, 50)),
                  child: Image.asset(
                    'assets/images/recommend.png',
                  ),
                ),
                title: const Text(
                  'Recommend',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                    "Share the word.  let other's know about the Alt Wally  app."),
                onTap: () {},
              ),
              ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color.fromRGBO(255, 215, 0, 50)),
                  child: Image.asset(
                    'assets/images/feedback.png',
                  ),
                ),
                title: const Text(
                  'Help and Feedback',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                subtitle: Text('Got questions? We have answers. Email Us. '),
                onTap: () {},
              ),
              ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color.fromRGBO(0, 229, 61, 50)),
                  child: Image.asset(
                    'assets/images/star.png',
                  ),
                ),
                title: const Text(
                  'Rate',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                subtitle:
                    Text('Your review is  important to us. Leave a review.  '),
                onTap: () {},
              ),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  onPressed: () {
                    BlocProvider.of<AuthCubit>(context).loggedOut();
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
