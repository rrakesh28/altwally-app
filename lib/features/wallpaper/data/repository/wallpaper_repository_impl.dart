import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/category/data/datasources/local/cateogry_local_data_source.dart';
import 'package:alt__wally/features/wallpaper/data/datasource/local/wallpaper_local_data_source.dart';
import 'package:alt__wally/features/wallpaper/data/datasource/remote/wallpaper_remote_data_source.dart';
import 'package:alt__wally/features/wallpaper/data/model/wallpaper_model.dart';
import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:alt__wally/features/wallpaper/domain/repository/wallpaper_repository.dart';
import 'package:blurhash_ffi/blurhash.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:supabase/supabase.dart';
import 'package:uuid/uuid.dart';

const String CLOUDINARY_UPLOAD_PRESET = 'bcdwnuxb';

class WallpaperRepositoryImpl implements WallpaperRepository {
  final SupabaseClient supabaseClient;
  final WallpaperLocalDataSource wallpaperLocalDataSource;
  final WallpaperRemoteDataSource wallpaperRemoteDataSource;
  final CategoryLocalDataSource categoryLocalDataSource;

  WallpaperRepositoryImpl({
    required this.supabaseClient,
    required this.wallpaperLocalDataSource,
    required this.wallpaperRemoteDataSource,
    required this.categoryLocalDataSource,
  });

  @override
  Future<Resource> addWallpaper(WallpaperEntity wallpaper) async {
    try {
      final uploadTask = uploadImageToCloudinary(wallpaper.image!.path);
      final imageUrl = await uploadTask;

      if (imageUrl == null) {
        return Resource.failure(errorMessage: 'Failed to upload image');
      }

      final downloadTask = downloadImage(imageUrl);
      final imageBytes = await downloadTask;

      if (imageBytes == null) {
        return Resource.failure(errorMessage: 'Failed to download image');
      }

      final blurHash = await generateBlurHash(imageBytes);

      final newWallpaperData =
          createWallpaperData(imageUrl, wallpaper, blurHash);
      final wallpaperModel = WallpaperModel.fromMap(newWallpaperData);

      final remoteTask = wallpaperRemoteDataSource.addWallpaper(wallpaperModel);

      final localFilePath = await saveImageToPrivateDirectory(imageBytes);
      final localFilePathString = localFilePath?.path ?? '';
      final localData =
          createLocalWallpaperData(localFilePathString, newWallpaperData);
      final localWallpaperModel = WallpaperModel.fromMap(localData);

      await Future.wait([
        remoteTask,
        wallpaperLocalDataSource.addWallpaper(localWallpaperModel)
      ]);

      return Resource.success(data: '');
    } catch (e) {
      print(e);
      return Resource.failure(errorMessage: 'Something went wrong');
    }
  }

