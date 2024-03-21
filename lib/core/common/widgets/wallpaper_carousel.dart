import 'dart:io';

import 'package:alt__wally/common/toast.dart';
import 'package:alt__wally/features/app/presentation/pages/app_screen.dart';
import 'package:alt__wally/features/settings/presentation/pages/settings_screen.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_state.dart';
import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/get_favourite/get_favourite_wallpapers_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/get_favourite/get_favourite_wallpapers_state.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/toggle_favourite/toggle_favourite_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/pages/wallpaper_screen.dart';
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

  String formatNumber(int number) {
    if (number >= 1000) {
      double numberInK = number / 1000;
      return '${numberInK.toStringAsFixed(1)}k';
    } else {
      return '$number';
    }
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
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WallpaperScreen(wallpaper: element!),
            ),
          );
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.file(
                File(element?.imageUrl ??
                    ''), // Assuming element is of type WallpaperEntity
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.red,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 30,
                    width: 65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 200,
                                width: double.infinity,
                                padding: const EdgeInsets.only(top: 10),
                                child: loading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.black),
                                      )
                                    : Column(
                                        children: [
                                          if (loading)
                                            const Center(
                                              child: SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ),
                                          TextButton(
                                              onPressed: () {
                                                _setHomeScreen(element);
                                              },
                                              child: const Text('Home Screen')),
                                          TextButton(
                                              onPressed: () {
                                                _setLockScreen(element);
                                              },
                                              child: const Text('Lock Screen')),
                                          TextButton(
                                              onPressed: () {
                                                _setBoth(element);
                                              },
                                              child: const Text(
                                                  'Home Screen + Lock Screen')),
                                        ],
                                      ),
                              );
                            },
                          );
                        },
                        child: const Text(
                          'Set As',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  Container(
                    height: 30,
                    width: 65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WallpaperScreen(wallpaper: element!),
                            ),
                          );
                        },
                        child: const Text(
                          'View',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final getFavouritesCubit =
        BlocProvider.of<GetFavouriteWallpapersCubit>(context);

    if (getFavouritesCubit.state is! GetFavouriteWallpapersLoaded) {
      BlocProvider.of<GetFavouriteWallpapersCubit>(context).fetchData();
    }

    List<bool> isFavorites = (getFavouritesCubit.state
            is GetFavouriteWallpapersLoaded)
        ? List.generate(widget.wallpapers.length, (index) {
            return (getFavouritesCubit.state as GetFavouriteWallpapersLoaded)
                .wallpapers
                .any((favWallpaper) =>
                    favWallpaper?.id == widget.wallpapers[index]?.id);
          })
        : List.filled(widget.wallpapers.length, false);

    print(isFavorites);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, SettingsScreen.routeName);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              'assets/images/menu.png',
              height: 20,
            ),
          ),
        ),
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AppScreen(index: 0),
              ),
            );
          },
          child: Image.asset('assets/images/name.png', height: 24),
        ),
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
                    height: 50,
                    width: 50,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
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
            height: 20,
          ),
          Stack(
            children: [
              CarouselSlider(
                items: generateImageTitles(context),
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  aspectRatio: 0.8,
                  initialPage: _current,
                  viewportFraction: 0.7,
                  enlargeFactor: 0.3,
                  enableInfiniteScroll: true,
                  onPageChanged: (index, other) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.cancel_outlined,
                color: Colors.black45,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9).withOpacity(0.4),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: isFavorites[_current] == true
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.favorite_outline,
                                ),
                          onPressed: () {
                            if (isFavorites[_current]) {
                              setState(() {
                                isFavorites[_current] = false;
                              });
                              BlocProvider.of<ToggleFavouriteWallpaperCubit>(
                                      context)
                                  .toggle(
                                      widget.wallpapers[_current]!, 'remove');
                              BlocProvider.of<GetFavouriteWallpapersCubit>(
                                      context)
                                  .remove(widget.wallpapers[_current]!);
                            } else {
                              setState(() {
                                isFavorites[_current] = true;
                              });
                              BlocProvider.of<ToggleFavouriteWallpaperCubit>(
                                      context)
                                  .toggle(widget.wallpapers[_current]!, 'add');
                              BlocProvider.of<GetFavouriteWallpapersCubit>(
                                      context)
                                  .add(widget.wallpapers[_current]!);
                            }
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          formatNumber(widget.wallpapers[_current]?.likes ?? 0),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.visibility_outlined),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          formatNumber(widget.wallpapers[_current]?.views ?? 0),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.downloading_outlined),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          formatNumber(
                              widget.wallpapers[_current]?.downloads ?? 0),
                          style: const TextStyle(fontWeight: FontWeight.w600),
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
