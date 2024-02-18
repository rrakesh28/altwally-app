import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_state.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/toggle_favourite/toggle_favourite_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreScreen extends StatefulWidget {
  static const String routeName = '/explore-screen';

  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetRecentlyAddedWallpapersCubit>(context).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Explore'),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.black,
            dividerHeight: 0,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                child: Text(
                  'New Arrivals',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  'Popular',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ), //
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              CustomScrollView(
                slivers: [
                  BlocBuilder<GetRecentlyAddedWallpapersCubit,
                      GetRecentlyAddedState>(
                    builder: (context, state) {
                      print('asdf');
                      if (state is Loaded) {
                        return SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    print('adsf');
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            color: Colors.red,
                                            child: const Center(
                                              child: Icon(Icons.error,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (state.wallpapers[index]?.category !=
                                          null)
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
                                                bottomLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20),
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
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        state
                                                                .wallpapers[
                                                                    index]
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
                                                      ),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  IconButton(
                                                    icon: state
                                                                .wallpapers[
                                                                    index]
                                                                ?.favourite ??
                                                            false
                                                        ? const Icon(
                                                            Icons.favorite,
                                                            color: Colors.red,
                                                          )
                                                        : const Icon(Icons
                                                            .favorite_outline),
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  ToggleFavouriteWallpaperCubit>(
                                                              context)
                                                          .toggle(
                                                              state.wallpapers[
                                                                  index]!);

                                                      setState(() {
                                                        state.wallpapers[index]
                                                            ?.favourite = !(state
                                                                .wallpapers[
                                                                    index]
                                                                ?.favourite ??
                                                            false);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: state.wallpapers.length,
                          ),
                        );
                      }
                      return SliverToBoxAdapter(child: Container());
                    },
                  ),
                ],
              ),
              Icon(Icons.music_video),
            ],
          ), // ,
        ),
      ),
    );
  }

  SingleChildScrollView newArrivals() {
    print('test');
    return SingleChildScrollView(
      child:
          BlocBuilder<GetRecentlyAddedWallpapersCubit, GetRecentlyAddedState>(
        builder: (context, state) {
          print('asdf');
          if (state is Loaded) {
            return SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.8),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      print('adsf');
                    },
                    child: Stack(
                      children: [
                        Container(
                            width: double.infinity,
                            height: 1000,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: CachedNetworkImage(
                              height: double.infinity,
                              fit: BoxFit.cover,
                              imageUrl: state.wallpapers[index]?.imageUrl ?? '',
                              placeholder: (context, url) => const Center(
                                child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors
                                    .red, // Change this to the desired error background color
                                child: const Center(
                                  child: Icon(Icons.error, color: Colors.white),
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
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 5, right: 10, bottom: 5),
                                child: Row(children: [
                                  Column(
                                    children: [
                                      Text(
                                        state.wallpapers[index]?.category
                                                ?.name ??
                                            'Default Category',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      Text(
                                        state.wallpapers[index]!.title ??
                                            'Default Title',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: state.wallpapers[index]?.favourite ??
                                            false
                                        ? const Icon(
                                            Icons.favorite,
                                            color: Colors
                                                .red, // Customize the color if needed
                                          )
                                        : const Icon(
                                            Icons.favorite_outline,
                                          ),
                                    onPressed: () {
                                      BlocProvider.of<
                                                  ToggleFavouriteWallpaperCubit>(
                                              context)
                                          .toggle(state.wallpapers[index]!);
                                      setState(() {
                                        state.wallpapers[index]?.favourite =
                                            !(state.wallpapers[index]
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
                childCount: state.wallpapers.length,
              ),
            );
          }
          return SliverToBoxAdapter(child: Container());
        },
      ),
    );
  }
}
