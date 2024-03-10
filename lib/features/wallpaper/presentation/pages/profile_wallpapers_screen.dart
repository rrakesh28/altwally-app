import 'package:alt__wally/core/common/widgets/wallpaper_carousel.dart';
import 'package:alt__wally/features/user/presentation/cubit/profile/profile_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/profile/profile_state.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileWallpapersScreen extends StatefulWidget {
  static const String routeName = '/wallpaper-screen';

  final int index;
  String userId;

  ProfileWallpapersScreen({Key? key, required this.index, required this.userId})
      : super(key: key);

  @override
  State<ProfileWallpapersScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ProfileWallpapersScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetRecentlyAddedWallpapersCubit, GetRecentlyAddedState>(
      builder: (context, state) {
        if (state is ProfileInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is Loaded) {
          final filteredWallpapers = state.wallpapers
              .where((wallpaper) => wallpaper?.userId == widget.userId)
              .toList();
          return WallpaperCarousel(
              title: 'Profile',
              index: widget.index,
              wallpapers: filteredWallpapers);
        } else if (state is ProfileLoadingFailed) {
          return Text('Failed to load wallpapers');
        } else {
          return Container();
        }
      },
    );
  }
}
