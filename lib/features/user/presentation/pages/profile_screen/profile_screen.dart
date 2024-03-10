import 'package:alt__wally/core/common/widgets/wallpaper_card.dart';
import 'package:alt__wally/features/settings/presentation/pages/settings_screen.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_state.dart';
import 'package:alt__wally/features/user/presentation/cubit/profile/profile_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/profile/profile_state.dart';
import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/recently_added/recently_added_state.dart';
import 'package:alt__wally/features/wallpaper/presentation/pages/add_wallpaper_screen.dart';
import 'package:alt__wally/features/wallpaper/presentation/pages/profile_wallpapers_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = "/profile-screen";
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<WallpaperEntity?> wallpapersData = [];

  String? userId;

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthCubit>().state;

    final profileState = context.read<ProfileCubit>().state;
    if (authState is Authenticated) {
      if (profileState is ProfileLoaded) {
        wallpapersData = profileState.wallpapers;
      } else {
        BlocProvider.of<ProfileCubit>(context).fetchData(authState.uid);
      }
    }
  }

  Future<void> _refresh() async {
    final authState = context.read<AuthCubit>().state;

    if (authState is Authenticated) {
      BlocProvider.of<ProfileCubit>(context).fetchData(authState.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: SizedBox(
            height: double.infinity,
            child: Stack(
              children: [
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is Authenticated) {
                      userId = state.user.uid!;

                      return CachedNetworkImage(
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: state.user.bannerImageUrl!,
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.red,
                          child: const Center(
                            child: Icon(Icons.error, color: Colors.white),
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
                Positioned(
                    top: 120,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: screenHeight - 220,
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(children: [
                            Row(
                              children: [
                                BlocBuilder<AuthCubit, AuthState>(
                                  builder: (context, state) {
                                    if (state is Authenticated) {
                                      return Container(
                                        height: 75,
                                        width: 75,
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
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    BlocBuilder<AuthCubit, AuthState>(
                                      builder: (context, state) {
                                        if (state is Authenticated) {
                                          return Text(
                                            state.user.name!,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          );
                                        }
                                        return const Text("Guest",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                            ));
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SettingsScreen()),
                                  );
                                },
                                icon: const Icon(
                                  Icons.settings_outlined,
                                  size: 28,
                                )),
                          ]),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: BlocConsumer<
                                        GetRecentlyAddedWallpapersCubit,
                                        GetRecentlyAddedState>(
                                    listener: (context, state) {},
                                    builder: (context, state) {
                                      if (state is Initial) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (state is Loaded) {
                                        if (state.wallpapers
                                            .where((wallpaper) =>
                                                wallpaper?.favourite == true)
                                            .isEmpty) {
                                          return Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/images/empty-add-wallpapers.png',
                                                  height: 70,
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20.0, right: 20.0),
                                                  child: Text(
                                                    "Hey! Let's make this space pop with your favorite walls!",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 0.3),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
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
                                          itemCount: state.wallpapers
                                              .where((wallpaper) =>
                                                  wallpaper?.userId == userId)
                                              .length,
                                          itemBuilder: (context, index) {
                                            final filteredWallpapers = state
                                                .wallpapers
                                                .where((wallpaper) =>
                                                    wallpaper?.userId == userId)
                                                .toList();

                                            return WallpaperItem(
                                              wallpaper:
                                                  filteredWallpapers[index]!,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProfileWallpapersScreen(
                                                      index: index,
                                                      userId: userId!,
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      } else {
                                        return const Center(
                                          child: Text('asdf'),
                                        );
                                      }
                                    })),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AddWallpaperScreen.routeName);
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(14),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
