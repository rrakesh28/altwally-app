import 'package:alt__wally/core/common/widgets/wallpaper_carousel.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/get_favourite/get_favourite_wallpapers_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/get_favourite/get_favourite_wallpapers_state.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouriteWallpapersDetailsScreen extends StatefulWidget {
  static const String routeName = '/favourite-wallapers-details-screen';
  final int index;
  const FavouriteWallpapersDetailsScreen({super.key, required this.index});

  @override
  State<FavouriteWallpapersDetailsScreen> createState() =>
      _FavouriteWallpapersDetailsScreenState();
}

class _FavouriteWallpapersDetailsScreenState
    extends State<FavouriteWallpapersDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetRecentlyAddedWallpapersCubit, GetRecentlyAddedState>(
      builder: (context, state) {
        if (state is Initial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is Loaded) {
          final filteredWallpapers = state.wallpapers
              .where((wallpaper) => wallpaper?.favourite == true)
              .toList();
          return WallpaperCarousel(
              title: "Favourites",
              index: widget.index,
              wallpapers: filteredWallpapers);
        } else if (state is GetFavouriteWallpapersFailed) {
          return Text('Failed to load wallpapers');
        } else {
          return Container();
        }
      },
    );
  }
}
