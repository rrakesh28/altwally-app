import 'package:alt__wally/core/common/widgets/wallpaper_carousel.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/popular_wallpapers/popular_wallpapers_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/popular_wallpapers/popular_wallpapers_state.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularWallpapersDetailsScreen extends StatefulWidget {
  static const String routeName = '/recently-added-wallapers-details-screen';
  final int index;
  const PopularWallpapersDetailsScreen({super.key, required this.index});

  @override
  State<PopularWallpapersDetailsScreen> createState() =>
      _PopularWallpapersDetailsScreenState();
}

class _PopularWallpapersDetailsScreenState
    extends State<PopularWallpapersDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetPopularWallpapersCubit, GetPopularWallpapersState>(
      builder: (context, state) {
        if (state is PopularInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PopularLoaded) {
          return WallpaperCarousel(
              title: "Recently Added",
              index: widget.index,
              wallpapers: state.wallpapers);
        } else if (state is PopularFailed) {
          return Text('Failed to load wallpapers');
        } else {
          return Container();
        }
      },
    );
  }
}