  Future<String?> uploadImageToCloudinary(String imagePath) async {
    try {
      final url = Uri.parse("https://api.cloudinary.com/v1_1/dklkwu5fw/upload");
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = CLOUDINARY_UPLOAD_PRESET
        ..files.add(await http.MultipartFile.fromPath('file', imagePath));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);
        return jsonMap['secure_url'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> createWallpaperData(
      String imageUrl, WallpaperEntity wallpaper, String blurHash) {
    return {
      'id': const Uuid().v4(),
      'user_id': supabaseClient.auth.currentUser?.id,
      'category_id': wallpaper.categoryId,
      'title': wallpaper.title,
      'image_url': imageUrl,
      'blur_hash': blurHash,
      'size': wallpaper.size,
      'height': wallpaper.height,
      'width': wallpaper.width,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'likes': 0,
      'views': 0,
      'downloads': 0,
    };
  }

  Map<String, dynamic> createLocalWallpaperData(
      String localFilePath, Map<String, dynamic> wallpaperData) {
    return {
      ...wallpaperData,
      'image_url': localFilePath,
    };
  }

  Future<String> generateBlurHash(Uint8List imageBytes) async {
    final imageProvider = MemoryImage(imageBytes);
    return await BlurhashFFI.encode(imageProvider);
  }

  Future<Uint8List?> downloadImage(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      print('Error downloading image: $e');
    }
    return null;
  }

  Future<File?> saveImageToPrivateDirectory(Uint8List imageBytes) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final appDocPath = appDocDir.path;

      final uniqueFileName =
          '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(999999)}';

      final imageFile = File('$appDocPath/$uniqueFileName.jpg');
      await imageFile.writeAsBytes(imageBytes);
      return imageFile;
    } catch (e) {
      print('Error saving image to private directory: $e');
      return null;
    }
  }

  @override
  Future<Resource> getWallpapersByUserId(userId) async {
    throw UnimplementedError();
  }

  @override
  Future<Resource> getWallOfTheMonth() async {
    throw UnimplementedError();
  }

  @override
  Future<Resource> toggleFavouriteWallpaper(
      WallpaperEntity wallpaper, String type) async {
    try {
      WallpaperModel wallpaperModel =
          WallpaperModel.fromWallpaperEntity(wallpaper);
      wallpaperLocalDataSource.toggleFavouriteWallpaper(wallpaperModel, type);
      wallpaperRemoteDataSource.toggleFavouriteWallpaper(wallpaperModel, type);
      return Resource.success(data: '');
    } catch (e) {
      return Resource.failure(errorMessage: 'Something went wrong');
    }
  }

  @override
  Future<Resource> getFavouriteWallpapers() async {
    try {
      final wallpaperResource =
          await wallpaperLocalDataSource.getFavouriteWallpapers();

      final List<WallpaperModel> localWallpapers = wallpaperResource.data ?? [];

      List<WallpaperEntity> wallpaperEntities =
          localWallpapers.map((wallpaper) => wallpaper.toEntity()).toList();

      return Resource.success(data: wallpaperEntities);
    } catch (e) {
      return Resource.failure(errorMessage: "Something went wrong");
    }
  }

  @override
  Future<Resource> getWallpapersByCategory(categoryId) async {
    throw UnimplementedError();
  }

  // Stream<Resource> getRecentlyAddedWallpapers(bool fetchFromRemote) async* {
  //   StreamController<Resource> controller = StreamController();

  //   try {
  //     final localResource =
  //         await wallpaperLocalDataSource.getRecentlyAddedWallpapers();
  //     List<WallpaperModel> localWallpapers = localResource.data ?? [];

  //     if (localWallpapers.isNotEmpty && !fetchFromRemote) {
  //       controller.add(Resource.success(
  //         data:
  //             localWallpapers.map((wallpaper) => wallpaper.toEntity()).toList(),
  //       ));
  //     }

  //     await for (var wallpaperModel in _syncWallpapersInBackground(
  //       wallpaperRemoteDataSource,
  //       wallpaperLocalDataSource,
  //     )) {
  //       controller.add(Resource.success(
  //         data: [wallpaperModel.toEntity()],
  //       ));
  //     }

  //     controller.close();
  //   } catch (e) {
  //     controller.add(Resource.failure(errorMessage: "Something went wrong"));
  //     controller.close();
  //   }

  //   yield* controller.stream;
  // }

  @override
  Stream<Resource> getRecentlyAddedWallpapers(bool fetchFromRemote) async* {
    try {
      final localResource =
          await wallpaperLocalDataSource.getRecentlyAddedWallpapers();
      List<WallpaperModel> localWallpapers = localResource.data ?? [];

      yield Resource.success(
          data: localWallpapers
              .map((wallpaper) => wallpaper.toEntity())
              .toList());

      if (localWallpapers.isEmpty || fetchFromRemote) {
        await for (var entity in _syncWallpapersInBackground(
            wallpaperRemoteDataSource, wallpaperLocalDataSource)) {
          int existingIndex = localWallpapers
              .indexWhere((wallpaper) => wallpaper.id == entity.id);

          final categoryResource =
              await categoryLocalDataSource.getCategoryById(entity.categoryId!);
          entity.category = categoryResource.data;

          print(existingIndex);

          if (existingIndex == -1) {
            localWallpapers.add(entity);
          } else {
            localWallpapers[existingIndex] = entity;
          }

          yield Resource.success(
              data: localWallpapers
                  .map((wallpaper) => wallpaper.toEntity())
                  .toList());
        }
      }
    } catch (e) {
      yield Resource.failure(errorMessage: "Something went wrong");
    }
  }

  Stream<WallpaperModel> _syncWallpapersInBackground(
    WallpaperRemoteDataSource remoteDataSource,
    WallpaperLocalDataSource localDataSource,
  ) async* {
    try {
      final localIdsResource = await localDataSource.getAllWallpaperIds();

      if (localIdsResource.success) {
        final serverRecordsResource =
            await remoteDataSource.getIdsNotInServer(localIdsResource.data);
        print('reocrs ids wally not in server');
        print(serverRecordsResource.data);
        if (serverRecordsResource.success) {
          for (var record in serverRecordsResource.data) {
            localDataSource.deleteWallpaper(record);
          }
        }
      }

      DateTime? lastUpdatedAt;
      final lastUpdatedRecordResource =
          await localDataSource.getLastUpdatedRecord();
      if (lastUpdatedRecordResource.success) {
        lastUpdatedAt = lastUpdatedRecordResource.data.updatedAt;
        print('updated at');
        print(lastUpdatedAt);
      } else {
        print('last updated erro msg');
        print(lastUpdatedRecordResource.errorMessage);
      }

      final updatedRecordsResource = lastUpdatedAt != null
          ? await remoteDataSource.getUpdatedRecords(lastUpdatedAt)
          : await remoteDataSource.getRecentlyAddedWallpapers();

      if (!updatedRecordsResource.success) {
        print('Failed to fetch updated records from the server');
        return;
      }

      for (var record in updatedRecordsResource.data) {
        print(updatedRecordsResource.data.length);
        print('server record updated at');
        print(
            'Server record updated at: ${record['updated_at']} local record udpated at $lastUpdatedAt');

        final existingRecordResource =
            await localDataSource.getWallpaperById(record['id']);

        final imageBytes = await downloadImage(record['image_url']);
        if (imageBytes != null) {
          final localImagePath = await saveImageToPrivateDirectory(imageBytes);
          record['image_url'] = localImagePath!.path;
        }
        WallpaperModel wallpaperModel = WallpaperModel.fromMap(record);
        if (existingRecordResource.success) {
          wallpaperModel.favourite = existingRecordResource.data.favourite;
          await localDataSource.updateWallpaper(wallpaperModel);
        } else {
          print('add');
          await localDataSource.addWallpaper(wallpaperModel);
        }

        yield wallpaperModel;
      }
    } catch (e) {
      print('Background - Error: $e');
    }
  }

  @override
  Future<Resource> getPopularWallpapers() async {
    throw UnimplementedError();
  }
}
