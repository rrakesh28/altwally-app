import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_state.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/toggle_favourite/toggle_favourite_cubit.dart';
import 'package:alt__wally/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class WallpaperItem extends StatelessWidget {
  final WallpaperEntity wallpaper;
  final Function() onTap;

  const WallpaperItem({
    Key? key,
    required this.wallpaper,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: CachedNetworkImage(
              height: double.infinity,
              fit: BoxFit.cover,
              imageUrl: wallpaper.imageUrl ?? '',
              placeholder: (context, url) {
                if (wallpaper.blurHash != null) {
                  return BlurHash(
                    hash: wallpaper.blurHash!,
                    imageFit: BoxFit.cover,
                    duration: const Duration(milliseconds: 500),
                  );
                } else {
                  return const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
              errorWidget: (context, url, error) => Container(
                color: Colors.red,
                child: const Center(
                  child: Icon(Icons.error, color: Colors.white),
                ),
              ),
              cacheManager: CustomCacheManager.instance,
            ),
          ),
          if (wallpaper.category != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    top: 5,
                    right: 10,
                    bottom: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              wallpaper.category?.name ?? 'Default Category',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              wallpaper.title ?? 'Default Title',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: wallpaper.favourite ?? false
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_outline,
                                color: Colors.white,
                              ),
                        onPressed: () {
                          BlocProvider.of<ToggleFavouriteWallpaperCubit>(
                                  context)
                              .toggle(wallpaper);
                          final recentAddedCubit =
                              BlocProvider.of<GetRecentlyAddedWallpapersCubit>(
                                  context);

                          if (recentAddedCubit.state is Loaded) {
                            final loadedState =
                                recentAddedCubit.state as Loaded;
                            final updatedWallpapers =
                                loadedState.wallpapers.map((wp) {
                              if ((wp?.id == wallpaper.id) && (wp != null)) {
                                return wp.copyWith(
                                    favourite: !(wp.favourite ?? false));
                              }
                              return wp;
                            }).toList();

                            recentAddedCubit
                                .updateWallpapers(updatedWallpapers);
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
