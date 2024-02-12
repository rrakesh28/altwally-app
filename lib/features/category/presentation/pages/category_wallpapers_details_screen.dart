import 'package:alt__wally/core/common/widgets/wallpaper_carousel.dart';
import 'package:alt__wally/features/category/domain/entities/category_entity.dart';
import 'package:alt__wally/features/category/presentation/cubit/wallpapers/wallpapers_cubit.dart';
import 'package:alt__wally/features/category/presentation/cubit/wallpapers/wallpapers_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryWallpapersDetailsScreen extends StatefulWidget {
  static const String routeName = '/wall-of-the-month-screen';
  final int index;
  final CategoryEntity category;
  const CategoryWallpapersDetailsScreen(
      {super.key, required this.index, required this.category});

  @override
  State<CategoryWallpapersDetailsScreen> createState() =>
      _CategoryWallpapersDetailsScreenState();
}

class _CategoryWallpapersDetailsScreenState
    extends State<CategoryWallpapersDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WallpapersCubit, WallPapersState>(
      builder: (context, state) {
        if (state is WallpapersInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WallpapersLoaded) {
          return WallpaperCarousel(
              title: widget.category.name!,
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
