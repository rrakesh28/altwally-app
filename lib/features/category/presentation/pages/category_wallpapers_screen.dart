import 'package:alt__wally/features/category/domain/entities/category_entity.dart';
import 'package:alt__wally/features/category/presentation/cubit/wallpapers/wallpapers_cubit.dart';
import 'package:alt__wally/features/category/presentation/cubit/wallpapers/wallpapers_state.dart';
import 'package:alt__wally/features/category/presentation/pages/category_wallpapers_details_screen.dart';
import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryWallpapersListScreen extends StatefulWidget {
  static const String routeName = "/category-wallpapers-list-screen";

  final CategoryEntity category;

  const CategoryWallpapersListScreen({super.key, required this.category});

  @override
  State<CategoryWallpapersListScreen> createState() =>
      _CategoryWallpapersListScreenState();
}

class _CategoryWallpapersListScreenState
    extends State<CategoryWallpapersListScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WallpapersCubit>(context).fetchData(widget.category.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.category.name ?? ''),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: BlocConsumer<WallpapersCubit, WallPapersState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          if (state is WallpapersInitial) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is WallpapersLoaded) {
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 15,
                                childAspectRatio: 0.7,
                              ),
                              itemCount: state.wallpapers.length,
                              itemBuilder: (context, index) {
                                WallpaperEntity wallpaper =
                                    state.wallpapers[index]!;
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CategoryWallpapersDetailsScreen(
                                                category: widget.category,
                                                index: index),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.zero,
                                    child: CachedNetworkImage(
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      imageUrl: wallpaper.imageUrl!,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator()),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color: Colors
                                            .red, // Change this to the desired error background color
                                        child: const Center(
                                          child: Icon(Icons.error,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Container();
                          }
                        })),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
