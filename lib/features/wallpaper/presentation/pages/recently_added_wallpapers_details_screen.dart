import 'package:alt__wally/core/common/widgets/wallpaper_carousel.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentlyAddedWallpapersDetailsScreen extends StatefulWidget {
  static const String routeName = '/recently-added-wallapers-details-screen';
  final int index;
  const RecentlyAddedWallpapersDetailsScreen({super.key, required this.index});

  @override
  State<RecentlyAddedWallpapersDetailsScreen> createState() =>
      _RecentlyAddedWallpapersDetailsScreenState();
}

class _RecentlyAddedWallpapersDetailsScreenState
    extends State<RecentlyAddedWallpapersDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetRecentlyAddedWallpapersCubit, GetRecentlyAddedState>(
      builder: (context, state) {
        if (state is Initial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is Loaded) {
          return WallpaperCarousel(
              title: "Recently Added",
              index: widget.index,
              wallpapers: state.wallpapers);
        } else if (state is Failed) {
          return Text('Failed to load wallpapers');
        } else {
          return Container();
        }
      },
    );
  }
}
