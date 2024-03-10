import 'package:alt__wally/core/common/widgets/wallpaper_carousel.dart';
import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WallOfTheMonthScreen extends StatefulWidget {
  static const String routeName = '/wall-of-the-month-screen';
  final int index;
  const WallOfTheMonthScreen({super.key, required this.index});

  @override
  State<WallOfTheMonthScreen> createState() => _WallOfTheMonthScreenState();
}

class _WallOfTheMonthScreenState extends State<WallOfTheMonthScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetRecentlyAddedWallpapersCubit, GetRecentlyAddedState>(
      builder: (context, state) {
        if (state is Initial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is Loaded) {
          final filteredWallpapers = state.wallpapers
              .where((wallpaper) => wallpaper?.wallOfTheMonth == true)
              .toList()
              .whereType<WallpaperEntity>();

          return WallpaperCarousel(
              title: "Wall of the month",
              index: widget.index,
              wallpapers: filteredWallpapers.toList());
        } else if (state is Failed) {
          return Text('Failed to load wallpapers');
        } else {
          return Container();
        }
      },
    );
  }
}
