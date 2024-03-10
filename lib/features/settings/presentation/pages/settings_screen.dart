// ignore_for_file: prefer_const_constructors

import 'package:alt__wally/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:alt__wally/features/user/presentation/pages/auth/login_screen.dart';
import 'package:alt__wally/features/user/presentation/pages/profile_screen/update_profile_screen.dart';
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
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                subtitle:
                    Text('Your review is  important to us. Leave a review.  '),
                onTap: () {},
              ),
              ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color.fromRGBO(83, 94, 255, 50)),
                  child: Image.asset(
                    'assets/images/info.png',
                  ),
                ),
                title: const Text(
                  'About',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                subtitle:
                    Text('Read our Privacy Policy and Terms & Conditions '),
                onTap: () {},
              ),
              SizedBox(
                height: 20,
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
