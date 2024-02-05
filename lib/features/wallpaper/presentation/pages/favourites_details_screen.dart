import 'package:alt__wally/core/common/widgets/wallpaper_carousel.dart';
import 'package:alt__wally/features/category/domain/entities/category_entity.dart';
import 'package:alt__wally/features/category/presentation/cubit/wallpapers/wallpapers_cubit.dart';
import 'package:alt__wally/features/category/presentation/cubit/wallpapers/wallpapers_state.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/get_favourite/get_favourite_wallpapers_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/get_favourite/get_favourite_wallpapers_state.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/wall_of_the_month/wall_of_the_month_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/wall_of_the_month/wall_of_the_month_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetFavouriteWallpapersCubit,
        GetFavouriteWallpapersState>(
      builder: (context, state) {
        if (state is GetFavouriteWallpapersInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetFavouriteWallpapersLoaded) {
          return WallpaperCarousel(
              title: "Favourites",
              index: widget.index,
              wallpapers: state.wallpapers);
        } else if (state is WallpapersLoadingFailed) {
          return Text('Failed to load wallpapers');
        } else {
          return Container();
        }
      },
    );
  }
}
