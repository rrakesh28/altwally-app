import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:alt__wally/core/util/resource.dart';
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

  WallpaperRepositoryImpl({
    required this.supabaseClient,
    required this.wallpaperLocalDataSource,
    required this.wallpaperRemoteDataSource,
  });

  @override
  Future<Resource> addWallpaper(WallpaperEntity wallpaper) async {
    try {
      // Upload image to Cloudinary in parallel with downloading the image
      final uploadTask = uploadImageToCloudinary(wallpaper.image!.path);
      final imageUrl = await uploadTask;

      if (imageUrl == null) {
        return Resource.failure(errorMessage: 'Failed to upload image');
      }

      // Download image
      final downloadTask = downloadImage(imageUrl);
      final imageBytes = await downloadTask;

      if (imageBytes == null) {
        return Resource.failure(errorMessage: 'Failed to download image');
      }

      // Generate blur hash
      final blurHash = await generateBlurHash(imageBytes);

      // Create wallpaper data
      final newWallpaperData =
          createWallpaperData(imageUrl, wallpaper, blurHash);
      final wallpaperModel = WallpaperModel.fromMap(newWallpaperData);

      // Perform remote operation
      final remoteTask = wallpaperRemoteDataSource.addWallpaper(wallpaperModel);

      // Save image locally
      final localFilePath = await saveImageToPrivateDirectory(imageBytes);
      final localFilePathString = localFilePath?.path ?? '';
      final localData =
          createLocalWallpaperData(localFilePathString, newWallpaperData);
      final localWallpaperModel = WallpaperModel.fromMap(localData);

      // Wait for both remote and local operations to complete
      await Future.wait([
        remoteTask,
        wallpaperLocalDataSource.addWallpaper(localWallpaperModel)
      ]);

      return Resource.success(data: '');
    } catch (e) {
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
      'id': Uuid().v4(),
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

  @override
  Future<Resource> getRecentlyAddedWallpapers(bool fetchFromRemote) async {
    try {
      final localResource =
          await wallpaperLocalDataSource.getRecentlyAddedWallpapers();
      final List<WallpaperModel> localWallpapers = localResource.data ?? [];

      List<WallpaperEntity> wallpaperEntities =
          localWallpapers.map((wallpaper) => wallpaper.toEntity()).toList();

      if (localWallpapers.isNotEmpty && !fetchFromRemote) {
        return Resource.success(data: wallpaperEntities);
      }

      await _syncWallpapersInBackground(
          wallpaperRemoteDataSource, wallpaperLocalDataSource);

      final updatedLocalResource =
          await wallpaperLocalDataSource.getRecentlyAddedWallpapers();
      final List<WallpaperModel> updatedLocalWallpapers =
          updatedLocalResource.data ?? [];

      List<WallpaperEntity> updatedWallpaperEntities = updatedLocalWallpapers
          .map((wallpaper) => wallpaper.toEntity())
          .toList();
      return Resource.success(data: updatedWallpaperEntities);
    } catch (e) {
      return Resource.failure(errorMessage: "Something went wrong");
    }
  }

  Future<void> _syncWallpapersInBackground(
    WallpaperRemoteDataSource remoteDataSource,
    WallpaperLocalDataSource localDataSource,
  ) async {
    try {
      final localIdsResource = await localDataSource.getAllWallpaperIds();

      if (localIdsResource.success) {
        final serverRecordsResource =
            await remoteDataSource.getIdsNotInServer(localIdsResource.data);
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
        if (lastUpdatedRecordResource.data.updatedAt != null) {
          lastUpdatedAt = lastUpdatedRecordResource.data.updatedAt;
        }
      }
      final updatedRecordsResource = lastUpdatedAt != null
          ? await remoteDataSource.getUpdatedRecords(lastUpdatedAt)
          : await remoteDataSource.getRecentlyAddedWallpapers();

      if (!updatedRecordsResource.success) {
        print('Failed to fetch updated records from the server');
        return;
      }

      for (var record in updatedRecordsResource.data) {
        final existingRecordResource =
            await localDataSource.getWallpaperById(record['id']);

        final imageBytes = await downloadImage(record['image_url']);
        if (imageBytes != null) {
          final localImagePath = await saveImageToPrivateDirectory(imageBytes);
          record['image_url'] = localImagePath!.path;
        }
        WallpaperModel wallpaperModel = WallpaperModel.fromMap(record);
        if (existingRecordResource.success) {
          await localDataSource.updateWallpaper(wallpaperModel);
        } else {
          await localDataSource.addWallpaper(wallpaperModel);
        }
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
