import 'package:alt__wally/common/services/user_service.dart';
import 'package:alt__wally/features/categories/categories_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  static const String routeName = '/explore-screen';
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  User? _authUser = null;
  @override
  void initState() {
    super.initState();

    _authUser = UserService().authUser;
  }

  String getGreeting() =>
      'Good ${DateTime.now().hour < 12 ? 'Morning' : DateTime.now().hour < 18 ? 'Afternoon' : 'Evening'}';

  @override
  Widget build(BuildContext context) {
    String greeting = getGreeting();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    'assets/images/name.png',
                    height: 25,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/avatar.png',
                      width: 50,
                      height: 40,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('$greeting!',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            )),
                        Text(_authUser?.displayName ?? 'Guest',
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
                    onPressed: () {}, icon: const Icon(Icons.notifications)),
              ]),
              const SizedBox(
                height: 20,
              ),
              const Text("Wall of the month",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  )),
              Container(
                height: 200,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                20) // Adjust the radius as needed
                            ),
                        padding: EdgeInsets.zero,
                        child: Image.asset(
                          'assets/images/wallpaper.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                20) // Adjust the radius as needed
                            ),
                        padding: EdgeInsets.zero,
                        child: Image.asset('assets/images/wallpaper.png',
                            fit: BoxFit.cover),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                20) // Adjust the radius as needed
                            ),
                        padding: EdgeInsets.zero,
                        child: Image.asset('assets/images/wallpaper.png',
                            fit: BoxFit.cover),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'The Colour Tone',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFDB7B9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF4164E0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF6141E0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF60BFC1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFF9A0D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/color-wheel.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                // height: 300,
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.5,
                  ),
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, CategoryScreen.routeName);
                      },
                      child: Container(
                        height: 200,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/category2.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        padding: EdgeInsets.zero,
                        child: const Center(
                            child: Text(
                          'Category Name',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, CategoryScreen.routeName);
                      },
                      child: Container(
                        height: 200,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/category1.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        padding: EdgeInsets.zero,
                        child: const Center(
                            child: Text(
                          'Category Name',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
