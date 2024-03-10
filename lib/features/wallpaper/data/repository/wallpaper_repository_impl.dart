import 'dart:convert';
import 'dart:math';

import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/category/data/model/category_model.dart';
import 'package:alt__wally/features/wallpaper/data/model/wallpaper_model.dart';
import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:alt__wally/features/wallpaper/domain/repository/wallpaper_repository.dart';
import 'package:blurhash_ffi/blurhash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WallpaperRepositoryImpl implements WallpaperRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  WallpaperRepositoryImpl({required this.firestore, required this.auth});

  @override
  Future<Resource> addWallpaper(WallpaperEntity wallpaper) async {
    try {
      final wallpapersCollection = firestore.collection("wallpapers");

      final wallpaperId = wallpapersCollection.doc().id;

      final url = Uri.parse("https://api.cloudinary.com/v1_1/dklkwu5fw/upload");

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'bcdwnuxb'
        ..files.add(
            await http.MultipartFile.fromPath('file', wallpaper.image!.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responeData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responeData);
        final jsonMap = jsonDecode(responseString);

        final imageProvider = NetworkImage(jsonMap['secure_url']);
        final String blurHash = await BlurhashFFI.encode(imageProvider);

        final newWallpapers = WallpaperModel(
                id: wallpaperId,
                userId: auth.currentUser!.uid,
                categoryId: wallpaper.categoryId,
                title: wallpaper.title,
                imageUrl: jsonMap['secure_url'],
                blurHash: blurHash,
                size: wallpaper.size,
                height: wallpaper.height,
                width: wallpaper.width,
                createdAt: Timestamp.fromDate(DateTime.now()),
                updatedAt: Timestamp.fromDate(DateTime.now()),
                likes: 0,
                views: 0,
                downloads: 0)
            .toDocument();

        await wallpapersCollection.doc(wallpaperId).set(newWallpapers);

        return Resource.success(data: '');
      } else {
        return Resource.failure(errorMessage: 'Failed to upload image');
      }
    } catch (e) {
      return Resource.failure(errorMessage: 'Something went wrong');
    }
  }

  @override
  Future<Resource> getWallpapersByUserId(userId) async {
    try {
      final wallpapersCollection = firestore.collection("wallpapers");
      final querySnapshot =
          await wallpapersCollection.where("user_id", isEqualTo: userId).get();

      List<WallpaperModel> wallpapers = [];

      QuerySnapshot favoritesSnapshot = await firestore
          .collection('user_favourites')
          .where('user_id', isEqualTo: auth.currentUser!.uid)
          .get();

      List<String> favoriteWallpaperIds = favoritesSnapshot.docs
          .map((doc) =>
              (doc.data() as Map<String, dynamic>)['wallpaper_id'] as String)
          .toList();

      for (var document in querySnapshot.docs) {
        var wallpaperData = document.data() as Map<String, dynamic>;

        var wallpaper = WallpaperModel(
          id: document.id,
          userId: wallpaperData['user_id'],
          categoryId: wallpaperData['category_id'],
          title: wallpaperData['title'],
          imageUrl: wallpaperData['image_url'],
          size: wallpaperData['size'],
          height: wallpaperData['height'],
          width: wallpaperData['width'],
          likes: wallpaperData['likes'],
          downloads: wallpaperData['downloads'],
          views: wallpaperData['views'],
        );

        wallpaper.favourite = favoriteWallpaperIds.contains(wallpaper.id);
        wallpapers.add(wallpaper);
      }
      return Resource.success(data: wallpapers);
    } catch (e) {
      print(e);
      return Resource.failure(errorMessage: "Something went wrong");
    }
  }

  @override
  Future<Resource> getWallOfTheMonth() async {
    try {
      final wallpapersCollection = firestore.collection("wallpapers");
      final querySnapshot = await wallpapersCollection
          .where("wall_of_the_month", isEqualTo: true)
          .get();

      List<WallpaperModel> wallpapers = [];

      QuerySnapshot favoritesSnapshot = await firestore
          .collection('user_favourites')
          .where('user_id', isEqualTo: auth.currentUser!.uid)
          .get();

      List<String> favoriteWallpaperIds = favoritesSnapshot.docs
          .map((doc) =>
              (doc.data() as Map<String, dynamic>)['wallpaper_id'] as String)
          .toList();

      for (var document in querySnapshot.docs) {
        var wallpaperData = document.data() as Map<String, dynamic>;

        var wallpaper = WallpaperModel(
          id: document.id,
          userId: wallpaperData['user_id'],
          categoryId: wallpaperData['category_id'],
          title: wallpaperData['title'],
          imageUrl: wallpaperData['image_url'],
          size: wallpaperData['size'],
          height: wallpaperData['height'],
          width: wallpaperData['width'],
        );

        wallpaper.favourite = favoriteWallpaperIds.contains(wallpaper.id);

        wallpapers.add(wallpaper);

        // // Update likes, views, and downloads counts
        // await wallpapersCollection
        //     .doc(document.id)
        //     .update({'views': wallpaperData['views'] + 1});
        // await wallpapersCollection
        //     .doc(document.id)
        //     .update({'likes': wallpaperData['likes'] + 1});
        // await wallpapersCollection
        //     .doc(document.id)
        //     .update({'downloads': wallpaperData['downloads'] + 1});

        wallpaper.favourite = favoriteWallpaperIds.contains(wallpaper.id);
      }
      return Resource.success(data: wallpapers);
    } catch (e) {
      return Resource.failure(errorMessage: "Something went wrong");
    }
  }

  @override
  Future<Resource> toggleFavouriteWallpaper(WallpaperEntity wallpaper) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('user_favourites')
          .where('user_id', isEqualTo: auth.currentUser!.uid)
          .where('wallpaper_id', isEqualTo: wallpaper.id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      } else {
        await FirebaseFirestore.instance.collection('user_favourites').add({
          'user_id': auth.currentUser!.uid,
          'wallpaper_id': wallpaper.id,
        });
      }
      return Resource.success(data: '');
    } catch (e) {
      return Resource.failure(errorMessage: 'Something went wrong');
    }
  }

  @override
  Future<Resource> getFavouriteWallpapers() async {
    try {
      QuerySnapshot userFavouritesSnapshot = await FirebaseFirestore.instance
          .collection('user_favourites')
          .where('user_id', isEqualTo: auth.currentUser!.uid)
          .get();

      List<String> wallpaperIds = userFavouritesSnapshot.docs
          .map((doc) =>
              (doc.data() as Map<String, dynamic>)['wallpaper_id'] as String)
          .toList();

      QuerySnapshot wallpapersSnapshot = await FirebaseFirestore.instance
          .collection('wallpapers')
          .where(FieldPath.documentId, whereIn: wallpaperIds)
          .get();

      List<WallpaperModel> wallpapers = [];

      QuerySnapshot categoriesSnapshot =
          await firestore.collection("categories").get();

      Map<String, dynamic> categoriesMap = {};
      categoriesSnapshot.docs.forEach((categoryDoc) {
        categoriesMap[categoryDoc.id] = categoryDoc.data();
      });

      for (var document in wallpapersSnapshot.docs) {
        var wallpaperData = document.data() as Map<String, dynamic>;

        var categoryData = categoriesMap[wallpaperData['category_id']];

        var wallpaper = WallpaperModel(
          id: document.id,
          userId: wallpaperData['user_id'],
          categoryId: wallpaperData['category_id'],
          title: wallpaperData['title'],
          imageUrl: wallpaperData['image_url'],
          size: wallpaperData['size'],
          height: wallpaperData['height'],
          width: wallpaperData['width'],
          category: CategoryModel(
            id: wallpaperData['category_id'],
            name: categoryData?['name'],
          ),
        );

        if (!wallpaperData['blur_hash']) {
          final imageProvider = NetworkImage(wallpaperData['image_url']);
          wallpaper.blurHash = await BlurhashFFI.encode(imageProvider);
        }

        wallpaper.favourite = true;

        wallpapers.add(wallpaper);
      }

      return Resource.success(data: wallpapers);
    } catch (e) {
      return Resource.failure(errorMessage: 'Something went wrong');
    }
  }

  @override
  Future<Resource> getWallpapersByCategory(categoryId) async {
    try {
      final wallpapersCollection = firestore.collection("wallpapers");
      final querySnapshot = await wallpapersCollection
          .where("category_id", isEqualTo: categoryId)
          .get();

      List<WallpaperModel> wallpapers = [];

      QuerySnapshot favoritesSnapshot = await firestore
          .collection('user_favourites')
          .where('user_id', isEqualTo: auth.currentUser!.uid)
          .get();

      List<String> favoriteWallpaperIds = favoritesSnapshot.docs
          .map((doc) =>
              (doc.data() as Map<String, dynamic>)['wallpaper_id'] as String)
          .toList();

      var categorySnapshot =
          await firestore.collection("categories").doc(categoryId).get();
      var categoryData = categorySnapshot.data();

      for (var document in querySnapshot.docs) {
        var wallpaperData = document.data();

        var wallpaper = WallpaperModel(
          id: document.id,
          userId: wallpaperData['user_id'],
          categoryId: wallpaperData['category_id'],
          title: wallpaperData['title'],
          imageUrl: wallpaperData['image_url'],
          size: wallpaperData['size'],
          height: wallpaperData['height'],
          width: wallpaperData['width'],
          category: CategoryModel(
            id: wallpaperData['category_id'],
            name: categoryData?['name'],
          ),
        );

        wallpaper.favourite = favoriteWallpaperIds.contains(wallpaper.id);

        wallpapers.add(wallpaper);
      }

      return Resource.success(data: wallpapers);
    } catch (e) {
      print(e);
      return Resource.failure(errorMessage: "Something went wrong");
    }
  }

  @override
  Future<Resource> getRecentlyAddedWallpapers() async {
    try {
      final wallpapersCollection = firestore.collection("wallpapers");
      final querySnapshot = await wallpapersCollection
          .orderBy('created_at', descending: true)
          .get();
      List<WallpaperModel> wallpapers = [];

      QuerySnapshot favoritesSnapshot = await firestore
          .collection('user_favourites')
          .where('user_id', isEqualTo: auth.currentUser!.uid)
          .get();

      List<String> favoriteWallpaperIds = favoritesSnapshot.docs
          .map((doc) =>
              (doc.data() as Map<String, dynamic>)['wallpaper_id'] as String)
          .toList();

      for (var document in querySnapshot.docs) {
        var wallpaperData = document.data();

        var categorySnapshot = await firestore
            .collection("categories")
            .doc(wallpaperData['category_id'])
            .get();
        var categoryData = categorySnapshot.data();

        // int desiredQuality = 30;

        // String lowerQualityUrl = wallpaperData['image_url']
        //     .replaceFirst('/upload/', '/upload/q_$desiredQuality/');

        int desiredWidth = 800;
        int desiredHeight = 1000;

        String lowerQualityUrl = wallpaperData['image_url'].replaceFirst(
            '/upload/', '/upload/w_$desiredWidth,h_$desiredHeight,c_fill/');

        var wallpaper = WallpaperModel(
          id: document.id,
          userId: wallpaperData['user_id'],
          categoryId: wallpaperData['category_id'],
          blurHash: wallpaperData['blur_hash'],
          category: CategoryModel(
            id: wallpaperData['category_id'],
            name: categoryData?['name'],
          ),
          title: wallpaperData['title'],
          imageUrl: lowerQualityUrl,
          size: wallpaperData['size'],
          height: wallpaperData['height'],
          width: wallpaperData['width'],
          wallOfTheMonth: wallpaperData['wall_of_the_month'],
        );

        // if (wallpaperData['blur_hash'] == null) {
        //   print(wallpaperData);
        //   final imageProvider = NetworkImage(wallpaperData['image_url']);
        //   final blurHash = await BlurhashFFI.encode(imageProvider);
        //   print(blurHash);
        //   wallpaper.blurHash = blurHash;
        //   await wallpapersCollection
        //       .doc(document.id)
        //       .update({"blur_hash": blurHash});
        // }
        wallpaper.favourite = favoriteWallpaperIds.contains(wallpaper.id);
        final int views = Random().nextInt(4001) + 1000;
        final int likes = Random().nextInt(3001) + 1000;
        final int downloads = Random().nextInt(1001) + 1000;

        wallpaper.views = views;
        wallpaper.likes = likes;
        wallpaper.downloads = downloads;

        wallpapers.add(wallpaper);
      }
      return Resource.success(data: wallpapers);
    } catch (e) {
      return Resource.failure(errorMessage: "Something went wrong");
    }
  }

  @override
  Future<Resource> getPopularWallpapers() async {
    try {
      final wallpapersCollection = firestore.collection("wallpapers");
      final querySnapshot = await wallpapersCollection
          .orderBy('created_at', descending: true)
          .get();

      List<DocumentSnapshot> documents = querySnapshot.docs.toList();
      documents.shuffle();

      List<WallpaperModel> wallpapers = [];

      QuerySnapshot categoriesSnapshot =
          await firestore.collection("categories").get();

      Map<String, dynamic> categoriesMap = {};
      categoriesSnapshot.docs.forEach((categoryDoc) {
        categoriesMap[categoryDoc.id] = categoryDoc.data();
      });

      QuerySnapshot favoritesSnapshot = await firestore
          .collection('user_favourites')
          .where('user_id', isEqualTo: auth.currentUser!.uid)
          .get();

      List<String> favoriteWallpaperIds = favoritesSnapshot.docs
          .map((doc) =>
              (doc.data() as Map<String, dynamic>)['wallpaper_id'] as String)
          .toList();

      for (var document in documents) {
        var wallpaperData = document.data() as Map<String, dynamic>;

        var categoryData = categoriesMap[wallpaperData['category_id']];

        var wallpaper = WallpaperModel(
          id: document.id,
          userId: wallpaperData['user_id'],
          categoryId: wallpaperData['category_id'],
          category: CategoryModel(
            id: wallpaperData['category_id'],
            name: categoryData?['name'],
          ),
          title: wallpaperData['title'],
          imageUrl: wallpaperData['image_url'],
          size: wallpaperData['size'],
          height: wallpaperData['height'],
          width: wallpaperData['width'],
        );

        wallpaper.favourite = favoriteWallpaperIds.contains(wallpaper.id);

        wallpapers.add(wallpaper);
      }
      return Resource.success(data: wallpapers);
    } catch (e) {
      return Resource.failure(errorMessage: "Something went wrong");
    }
  }
}
