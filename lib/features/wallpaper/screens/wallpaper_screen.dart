import 'package:alt__wally/common/services/user_service.dart';
import 'package:alt__wally/common/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class WallpaperScreen extends StatefulWidget {
  static const String routeName = '/wallpaper-screen';

  final String id;
  final String type;

  const WallpaperScreen({
    Key? key,
    required this.id,
    required this.type,
  }) : super(key: key);

  @override
  State<WallpaperScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<WallpaperScreen> {
  int _current = 0;

  List<Map<String, dynamic>> wallpapers = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    List<Map<String, dynamic>> wallpapersFetched;
    try {
      if (widget.type == 'cagegory') {
        // Add specific logic for the 'profile' type if needed
      } else {
        User? authenticatedUser = UserService().authUser;

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('wallpapers')
            .where('userId', isEqualTo: authenticatedUser?.uid)
            .get();

        wallpapersFetched = await Future.wait(
          querySnapshot.docs.map((DocumentSnapshot documentSnapshot) async {
            Map<String, dynamic> data =
                documentSnapshot.data() as Map<String, dynamic>;

            List<DocumentSnapshot> results = await Future.wait([
              FirebaseFirestore.instance
                  .collection('categories')
                  .doc(data['category'])
                  .get(),
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(data['userId'])
                  .get(),
            ]);

            Map<String, dynamic>? categoryData =
                results[0].data() as Map<String, dynamic>?;

            Map<String, dynamic>? userData =
                results[1].data() as Map<String, dynamic>?;

            data['id'] = documentSnapshot.id;
            data['category'] = categoryData;
            data['user'] = userData;

            return data;
          }),
        );
        print(wallpapersFetched);
        setState(() {
          wallpapers = wallpapersFetched;
        });
      }
    } catch (e) {
      print(e);
      showToast(message: "Error: $e");
    }
  }

  String getUploadedTime(Timestamp createdAt) {
    DateTime givenDate = createdAt.toDate();
    DateTime now = DateTime.now();
    Duration timeDifference = now.difference(givenDate);

    String formattedTimeDifference = formatTimeDifference(timeDifference);
    return formattedTimeDifference;
  }

  String formatTimeDifference(Duration duration) {
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

  List<Widget> generateImageTitles() {
    return wallpapers.map((element) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.network(
          element['image'],
          fit: BoxFit.cover,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (wallpapers.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    ;
    return Scaffold(
      appBar: AppBar(
        title: Text(wallpapers[_current]["category"]['name']),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.white,
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
                wallpapers[_current]['name'],
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
                "Designed By: ${wallpapers[_current]['user']['name'] ?? 'N/A'}",
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
                "Updated Date: ${getUploadedTime(wallpapers[_current]['createdAt'] ?? 'N/A')}",
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
                "Size: ${wallpapers[_current]['updatedAt'] ?? 'N/A'}",
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "Category : ${wallpapers[_current]['category']['name'] ?? 'N/A'}",
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
                "Ratio: ${wallpapers[_current]['aspectRatio'] ?? 'N/A'}",
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
                "Views : ${wallpapers[_current]['uploadedAt'] ?? 'N/A'}",
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
