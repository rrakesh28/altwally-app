import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/get_favourite/get_favourite_wallpapers_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/get_favourite/get_favourite_wallpapers_state.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/toggle_favourite/toggle_favourite_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/pages/favourites_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

    if (favouritesState is GetFavouriteWallpapersFailed ||
        favouritesState is GetFavouriteWallpapersInitial) {
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
          child: Container(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: BlocConsumer<GetFavouriteWallpapersCubit,
                        GetFavouriteWallpapersState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is GetFavouriteWallpapersInitial) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is GetFavouriteWallpapersLoaded) {
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: CachedNetworkImage(
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                          imageUrl: state.wallpapers[index]
                                                  ?.imageUrl ??
                                              '',
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator()),
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
                                        )),
                                    if (state.wallpapers[index]?.category !=
                                        null) // Check for null before accessing category
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                top: 5,
                                                right: 10,
                                                bottom: 5),
                                            child: Row(children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    state.wallpapers[index]
                                                            ?.category?.name ??
                                                        'Default Category',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  ),
                                                  Text(
                                                    state.wallpapers[index]!
                                                            .title ??
                                                        'Default Title',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                icon: state.wallpapers[index]
                                                            ?.favourite ??
                                                        false
                                                    ? const Icon(
                                                        Icons.favorite,
                                                        color: Colors
                                                            .red, // Customize the color if needed
                                                      )
                                                    : const Icon(
                                                        Icons.favorite_outline,
                                                        color: Colors.white),
                                                onPressed: () {
                                                  BlocProvider.of<
                                                              ToggleFavouriteWallpaperCubit>(
                                                          context)
                                                      .toggle(state
                                                          .wallpapers[index]!);
                                                  setState(() {
                                                    state.wallpapers[index]
                                                        ?.favourite = !(state
                                                            .wallpapers[index]
                                                            ?.favourite ??
                                                        false);
                                                  });
                                                },
                                              )
                                            ]),
                                          ),
                                        ), // Replace YourWidget with your desired content
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
      ),
    );
  }
}
