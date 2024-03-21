import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/category/data/datasources/local/cateogry_local_data_source.dart';
import 'package:alt__wally/features/user/data/datasource/local/user_local_data_source.dart';
import 'package:alt__wally/features/wallpaper/data/datasource/local/wallpaper_local_data_source.dart';
import 'package:alt__wally/features/wallpaper/data/model/wallpaper_model.dart';
import 'package:hive/hive.dart';

class WallpaperLocalDataSourceImpl implements WallpaperLocalDataSource {
  static const String _boxName = 'wallpapers';

  final CategoryLocalDataSource categoryLocalDataSource;
  final UserLocalDataSource userLocalDataSource;

  WallpaperLocalDataSourceImpl(
      {required this.userLocalDataSource,
      required this.categoryLocalDataSource});

  @override
  Future<Resource> addWallpaper(WallpaperModel wallpaper) async {
    print('add wallpaper local');
    print(wallpaper);
    try {
      final box = await Hive.openBox<WallpaperModel>(_boxName);

      final wallpapers = box.values.toList();
      print(wallpapers);
      await box.put(wallpaper.id, wallpaper);
      return Resource.success(data: null);
    } catch (e) {
      return Resource.failure(errorMessage: e.toString());
    }
  }

  @override
  Future<Resource> getFavouriteWallpapers() async {
    try {
      final box = await Hive.openBox<WallpaperModel>(_boxName);
      final List<WallpaperModel> wallpapers =
          box.values.where((wallpaper) => wallpaper.favourite == true).toList();

      for (var wallpaper in wallpapers) {
        // final userResource =
        //     await userLocalDataSource.getUserById(wallpaper.userId!);
        // wallpaper.user = userResource.data;

        final categoryResource = await categoryLocalDataSource
            .getCategoryById(wallpaper.categoryId!);
        wallpaper.category = categoryResource.data;
      }

      return Resource.success(data: wallpapers);
    } catch (e) {
      return Resource.failure(errorMessage: e.toString());
    }
  }

  @override
  Future<Resource> getPopularWallpapers() async {
    throw UnimplementedError();
  }

  @override
  Future<Resource> getRecentlyAddedWallpapers() async {
    try {
      final box = await Hive.openBox<WallpaperModel>(_boxName);
      final List<WallpaperModel> wallpapers = box.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      for (var wallpaper in wallpapers) {
        // final userResource =
        //     await userLocalDataSource.getUserById(wallpaper.userId!);
        // wallpaper.user = userResource.data;
        final categoryResource = await categoryLocalDataSource
            .getCategoryById(wallpaper.categoryId!);

        wallpaper.category = categoryResource.data;
      }
      return Resource.success(data: wallpapers);
    } catch (e) {
      return Resource.failure(errorMessage: e.toString());
    }
  }

  @override
  Future<Resource> getWallOfTheMonth() async {
    throw UnimplementedError();
  }

  @override
  Future<Resource> toggleFavouriteWallpaper(
      WallpaperModel wallpaper, String type) async {
    print('local toogle fav');
    try {
      final box = await Hive.openBox<WallpaperModel>(_boxName);
      final wallpaperInBox = box.get(wallpaper.id);
      print('wall in box');
      print(wallpaperInBox?.toJson());
      if (wallpaperInBox != null) {
        if (wallpaper.favourite != null) {
          if (type == 'add') {
            await box.put(
              wallpaper.id,
              wallpaper.copyWith(favourite: true),
            );
          } else {
            await box.put(
              wallpaper.id,
              wallpaper.copyWith(favourite: false),
            );
          }
        }

        final favWallResource = await getFavouriteWallpapers();

        for (var data in favWallResource.data as List<WallpaperModel>) {
          print('fav wal');
          print(data.toJson());
        }

        return Resource.success(data: null);
      } else {
        return Resource.failure(
            errorMessage: 'Wallpaper not found in the local database');
      }
    } catch (e) {
      print(e);
      return Resource.failure(errorMessage: e.toString());
    }
  }

  @override
  Future<Resource> getWallpapersByCategory(categoryId) {
    // TODO: implement getWallpapersByCategory
    throw UnimplementedError();
  }

  @override
  Future<Resource> getWallpapersByUserId(userId) {
    // TODO: implement getWallpapersByUserId
    throw UnimplementedError();
  }

  @override
  Future<Resource> deleteWallpaper(String wallpaperId) async {
    print('delete wall local');
    try {
      final box = await Hive.openBox<WallpaperModel>(_boxName);

      await box.delete(wallpaperId);

      return Resource.success(data: null);
    } catch (e) {
      return Resource.failure(errorMessage: 'Failed to delete wallpaper: $e');
    }
  }

  @override
  Future<Resource> updateWallpaper(WallpaperModel wallpaper) async {
    print('update wallpaper local');
    print(wallpaper);
    try {
      final box = await Hive.openBox<WallpaperModel>(_boxName);

      final wallpapers = box.values.toList();
      print(wallpapers);

      await box.put(wallpaper.id, wallpaper);

      return Resource.success(data: wallpaper);
    } catch (e) {
      return Resource.failure(errorMessage: 'Failed to update wallpaper: $e');
    }
  }

  @override
  Future<Resource> getAllWallpaperIds() async {
    try {
      final box = await Hive.openBox<WallpaperModel>(_boxName);

      final List<String> wallpaperIds =
          box.values.map((wallpaper) => wallpaper.id!).toList();

      return Resource.success(data: wallpaperIds);
    } catch (e) {
      return Resource.failure(errorMessage: 'Failed to get wallpapers IDs: $e');
    }
  }

  @override
  Future<Resource> getLastUpdatedRecord() async {
    try {
      final box = await Hive.openBox<WallpaperModel>(_boxName);

      final List<WallpaperModel> sortedRecords = box.values.toList();

      print('sortedRecords');
      print(sortedRecords);

      sortedRecords.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      if (sortedRecords.isNotEmpty) {
        return Resource.success(data: sortedRecords.first);
      }

      return Resource.failure(errorMessage: 'No records found');
    } catch (e) {
      return Resource.failure(
          errorMessage: 'Failed to get last updated record: $e');
    }
  }

  @override
  Future<Resource> getWallpaperById(String id) async {
    try {
      final box = await Hive.openBox<WallpaperModel>(_boxName);

      // final WallpaperModel? category = box.get(id);

      final WallpaperModel wallpaper =
          box.values.firstWhere((element) => element.id == id);

      return Resource.success(data: wallpaper);
    } catch (e) {
      return Resource.failure(errorMessage: 'Failed to get category: $e');
    }
  }
}
