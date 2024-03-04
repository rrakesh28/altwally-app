import 'package:alt__wally/common/toast.dart';
import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: widget.wallpaper.imageUrl!, // Replace with your image URL
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 70,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: IconButton(
                      icon: widget.wallpaper.favourite ?? false
                          ? const Icon(
                              Icons.favorite,
                              color:
                                  Colors.red, // Customize the color if needed
                            )
                          : const Icon(
                              Icons.favorite_outline,
                            ),
                      onPressed: () {
                        BlocProvider.of<ToggleFavouriteWallpaperCubit>(context)
                            .toggle(widget.wallpaper);
                        setState(() {
                          widget.wallpaper.favourite =
                              !(widget.wallpaper.favourite ?? false);
                        });
                      },
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20, // Adjust the radius as needed
                    child: IconButton(
                      icon: Icon(
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
                              padding: EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  TextButton(
                                      onPressed: () async {
                                        int location =
                                            WallpaperManager.HOME_SCREEN;
                                        String? imageUrl =
                                            widget.wallpaper.imageUrl;
                                        if (imageUrl != null) {
                                          var file = await DefaultCacheManager()
                                              .getSingleFile(imageUrl);
                                          final bool result =
                                              await WallpaperManager
                                                  .setWallpaperFromFile(
                                                      file.path, location);
                                          if (result) {
                                            showToast(
                                                message:
                                                    "Wallpaper Set Successfully!!");
                                          } else {
                                            showToast(
                                                message:
                                                    "Something went wrong!!");
                                          }
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: Text('Home Screen')),
                                  TextButton(
                                      onPressed: () async {
                                        int location =
                                            WallpaperManager.LOCK_SCREEN;
                                        String? imageUrl =
                                            widget.wallpaper.imageUrl;
                                        if (imageUrl != null) {
                                          var file = await DefaultCacheManager()
                                              .getSingleFile(imageUrl);
                                          final bool result =
                                              await WallpaperManager
                                                  .setWallpaperFromFile(
                                                      file.path, location);
                                          if (result) {
                                            showToast(
                                                message:
                                                    "Lock Screen Set Successfully!!");
                                          } else {
                                            showToast(
                                                message:
                                                    "Something went wrong!!");
                                          }
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: Text('Lock Screen')),
                                  TextButton(
                                      onPressed: () async {
                                        int location =
                                            WallpaperManager.BOTH_SCREEN;
                                        String? imageUrl =
                                            widget.wallpaper.imageUrl;
                                        if (imageUrl != null) {
                                          var file = await DefaultCacheManager()
                                              .getSingleFile(imageUrl);
                                          final bool result =
                                              await WallpaperManager
                                                  .setWallpaperFromFile(
                                                      file.path, location);
                                          if (result) {
                                            showToast(message: "Successfull!!");
                                          } else {
                                            showToast(
                                                message:
                                                    "Something went wrong!!");
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
          ),
        ],
      ),
    );
  }
}
