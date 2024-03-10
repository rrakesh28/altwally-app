import 'package:alt__wally/core/common/widgets/wallpaper_card.dart';
import 'package:alt__wally/features/app/presentation/pages/app_screen.dart';
import 'package:alt__wally/features/category/presentation/cubit/get_categories_cubit/category_cubit.dart';
import 'package:alt__wally/features/settings/presentation/pages/settings_screen.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_state.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_state.dart';
import 'package:alt__wally/features/wallpaper/presentation/pages/category_wallpapers_screen.dart';
import 'package:alt__wally/features/wallpaper/presentation/pages/recently_added_wallpapers_details_screen.dart';
import 'package:alt__wally/features/wallpaper/presentation/pages/wall_of_the_month_screen.dart';
import 'package:alt__wally/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

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
    final recentlyAddedState =
        context.read<GetRecentlyAddedWallpapersCubit>().state;

    if (categoryState is CategoriesLoadingFailed ||
        categoryState is CategoryInitial) {
      BlocProvider.of<CategoryCubit>(context).getCategories();
    }

    if (recentlyAddedState is Initial || recentlyAddedState is Failed) {
      BlocProvider.of<GetRecentlyAddedWallpapersCubit>(context).fetchData();
    }
  }

  Future<void> _refresh() async {
    BlocProvider.of<CategoryCubit>(context).getCategories();
    BlocProvider.of<GetRecentlyAddedWallpapersCubit>(context).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
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
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AppScreen(index: 0),
              ),
            );
          },
          child: Image.asset('assets/images/name.png', height: 24),
        ),
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
        child: SafeArea(
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
                              BlocBuilder<GetRecentlyAddedWallpapersCubit,
                                  GetRecentlyAddedState>(
                                builder: (context, state) {
                                  if (state is Initial) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (state is Loaded) {
                                    final filteredWallpapers = state.wallpapers
                                        .where((wallpaper) =>
                                            wallpaper?.wallOfTheMonth == true)
                                        .toList();
                                    return Row(
                                      children: <Widget>[
                                        ...List.generate(
                                          state.wallpapers
                                              .where((wallpaper) =>
                                                  wallpaper?.wallOfTheMonth ==
                                                  true)
                                              .length,
                                          (index) {
                                            print(index);
                                            var wallpaper =
                                                filteredWallpapers[index];

                                            if (wallpaper?.wallOfTheMonth ==
                                                true) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          WallOfTheMonthScreen(
                                                        index: index,
                                                      ),
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
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  padding: EdgeInsets.zero,
                                                  child: CachedNetworkImage(
                                                    height: double.infinity,
                                                    fit: BoxFit.cover,
                                                    imageUrl: wallpaper == null
                                                        ? ''
                                                        : wallpaper.imageUrl!,
                                                    placeholder:
                                                        (context, url) {
                                                      if (wallpaper?.blurHash !=
                                                          null) {
                                                        return BlurHash(
                                                          hash: wallpaper!
                                                              .blurHash!,
                                                          imageFit:
                                                              BoxFit.cover,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      500),
                                                        );
                                                      } else {
                                                        return const Center(
                                                          child: SizedBox(
                                                              width: 20,
                                                              height: 20,
                                                              child:
                                                                  CircularProgressIndicator()),
                                                        );
                                                      }
                                                    },
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Container(
                                                      color: Colors
                                                          .red, // Change this to the desired error background color
                                                      child: const Center(
                                                        child: Icon(Icons.error,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    cacheManager:
                                                        CustomCacheManager
                                                            .instance,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Container(); // Skip if it's not the wallpaper of the month
                                            }
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
                                        color: Colors.red,
                                        child: const Center(
                                          child: Icon(Icons.error,
                                              color: Colors.white),
                                        ),
                                      ),
                                      cacheManager: CustomCacheManager.instance,
                                    ),
                                  ),
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
        ),
      ),
    );
  }
}
