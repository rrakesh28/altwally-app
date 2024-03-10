import 'package:alt__wally/core/common/widgets/wallpaper_carousel.dart';
import 'package:alt__wally/features/category/domain/entities/category_entity.dart';
import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryWallpapersDetailScreen extends StatefulWidget {
  final int index;
  final CategoryEntity category;
  const CategoryWallpapersDetailScreen(
      {super.key, required this.index, required this.category});

  @override
  State<CategoryWallpapersDetailScreen> createState() =>
      _CategoryWallpapersDetailScreenState();
}

class _CategoryWallpapersDetailScreenState
    extends State<CategoryWallpapersDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetRecentlyAddedWallpapersCubit, GetRecentlyAddedState>(
      builder: (context, state) {
        if (state is Initial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is Loaded) {
          final filteredWallpapers = state.wallpapers
              .where((wallpaper) => wallpaper?.categoryId == widget.category.id)
              .toList()
              .whereType<WallpaperEntity>();
          return WallpaperCarousel(
              title: "Favourites",
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
