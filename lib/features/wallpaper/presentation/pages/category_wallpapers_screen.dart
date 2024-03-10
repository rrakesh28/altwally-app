import 'package:alt__wally/core/common/widgets/wallpaper_card.dart';
import 'package:alt__wally/features/category/domain/entities/category_entity.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_state.dart';
import 'package:alt__wally/features/wallpaper/presentation/pages/category_wallpapers_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryWallpapersScreen extends StatefulWidget {
  static const String routeName = "/category-wallpapers-screen";
  final CategoryEntity category;

  const CategoryWallpapersScreen({super.key, required this.category});

  @override
  State<CategoryWallpapersScreen> createState() =>
      _CategoryWallpapersScreenState();
}

class _CategoryWallpapersScreenState extends State<CategoryWallpapersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(widget.category.name!),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: BlocConsumer<GetRecentlyAddedWallpapersCubit,
                  GetRecentlyAddedState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is Initial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is Loaded) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: state.wallpapers
                          .where((wallpaper) =>
                              wallpaper?.categoryId == widget.category.id)
                          .length,
                      itemBuilder: (context, index) {
                        final filteredWallpapers = state.wallpapers
                            .where((wallpaper) =>
                                wallpaper?.categoryId == widget.category.id)
                            .toList();

                        return WallpaperItem(
                          wallpaper: filteredWallpapers[index]!,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CategoryWallpapersDetailScreen(
                                  index: index,
                                  category: widget.category,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
