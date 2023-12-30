import 'package:alt__wally/common/services/user_service.dart';
import 'package:alt__wally/common/toast.dart';
import 'package:alt__wally/features/wallpaper/screens/add_wallpaper_screen.dart';
import 'package:alt__wally/features/wallpaper/screens/wallpaper_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = "/profile-screen";
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, dynamic>> wallpapersData = [];

  User? _authUser;

  @override
  void initState() {
    super.initState();
    fetchData();

    _authUser = UserService().authUser;
  }

  Future<void> fetchData() async {
    List<Map<String, dynamic>> wallpapersFetched = [];
    try {
      User? authenticatedUser = UserService().authUser;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('wallpapers')
          .where('userId', isEqualTo: authenticatedUser?.uid)
          .get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        String documentId = documentSnapshot.id;
        data['id'] = documentId;
        wallpapersFetched.add(data);
      }

      setState(() {
        wallpapersData = wallpapersFetched;
      });
    } catch (e) {
      showToast(message: "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          child: Stack(
            children: [
              Image.network(
                  "https://images.unsplash.com/photo-1477346611705-65d1883cee1e?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover),
              Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton(
                      onPressed: () {
                        print('asdf');
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ))),
              Positioned(
                  top: 120,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: screenHeight - 220,
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(children: [
                          Row(
                            children: [
                              Container(
                                height: 75,
                                width: 75,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 4.0,
                                  ),
                                ),
                                child: Image.asset(
                                  'assets/images/avatar.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(_authUser?.displayName ?? "Guest",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ))
                                ],
                              )
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.settings_outlined,
                                size: 28,
                              )),
                        ]),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 15,
                                childAspectRatio: 0.7,
                              ),
                              itemCount: wallpapersData.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WallpaperScreen(
                                            id: wallpapersData[index]['id'],
                                            type: "profile"),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.zero,
                                    child: Image.network(
                                      wallpapersData[index]['image'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AddWallpaperScreen.routeName);
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(14),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
