import 'package:alt__wally/features/app/presentation/pages/app_screen.dart';
import 'package:alt__wally/features/category/presentation/cubit/get_categories_cubit/category_cubit.dart';
import 'package:alt__wally/features/settings/presentation/pages/settings_screen.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_state.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_state.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/toggle_favourite/toggle_favourite_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/wall_of_the_month/wall_of_the_month_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/wall_of_the_month/wall_of_the_month_state.dart';
import 'package:alt__wally/features/wallpaper/presentation/pages/category_wallpapers_screen.dart';
import 'package:alt__wally/features/wallpaper/presentation/pages/recently_added_wallpapers_details_screen.dart';
import 'package:alt__wally/features/wallpaper/presentation/pages/wall_of_the_month_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final categoryState = context.read<CategoryCubit>().state;
    final wallOfTheMonthState = context.read<WallOfTheMonthCubit>().state;
    final recentlyAddedState =
        context.read<GetRecentlyAddedWallpapersCubit>().state;

    if (categoryState is CategoriesLoadingFailed ||
        categoryState is CategoryInitial) {
      BlocProvider.of<CategoryCubit>(context).getCategories();
    }

    if (wallOfTheMonthState is WallOfTheMonthInitial ||
        wallOfTheMonthState is WallOfTheMonthLoadingFailed) {
      BlocProvider.of<WallOfTheMonthCubit>(context).fetchData();
    }

    if (recentlyAddedState is Initial || wallOfTheMonthState is Failed) {
      BlocProvider.of<GetRecentlyAddedWallpapersCubit>(context).fetchData();
    }
  }

  Future<void> _refresh() async {
    BlocProvider.of<CategoryCubit>(context).getCategories();
    BlocProvider.of<WallOfTheMonthCubit>(context).fetchData();
    BlocProvider.of<GetRecentlyAddedWallpapersCubit>(context).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, SettingsScreen.routeName);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              'assets/images/menu.png',
              height: 20,
            ),
          ),
        ),
        title: Image.asset('assets/images/name.png', height: 24),
        centerTitle: true,
        actions: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppScreen(index: 3),
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.network(
                        state.user.profileImageUrl!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Wall of the month",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 160,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            BlocBuilder<WallOfTheMonthCubit,
                                WallOfTheMonthState>(
                              builder: (context, state) {
                                if (state is WallOfTheMonthLoadingFailed) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (state is WallOfTheMonthLoaded) {
                                  return Row(
                                    children: <Widget>[
                                      ...List.generate(
                                        state.wallpapers.length,
                                        (index) {
                                          var wallpaper =
                                              state.wallpapers[index];

                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      WallOfTheMonthScreen(
                                                          index: index),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: 130,
                                              height: 160,
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding: EdgeInsets.zero,
                                              child: CachedNetworkImage(
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                                imageUrl: wallpaper == null
                                                    ? ''
                                                    : wallpaper.imageUrl!,
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child: SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
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
                                      ),
                                      const SizedBox(width: 20),
                                    ],
                                  );
                                } else {
                                  // Handle other states if needed
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(
                child: Text(
                  'Collections',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
              BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  if (state is CategoriesLoaded) {
                    return SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 1.5,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CategoryWallpapersScreen(
                                          category: state.categories[index]),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: CachedNetworkImage(
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      imageUrl: state
                                          .categories[index].bannerImageUrl!,
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
                                    )),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      state.categories[index].name!,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ],
                            ),
                          );
                        },
                        childCount: state.categories.length,
                      ),
                    );
                  }
                  return SliverToBoxAdapter(child: Container());
                },
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),
              const SliverToBoxAdapter(
                child: Text(
                  'Recently Added',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
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
                              childAspectRatio: 0.6),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return GestureDetector(
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
                            child: Stack(
                              children: [
                                Container(
                                    width: double.infinity,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: CachedNetworkImage(
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          state.wallpapers[index]?.imageUrl ??
                                              '',
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              // Added Expanded widget
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    state.wallpapers[index]
                                                            ?.category?.name ??
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
                                                    overflow: TextOverflow
                                                        .ellipsis, // Added overflow property
                                                  ),
                                                ],
                                              ),
                                            ),
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
                                                      color: Colors.white,
                                                    ),
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
                                          ],
                                        ),
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
            ],
          ),
        ),
      ),
    );
  }
}
