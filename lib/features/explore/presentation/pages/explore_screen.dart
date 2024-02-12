import 'package:alt__wally/features/category/presentation/pages/category_wallpapers_screen.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/wall_of_the_month/wall_of_the_month_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/wall_of_the_month/wall_of_the_month_state.dart';
import 'package:alt__wally/features/wallpaper/presentation/pages/wall_of_the_month_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alt__wally/features/explore/presentation/cubit/category/category_cubit.dart';

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
    BlocProvider.of<CategoryCubit>(context).getCategories();
    BlocProvider.of<WallOfTheMonthCubit>(context).fetchData();
  }

  String getGreeting() =>
      'Good ${DateTime.now().hour < 12 ? 'Morning' : DateTime.now().hour < 18 ? 'Afternoon' : 'Evening'}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/name.png',
                        height: 25,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Wall of the month",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      height: 200,
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
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
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
                      height: 10,
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
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
                                      CategoryWallpapersListScreen(
                                          category: state.categories[index]),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
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
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
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
            ],
          ),
        ),
      ),
    );
  }
}
