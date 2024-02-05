import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/toggle_favourite/toggle_favourite_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/pages/wallpaper_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WallpaperCarousel extends StatefulWidget {
  final List<WallpaperEntity?> wallpapers;
  final String title;
  final int index;
  const WallpaperCarousel(
      {super.key,
      required this.title,
      required this.index,
      required this.wallpapers});

  @override
  State<WallpaperCarousel> createState() => _WallpaperCarouselState();
}

class _WallpaperCarouselState extends State<WallpaperCarousel> {
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _current = widget.index;
  }

  List<Widget> generateImageTitles() {
    return widget.wallpapers.map((element) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WallpaperScreen(wallpaper: element!),
            ),
          );
        },
        child: ClipRRect(
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
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                widget.wallpapers[_current]?.title ?? 'Untitled',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  BlocProvider.of<ToggleFavouriteWallpaperCubit>(context)
                      .toggle(widget.wallpapers[_current]!);
                  setState(() {
                    widget.wallpapers[_current]?.favourite =
                        !(widget.wallpapers[_current]?.favourite ?? false);
                  });
                },
                icon: widget.wallpapers[_current]?.favourite ?? false
                    ? const Icon(
                        Icons.favorite,
                        size: 30,
                        color: Colors.red, // Customize the color if needed
                      )
                    : const Icon(
                        Icons.favorite_outline,
                        size: 30,
                      ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "Designed By: ${widget.wallpapers[_current]?.user?.name ?? 'Guest'}",
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
                "Size: ${widget.wallpapers[_current]?.size ?? 'N/A'}",
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "Category : ${widget.wallpapers[_current]?.category?.name ?? 'N/A'}",
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
                "Ratio: ${widget.wallpapers[_current]?.width ?? 'N/A'} x ${widget.wallpapers[_current]?.height}",
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
