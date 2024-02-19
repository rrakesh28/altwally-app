// ignore_for_file: prefer_const_constructors

import 'package:alt__wally/common/toast.dart';
import 'package:alt__wally/features/app/presentation/pages/app_screen.dart';
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
  bool loading = false;
  @override
  void initState() {
    super.initState();
    _current = widget.index;
  }

  void _setHomeScreen(element) async {
    setState(() {
      loading = true;
    });
    int location = WallpaperManager.HOME_SCREEN;
    String? imageUrl = element?.imageUrl;
    if (imageUrl != null) {
      var file = await DefaultCacheManager().getSingleFile(imageUrl);
      final bool result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
      if (result) {
        showToast(message: "Wallpaper Set Successfully!!");
      } else {
        showToast(message: "Something went wrong!!");
      }
    }
    Navigator.pop(context);
    setState(() {
      loading = false;
    });
  }

  void _setLockScreen(element) async {
    setState(() {
      loading = true;
    });
    int location = WallpaperManager.LOCK_SCREEN;
    String? imageUrl = element?.imageUrl;
    if (imageUrl != null) {
      var file = await DefaultCacheManager().getSingleFile(imageUrl);
      final bool result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
      if (result) {
        showToast(message: "Lock Screen Set Successfully!!");
      } else {
        showToast(message: "Something went wrong!!");
      }
    }
    Navigator.pop(context);
    setState(() {
      loading = false;
    });
  }

  void _setBoth(element) async {
    setState(() {
      loading = true;
    });
    int location = WallpaperManager.BOTH_SCREEN;
    String? imageUrl = element?.imageUrl;
    if (imageUrl != null) {
      var file = await DefaultCacheManager().getSingleFile(imageUrl);
      final bool result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
      if (result) {
        showToast(message: "Successful!!");
      } else {
        showToast(message: "Something went wrong!!");
      }
    }
    Navigator.pop(context);
    setState(() {
      loading = false;
    });
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
                          child: loading
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.black),
                                )
                              : Column(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          _setHomeScreen(element);
                                        },
                                        child: Text('Home Screen')),
                                    TextButton(
                                        onPressed: () {
                                          _setLockScreen(element);
                                        },
                                        child: Text('Lock Screen')),
                                    TextButton(
                                        onPressed: () {
                                          _setBoth(element);
                                        },
                                        child:
                                            Text('Home Screen + Lock Screen')),
                                  ],
                                ),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 12),
                  ),
                  child: Text('Set As'),
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
      appBar: AppBar(
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
                        builder: (context) => const AppScreen(index: 3),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9).withOpacity(0.4),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.wallpapers[_current]?.favourite ?? false
                            ? const Icon(
                                Icons.favorite,
                                color:
                                    Colors.red, // Customize the color if needed
                              )
                            : const Icon(
                                Icons.favorite_outline,
                              ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '1.5k',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.visibility_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '1.5k',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.downloading_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '1.5k',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
