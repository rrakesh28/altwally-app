import 'package:alt__wally/core/common/widgets/wallpaper_card.dart';
import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_state.dart';
import 'package:alt__wally/features/wallpaper/presentation/pages/popular_wallpapers_details_screen.dart';
import 'package:alt__wally/features/wallpaper/presentation/pages/recently_added_wallpapers_details_screen.dart';
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

    final recentlyAddedState =
        context.read<GetRecentlyAddedWallpapersCubit>().state;

    if (recentlyAddedState is Initial || recentlyAddedState is Failed) {
      BlocProvider.of<GetRecentlyAddedWallpapersCubit>(context).fetchData();
    }
  }

  Future<void> _refresh() async {
    BlocProvider.of<GetRecentlyAddedWallpapersCubit>(context).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Explore',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: true,
            bottom: const TabBar(
              indicatorColor: Colors.black,
              dividerHeight: 0,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  child: Text(
                    'New Arrivals',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    'Popular',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ), //
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: CustomScrollView(
                  slivers: [
                    BlocBuilder<GetRecentlyAddedWallpapersCubit,
                        GetRecentlyAddedState>(
                      builder: (context, state) {
                        if (state is Loaded) {
                          return SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 0.6,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return WallpaperItem(
                                  wallpaper: state.wallpapers[index]!,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RecentlyAddedWallpapersDetailsScreen(
                                                index: index),
                                      ),
                                    );
                                  },
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
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: CustomScrollView(
                  slivers: [
                    BlocBuilder<GetRecentlyAddedWallpapersCubit,
                        GetRecentlyAddedState>(
                      builder: (context, state) {
                        if (state is Loaded) {
                          List<WallpaperEntity> shuffledWallpapers =
                              List.from(state.wallpapers)..shuffle();

                          return SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 0.6,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return WallpaperItem(
                                  wallpaper: shuffledWallpapers[index],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PopularWallpapersDetailsScreen(
                                          index: index,
                                          wallpapers: shuffledWallpapers,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              childCount: shuffledWallpapers.length,
                            ),
                          );
                        }
                        return SliverToBoxAdapter(child: Container());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
