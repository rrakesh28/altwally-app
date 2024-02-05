import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WallpaperScreen extends StatefulWidget {
  final WallpaperEntity wallpaper;
  const WallpaperScreen({super.key, required this.wallpaper});

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: widget.wallpaper.imageUrl!, // Replace with your image URL
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Positioned(
              left: 5,
              top: 5,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {},
              )),
          Positioned(
            left: 0,
            right: 0,
            bottom: 70,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 50.0, // Adjust the width as needed
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: IconButton(
                        color: Colors.black,
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Add your button action here
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Add your button action here
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
