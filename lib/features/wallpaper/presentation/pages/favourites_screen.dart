import 'dart:io';

import 'package:alt__wally/core/common/widgets/wallpaper_card.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/get_favourite/get_favourite_wallpapers_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/get_favourite/get_favourite_wallpapers_state.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/toggle_favourite/toggle_favourite_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/pages/favourites_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouriteWallpapersScreen extends StatefulWidget {
  static const String routeName = "/favourite-wallpapers-screen";

  const FavouriteWallpapersScreen({super.key});

  @override
  State<FavouriteWallpapersScreen> createState() =>
      _FavouriteWallpapersScreenState();
}

class _FavouriteWallpapersScreenState extends State<FavouriteWallpapersScreen> {
  @override
  void initState() {
    super.initState();
    final favouritesState = context.read<GetFavouriteWallpapersCubit>().state;

    if (favouritesState is! GetFavouriteWallpapersLoaded) {
      BlocProvider.of<GetFavouriteWallpapersCubit>(context).fetchData();
    }
  }

  Future<void> _refresh() async {
    BlocProvider.of<GetFavouriteWallpapersCubit>(context).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Favourites",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: BlocBuilder<GetFavouriteWallpapersCubit,
                      GetFavouriteWallpapersState>(
                    builder: (context, state) {
                      if (state is GetFavouriteWallpapersInitial) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is GetFavouriteWallpapersLoaded) {
                        if (state.wallpapers.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/favorite.png',
                                  height: 70,
                                ),
                                const Text(
                                  'Your have currently no favourites',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromRGBO(0, 0, 0, 0.3),
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          );
                        }
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 0.6,
                          ),
                          itemCount: state.wallpapers.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FavouriteWallpapersDetailsScreen(
                                            index: index),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Image.file(
                                      File(state.wallpapers[index]?.imageUrl ??
                                          ''),
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                        color: Colors.red,
                                        child: const Center(
                                          child: Icon(Icons.error,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (state.wallpapers[index]?.category != null)
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                            top: 5,
                                            right: 10,
                                            bottom: 5,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      state
                                                              .wallpapers[index]
                                                              ?.category
                                                              ?.name ??
                                                          'Default Category',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(
                                                      state.wallpapers[index]
                                                              ?.title ??
                                                          'Default Title',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  try {
                                                    BlocProvider.of<
                                                                ToggleFavouriteWallpaperCubit>(
                                                            context)
                                                        .toggle(
                                                            state.wallpapers[
                                                                index]!,
                                                            'remove');
                                                    BlocProvider.of<
                                                                GetFavouriteWallpapersCubit>(
                                                            context)
                                                        .remove(
                                                            state.wallpapers[
                                                                index]!);
                                                  } catch (e) {
                                                    print(e);
                                                  }
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
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
        ),
      ),
    );
  }
}
