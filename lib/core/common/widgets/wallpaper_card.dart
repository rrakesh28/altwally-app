import 'dart:io';

import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/get_favourite/get_favourite_wallpapers_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/get_favourite/get_favourite_wallpapers_state.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/toggle_favourite/toggle_favourite_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WallpaperItem extends StatefulWidget {
  final WallpaperEntity wallpaper;
  final Function() onTap;

  const WallpaperItem({
    Key? key,
    required this.wallpaper,
    required this.onTap,
  }) : super(key: key);

  @override
  State<WallpaperItem> createState() => _WallpaperItemState();
}

class _WallpaperItemState extends State<WallpaperItem> {
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetFavouriteWallpapersCubit,
        GetFavouriteWallpapersState>(
      listener: (context, state) {
        if (state is GetFavouriteWallpapersLoaded) {
          setState(() {
            isFavorite = state.wallpapers
                .any((favWallpaper) => favWallpaper?.id == widget.wallpaper.id);
          });
        }
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.file(
                File(widget.wallpaper.imageUrl!),
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.red,
                  child: const Center(
                    child: Icon(Icons.error, color: Colors.white),
                  ),
                ),
              ),
            ),
            if (widget.wallpaper.category != null)
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
                                widget.wallpaper.category?.name ??
                                    'Default Category',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                widget.wallpaper.title ?? 'Default Title',
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
                          icon: isFavorite == true
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.favorite_outline,
                                  color: Colors.white,
                                ),
                          onPressed: () {
                            try {
                              if (isFavorite) {
                                BlocProvider.of<ToggleFavouriteWallpaperCubit>(
                                        context)
                                    .toggle(widget.wallpaper, 'remove');
                                BlocProvider.of<GetFavouriteWallpapersCubit>(
                                        context)
                                    .remove(widget.wallpaper);
                              } else {
                                BlocProvider.of<ToggleFavouriteWallpaperCubit>(
                                        context)
                                    .toggle(widget.wallpaper, 'add');
                                BlocProvider.of<GetFavouriteWallpapersCubit>(
                                        context)
                                    .add(widget.wallpaper);
                              }
                            } catch (e) {
                              print(e);
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
      ),
    );
  }
}
