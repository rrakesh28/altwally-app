import 'package:alt__wally/features/explore/presentation/pages/explore_screen.dart';
import 'package:alt__wally/features/home/presentation/pages/home_screen.dart';
import 'package:alt__wally/features/user/presentation/pages/profile_screen/profile_screen.dart';
import 'package:alt__wally/features/wallpaper/presentation/pages/favourites_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

class AppScreen extends StatefulWidget {
  static const String routeName = '/app-screen';
  final int? index;
  const AppScreen({super.key, this.index});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AppScreen>
    with SingleTickerProviderStateMixin {
  late int currentPage;
  late TabController tabController;
  final List<Color> colors = [
    Colors.yellow,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.pink,
  ];

  @override
  void initState() {
    currentPage = widget.index ?? 0;
    tabController = TabController(length: 4, vsync: this);
    tabController.animation?.addListener(
      () {
        final value = tabController.animation!.value.round();
        if (value != currentPage && mounted) {
          changePage(value);
        }
      },
    );
    super.initState();
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color unselectedColor = colors[currentPage].computeLuminance() < 0.5
        ? Colors.black
        : Colors.white;
    // final Color unselectedColorReverse =
    //     colors[currentPage].computeLuminance() < 0.5
    //         ? Colors.white
    //         : Colors.black;

    return Scaffold(
      body: BottomBar(
        clip: Clip.none,
        fit: StackFit.expand,
        icon: (width, height) => Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: null,
            icon: Icon(
              Icons.arrow_upward_rounded,
              color: unselectedColor,
              size: width,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(500),
        duration: const Duration(milliseconds: 500),
        curve: Curves.decelerate,
        showIcon: true,
        width: MediaQuery.of(context).size.width * 0.8,
        barColor: Colors.black,
        start: 2,
        end: 0,
        offset: 10,
        barAlignment: Alignment.bottomCenter,
        iconHeight: 30,
        iconWidth: 30,
        reverse: false,
        hideOnScroll: true,
        scrollOpposite: false,
        onBottomBarHidden: () {},
        onBottomBarShown: () {},
        body: (context, controller) => TabBarView(
          controller: tabController,
          dragStartBehavior: DragStartBehavior.down,
          physics: const BouncingScrollPhysics(),
          children: const [
            HomeScreen(),
            ExploreScreen(),
            FavouriteWallpapersScreen(),
            ProfileScreen(),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            TabBar(
              indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
              controller: tabController,
              indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 4,
                  ),
                  insets: EdgeInsets.fromLTRB(16, 0, 16, 8)),
              tabs: const [
                SizedBox(
                  height: 55,
                  width: 40,
                  child: Center(
                      child: Icon(
                    Icons.home,
                    color: Colors.white,
                  )),
                ),
                SizedBox(
                  height: 55,
                  width: 40,
                  child: Center(
                    child: Icon(
                      Icons.explore,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 55,
                  width: 40,
                  child: Center(
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 55,
                  width: 40,
                  child: Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            // Positioned(
            //   top: -25,
            //   child: FloatingActionButton(
            //     onPressed: () {},
            //     child: Icon(Icons.add),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
