import 'package:alt__wally/features/settings/presentation/pages/settings_screen.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/auth/auth_state.dart';
import 'package:alt__wally/features/user/presentation/cubit/profile/profile_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/profile/profile_state.dart';
import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
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

    final profileState = context.read<ProfileCubit>().state;
    if (authState is Authenticated) {
      if (profileState is ProfileLoaded) {
        wallpapersData = profileState.wallpapers;
      } else {
        BlocProvider.of<ProfileCubit>(context).fetchData(authState.uid);
      }
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
                BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
                  if (state is Authenticated) {
                    return CachedNetworkImage(
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: state.user.bannerImageUrl!,
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
                    );
                    // return Image.network(state.user.bannerImageUrl!,
                    //     height: 200, width: double.infinity, fit: BoxFit.cover);
                  }
                  return Container();
                }),
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
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 4.0,
                                          ),
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
                                child: BlocConsumer<ProfileCubit, ProfileState>(
                                    listener: (context, state) {},
                                    builder: (context, state) {
                                      if (state is ProfileInitial) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (state is ProfileLoaded) {
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
                                                        ProfileWallpapersScreen(
                                                            index: index),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
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
                                                        child:
                                                            CircularProgressIndicator()),
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
                                        );
                                      } else {
                                        return Container();
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
                shape: CircleBorder(),
                padding: EdgeInsets.all(14),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
