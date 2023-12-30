import 'package:alt__wally/features/community/screens/community_screen.dart';
import 'package:alt__wally/features/explore/screens/explore_screen.dart';
import 'package:alt__wally/features/favourites/screens/favourites_screen.dart';
import 'package:alt__wally/features/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';
  final int? index;
  const HomeScreen({Key? key, this.index}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index ?? 0;
  }

  static const List<Widget> _screens = <Widget>[
    ExploreScreen(),
    CommunityScreen(),
    FavouritesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    Brightness currentBrightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = currentBrightness == Brightness.dark;

    return Scaffold(
      body: _screens.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
            gap: 8,
            color: isDarkMode ? Colors.white : Colors.black,
            activeColor: Colors.black,
            tabBackgroundColor: const Color(0xFFF2AB38),
            padding: const EdgeInsets.all(10),
            // ignore: prefer_const_literals_to_create_immutables
            tabs: [
              const GButton(
                icon: Icons.explore,
                text: "Explore",
              ),
              const GButton(
                icon: Icons.people,
                text: "Community",
              ),
              const GButton(
                icon: Icons.favorite,
                text: "Favourites",
              ),
              const GButton(
                icon: Icons.person,
                text: "Profile",
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
