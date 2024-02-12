// ignore_for_file: prefer_const_constructors

import 'package:alt__wally/common/toast.dart';
import 'package:alt__wally/features/home/presentation/pages/home_screen.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_state.dart';
import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:alt__wally/features/wallpaper/presentation/pages/wallpaper_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class WallpaperCarousel extends StatefulWidget {
  final List<WallpaperEntity?> wallpapers;
  final String title;
  final int index;
  const WallpaperCarousel(
      {super.key,
      required this.title,
      required this.index,
      required this.wallpapers});

  @override
  State<WallpaperCarousel> createState() => _WallpaperCarouselState();
}

class _WallpaperCarouselState extends State<WallpaperCarousel> {
  int _current = 0;
  int _selectedValue = 0;
  @override
  void initState() {
    super.initState();
  }

  List<Widget> generateImageTitles(context) {
    return widget.wallpapers.map((element) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: CachedNetworkImage(
              height: double.infinity,
              fit: BoxFit.cover,
              imageUrl: element == null ? '' : element.imageUrl!,
              placeholder: (context, url) => const Center(
                child: SizedBox(
                    height: 20, width: 20, child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors
                    .red, // Change this to the desired error background color
                child: const Center(
                  child: Icon(Icons.error, color: Colors.white),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 200,
                          width: double.infinity,
                          padding: EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    int location = WallpaperManager.HOME_SCREEN;
                                    String? imageUrl = element?.imageUrl;
                                    if (imageUrl != null) {
                                      var file = await DefaultCacheManager()
                                          .getSingleFile(imageUrl);
                                      final bool result = await WallpaperManager
                                          .setWallpaperFromFile(
                                              file.path, location);
                                      if (result) {
                                        showToast(
                                            message:
                                                "Wallpaper Set Successfully!!");
                                      } else {
                                        showToast(
                                            message: "Something went wrong!!");
                                      }
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Text('Home Screen')),
                              TextButton(
                                  onPressed: () async {
                                    int location = WallpaperManager.LOCK_SCREEN;
                                    String? imageUrl = element?.imageUrl;
                                    if (imageUrl != null) {
                                      var file = await DefaultCacheManager()
                                          .getSingleFile(imageUrl);
                                      final bool result = await WallpaperManager
                                          .setWallpaperFromFile(
                                              file.path, location);
                                      if (result) {
                                        showToast(
                                            message:
                                                "Lock Screen Set Successfully!!");
                                      } else {
                                        showToast(
                                            message: "Something went wrong!!");
                                      }
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Text('Lock Screen')),
                              TextButton(
                                  onPressed: () async {
                                    int location = WallpaperManager.BOTH_SCREEN;
                                    String? imageUrl = element?.imageUrl;
                                    if (imageUrl != null) {
                                      var file = await DefaultCacheManager()
                                          .getSingleFile(imageUrl);
                                      final bool result = await WallpaperManager
                                          .setWallpaperFromFile(
                                              file.path, location);
                                      if (result) {
                                        showToast(message: "Successfull!!");
                                      } else {
                                        showToast(
                                            message: "Something went wrong!!");
                                      }
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Text('Home Screen + Lock Screen')),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Text('Set As'),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 12),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WallpaperScreen(wallpaper: element!),
                      ),
                    );
                  },
                  child: Text('View'),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                        fontSize: 12), // Adjust the font size as needed
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey<int>(_selectedValue),
      appBar: AppBar(
        // leading: IconButton(
        //     onPressed: () {
        //       Navigator.pushNamed(context, HomeScreen.routeName);
        //     },
        //     icon: const Icon(Icons.home)),
        title: Image.asset('assets/images/name.png', height: 24),
        centerTitle: true,
        actions: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(index: 3),
                      ),
                    );
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
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
                );
              }
              return Container();
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          Center(
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Stack(
            children: [
              CarouselSlider(
                  items: generateImageTitles(context),
                  options: CarouselOptions(
                      enlargeCenterPage: true,
                      aspectRatio: 14 / 16,
                      enableInfiniteScroll: false,
                      initialPage: _current,
                      viewportFraction: 0.7,
                      onPageChanged: (index, other) {
                        setState(() {
                          _current = index;
                        });
                      }))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          // Padding(
          //   padding: EdgeInsets.all(20),
          //   child: Container(
          //     padding: EdgeInsets.all(10),
          //     decoration: BoxDecoration(
          //       color: Color(0xFFEBEBEC).withOpacity(0.3),
          //       borderRadius: BorderRadius.circular(10),
          //       border: Border.all(
          //         color: Colors.black.withOpacity(0.3),
          //         width: 1.0,
          //       ),
          //     ),
          //     child: Row(
          //       children: [
          //         Expanded(
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 'Creator Name',
          //                 style: TextStyle(
          //                   fontSize: 9,
          //                   color: Colors.black,
          //                   fontWeight: FontWeight.w600,
          //                 ),
          //               ),
          //               Text(
          //                 widget.wallpapers[_current]?.user?.name ??
          //                     'Unknown User',
          //                 style: TextStyle(
          //                   fontSize: 9,
          //                   color: Color(0xFFFF9E00),
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //         VerticalDivider(
          //           color: Colors.black,
          //           width: 2,
          //           thickness: 10,
          //         ),
          //         Expanded(
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 'Wallpaper Name',
          //                 style: TextStyle(
          //                   fontSize: 9,
          //                   color: Colors.black,
          //                   fontWeight: FontWeight.w600,
          //                 ),
          //               ),
          //               Text(
          //                 widget.wallpapers[_current]?.title ?? 'Unknown User',
          //                 style: TextStyle(
          //                   fontSize: 9,
          //                   color: Color(0xFFFF9E00),
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //         VerticalDivider(
          //           color: Colors.black.withOpacity(0.3),
          //           width: 2,
          //           thickness: 1,
          //         ),
          //         Expanded(
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 'Wally Size',
          //                 style: TextStyle(
          //                   fontSize: 9,
          //                   color: Colors.black,
          //                   fontWeight: FontWeight.w600,
          //                 ),
          //               ),
          //               Text(
          //                 "${widget.wallpapers[_current]?.size} MB",
          //                 style: TextStyle(
          //                   fontSize: 9,
          //                   color: Color(0xFFFF9E00),
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ]),
      ),
    );
  }
}
