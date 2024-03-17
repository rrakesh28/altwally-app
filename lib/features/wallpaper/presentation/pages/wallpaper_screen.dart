import 'dart:io';

import 'package:alt__wally/common/toast.dart';
import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/get_favourite/get_favourite_wallpapers_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/get_favourite/get_favourite_wallpapers_state.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/toggle_favourite/toggle_favourite_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class WallpaperScreen extends StatefulWidget {
  final WallpaperEntity wallpaper;
  const WallpaperScreen({super.key, required this.wallpaper});

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  bool loading = false;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();

    final favouritesState = context.read<GetFavouriteWallpapersCubit>().state;

    if (favouritesState is! GetFavouriteWallpapersLoaded) {
      BlocProvider.of<GetFavouriteWallpapersCubit>(context).fetchData();
    }
    isFavorite = _checkIfFavorite();
  }

  bool _checkIfFavorite() {
    final favouritesState = context.read<GetFavouriteWallpapersCubit>().state;
    if (favouritesState is GetFavouriteWallpapersLoaded) {
      return favouritesState.wallpapers
          .any((favWallpaper) => favWallpaper?.id == widget.wallpaper.id);
    }
    return false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          Navigator.pop(context);
        },
        child: Stack(
          children: [
            Image.file(
              File(widget.wallpaper.imageUrl!),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: IconButton(
                      icon: isFavorite == true
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite_outline,
                            ),
                      onPressed: () {
                        if (isFavorite) {
                          BlocProvider.of<ToggleFavouriteWallpaperCubit>(
                                  context)
                              .toggle(widget.wallpaper, 'remove');
                          BlocProvider.of<GetFavouriteWallpapersCubit>(context)
                              .remove(widget.wallpaper);
                        } else {
                          BlocProvider.of<ToggleFavouriteWallpaperCubit>(
                                  context)
                              .toggle(widget.wallpaper, 'add');
                          BlocProvider.of<GetFavouriteWallpapersCubit>(context)
                              .add(widget.wallpaper);
                        }
                      },
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20, // Adjust the radius as needed
                    child: IconButton(
                      icon: const Icon(
                        Icons.format_paint_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 200,
                              width: double.infinity,
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  if (loading)
                                    const Center(
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  TextButton(
                                      onPressed: () async {
                                        _setHomeScreen(
                                            widget.wallpaper.imageUrl!);
                                      },
                                      child: const Text('Home Screen')),
                                  TextButton(
                                      onPressed: () async {
                                        _setLockScreen(
                                            widget.wallpaper.imageUrl!);
                                      },
                                      child: const Text('Lock Screen')),
                                  TextButton(
                                    onPressed: () async {
                                      _setBoth(widget.wallpaper.imageUrl);
                                    },
                                    child:
                                        const Text('Home Screen + Lock Screen'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
