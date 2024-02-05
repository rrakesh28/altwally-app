import 'package:alt__wally/core/common/widgets/wallpaper_carousel.dart';
import 'package:alt__wally/features/user/presentation/cubit/profile/profile_cubit.dart';
import 'package:alt__wally/features/user/presentation/cubit/profile/profile_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileWallpapersScreen extends StatefulWidget {
  static const String routeName = '/wallpaper-screen';

  final int index;

  const ProfileWallpapersScreen({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<ProfileWallpapersScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ProfileWallpapersScreen> {
  int _current = 0;

  List<Map<String, dynamic>> wallpapers = [
    {
      "id": 1,
      "category": "Minimal",
      "image": "assets/images/wallpaper.png",
      "title": "Night Mountain View",
      "designed_by": "Sai Teja",
      "uploaded_date": "120 days ago",
      "size": "136mb",
      "ratio": "1400 x 3100",
      "views": 1230
    },
    {
      "id": 2,
      "category": "Minimal",
      "image": "assets/images/wallpaper.png",
      "title": "Wall Paper 1",
      "designed_by": "Test",
      "uploaded_date": "110 days ago",
      "size": "100mb",
      "ratio": "1200 x 3100",
      "views": 1230
    },
  ];

  @override
  void initState() {
    super.initState();
    _current = widget.index;
  }

  String getUploadedTime(createdAt) {
    DateTime givenDate = createdAt.toDate();
    DateTime now = DateTime.now();
    Duration timeDifference = now.difference(givenDate);

    String formattedTimeDifference = formatTimeDifference(timeDifference);
    return formattedTimeDifference;
  }

  String formatTimeDifference(Duration duration) {
    return '1';
    if (duration.inSeconds < 60) return '${duration.inSeconds} seconds ago';
    if (duration.inMinutes < 60) return '${duration.inMinutes} minutes ago';
    if (duration.inHours < 24) return '${duration.inHours} hours ago';
    if (duration.inDays < 7) return '${duration.inDays} days ago';
    if (duration.inDays < 30)
      return '${(duration.inDays / 7).floor()} weeks ago';
    return '${(duration.inDays / 30).floor()} months ago';
  }

  final List data = [
    {
      "id": 1,
      "category": "Minimal",
      "image": "assets/images/wallpaper.png",
      "title": "Night Mountain View",
      "designed_by": "Sai Teja",
      "uploaded_date": "120 days ago",
      "size": "136mb",
      "ratio": "1400 x 3100",
      "views": 1230
    },
    {
      "id": 2,
      "category": "Minimal",
      "image": "assets/images/wallpaper.png",
      "title": "Wall Paper 1",
      "designed_by": "Test",
      "uploaded_date": "110 days ago",
      "size": "100mb",
      "ratio": "1200 x 3100",
      "views": 1230
    },
  ];

  List<Widget> generateImageTitles(context) {
    final state = context.read<ProfileCubit>().state;
    return state.wallpapers.map((element) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.network(
          element.imageUrl,
          fit: BoxFit.cover,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProfileLoaded) {
          return WallpaperCarousel(
              title: state.wallpapers[_current]!.category!.name!,
              index: widget.index,
              wallpapers: state.wallpapers);
        } else if (state is ProfileLoadingFailed) {
          return Text('Failed to load wallpapers');
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildWallpapersUI(ProfileLoaded state) {
    List<Widget> generateImageTitles() {
      return state.wallpapers.map((element) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: CachedNetworkImage(
            height: double.infinity,
            fit: BoxFit.cover,
            imageUrl: element == null ? '' : element.imageUrl!,
            placeholder: (context, url) => const Center(
              child: SizedBox(
                  height: 20, width: 20, child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors
                  .red, // Change this to the desired error background color
              child: const Center(
                child: Icon(Icons.error, color: Colors.white),
              ),
            ),
          ),
        );
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(state.wallpapers[_current]!.category!.name!),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          Stack(
            children: [
              const SizedBox(
                height: 40,
              ),
              CarouselSlider(
                  items: generateImageTitles(),
                  options: CarouselOptions(
                      enlargeCenterPage: true,
                      aspectRatio: 14 / 16,
                      enableInfiniteScroll: false,
                      initialPage: _current,
                      viewportFraction: 0.7,
                      onPageChanged: (index, other) {
                        setState(() {
                          _current = index;
                        });
                      }))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                state.wallpapers[_current]?.title ?? 'Untitled',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite_outline,
                    size: 30,
                  ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "Designed By: ${state.wallpapers[_current]?.user?.name ?? 'Guest'}",
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
              ),
              const SizedBox(
                width: 2,
              ),
              const Text(
                "|",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 2,
              ),
              Text(
                "Updated Date: 'N/A'",
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
              ),
              const SizedBox(
                width: 2,
              ),
              const Text(
                "|",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 2,
              ),
              Text(
                "Size: ${state.wallpapers[_current]?.size ?? 'N/A'}",
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "Category : ${state.wallpapers[_current]?.category?.name ?? 'N/A'}",
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
              ),
              const SizedBox(
                width: 2,
              ),
              const Text(
                "|",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 2,
              ),
              Text(
                "Ratio: ${state.wallpapers[_current]?.width ?? 'N/A'} x ${state.wallpapers[_current]?.height}",
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
              ),
              const SizedBox(
                width: 2,
              ),
              const Text(
                "|",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 2,
              ),
              Text(
                "Views : ${'N/A'}",
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Row(
                children: [
                  GestureDetector(
                    child: const Column(children: [
                      Icon(Icons.phone_android),
                      Text(
                        'Set as',
                        style: TextStyle(fontSize: 10),
                      )
                    ]),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    child: const Column(children: [
                      Icon(Icons.download_for_offline_outlined),
                      Text(
                        'Save',
                        style: TextStyle(fontSize: 10),
                      )
                    ]),
                  )
                ],
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add_comment_outlined))
            ],
          ),
        ]),
      ),
    );
  }
}
