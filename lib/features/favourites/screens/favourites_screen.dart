import 'package:flutter/material.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => FfavouritesScreenState();
}

class FfavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourites"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.7,
                  ),
                  children: [
                    Container(
                      height: 200,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(20), // Adjust as needed
                        image: const DecorationImage(
                          image: AssetImage("assets/images/wallpaper.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape
                                      .circle, // Make the background round
                                ),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: const Padding(
                                    padding: EdgeInsets.all(1.0),
                                    child: Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
