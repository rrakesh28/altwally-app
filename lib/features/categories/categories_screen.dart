import 'package:alt__wally/features/wallpaper/screens/wallpaper_screen.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  static const String routeName = '/category-screen';

  const CategoryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minimal'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.6,
                ),
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, WallpaperScreen.routeName);
                    },
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              20) // Adjust the radius as needed
                          ),
                      padding: EdgeInsets.zero,
                      child: Image.asset('assets/images/wallpaper.png',
                          fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            20) // Adjust the radius as needed
                        ),
                    padding: EdgeInsets.zero,
                    child: Image.asset('assets/images/wallpaper.png',
                        fit: BoxFit.cover),
                  ),
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            20) // Adjust the radius as needed
                        ),
                    padding: EdgeInsets.zero,
                    child: Image.asset('assets/images/wallpaper.png',
                        fit: BoxFit.cover),
                  ),
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            20) // Adjust the radius as needed
                        ),
                    padding: EdgeInsets.zero,
                    child: Image.asset('assets/images/wallpaper.png',
                        fit: BoxFit.cover),
                  ),
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.zero,
                    child: Image.asset('assets/images/wallpaper.png',
                        fit: BoxFit.cover),
                  ),
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.zero,
                    child: Image.asset('assets/images/wallpaper.png',
                        fit: BoxFit.cover),
                  ),
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.zero,
                    child: Image.asset('assets/images/wallpaper.png',
                        fit: BoxFit.cover),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.menu),
                ),
                Expanded(
                    child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0x19000000),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20),
                    hintText: 'Hello. Looking for something ?',
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
