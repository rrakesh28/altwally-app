import 'package:alt__wally/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_state.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: ShapeDecoration(
                color: const Color(0xFFE8E8E8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is Authenticated) {
                        return Transform(
                          transform: Matrix4.identity()..translate(0.0, 0.0),
                          child: ClipPath(
                            clipper: OvalClipper(),
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(0.22, -0.97),
                                  end: Alignment(-0.22, 0.97),
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
                                      padding: EdgeInsets.all(12),
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          height: 150,
                                          fit: BoxFit.cover,
                                          imageUrl: state.user.profileImageUrl!,
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
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
                                    Container(
                                      height: 150,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black.withOpacity(
                                            0.1), // Adjust the opacity as needed
                                      ),
                                      child: Center(
                                        child: IconButton(
                                          onPressed: () {
                                            print('asdf');
                                          },
                                          color: Colors.white,
                                          icon: const Icon(Icons.camera_alt),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  SizedBox(width: 20),
                  BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
                    if (state is Authenticated) {
                      return Column(children: [
                        Text(
                          state.user.name!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          state.user.email!,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF727272),
                            fontSize: 12,
                            fontFamily: 'Cabin',
                            fontWeight: FontWeight.w400,
                            height: 0.12,
                            letterSpacing: -0.50,
                          ),
                        ),
                      ]);
                    }
                    return Container();
                  })
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Account',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            ListTile(
              title: const Text(
                'Personal Details',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              title: const Text(
                'Privacy Policy',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              title: const Text(
                'Terms and Conditions',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            Center(
              child:
                  ElevatedButton(onPressed: () {}, child: const Text('Logout')),
            )
          ],
        ),
      ),
    );
  }
}
