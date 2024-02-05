import 'dart:io';

import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/wallpaper/data/mapper/wallpaper_mapper.dart';
import 'package:alt__wally/features/wallpaper/data/remote/dto/wallpapers_dto.dart';
import 'package:alt__wally/features/wallpaper/data/remote/wallpaper_api_service.dart';
import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:alt__wally/features/wallpaper/domain/repository/wallpaper_repository.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WallpaperRepositoryImpl implements WallpaperRepository {
  final WallpaperApiService api;

  WallpaperRepositoryImpl({required this.api});
  @override
  Future<Resource> addWallpaper(WallpaperEntity wallpaper) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(
        "token",
      );

      String? authorizationHeader = 'Bearer $token';

      final int categoryId = wallpaper.categoryId!;
      final String title = wallpaper.title!;
      final File image = wallpaper.image!;
      final int size = wallpaper.size!;
      final int height = wallpaper.height!;
      final int width = wallpaper.width!;

      final response = await api.addWallpaper(
          authorizationHeader, categoryId, title, image, size, height, width);

      return Resource.success(data: response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.response != null && e.response!.statusCode == 422) {
          final validationErrors = e.response!.data['errors'];
          return Resource.failure(
            errorMessage: 'Validation error',
            validationErrors: validationErrors,
          );
        } else {
          return Resource.failure(
            errorMessage: 'Error in uploading wallpaper',
            dioException: e,
          );
        }
      } else {
        return Resource.failure(errorMessage: "Something went wrong");
      }
    }
  }

  @override
  Future<Resource> getWallpapersByUserId(userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String token = prefs.getString("token")!;
      String authorizationHeader = 'Bearer $token';
      final httpResponse = await api.getWallpapersByUserId(
        authorizationHeader,
        userId,
      );
      List<WallpaperDataDto> wallpaperList = httpResponse.data.data;

      List<WallpaperEntity> wallpaperEntities =
          convertToWallpaperEntities(wallpaperList);

      return Resource.success(data: wallpaperEntities);
    } catch (e) {
      if (e is DioException) {
        return Resource.failure(
            errorMessage: 'Error in getting user', dioException: e);
      } else {
        return Resource.failure(errorMessage: 'Something went wrong');
      }
    }
  }

  @override
  Future<Resource> getWallOfTheMonth() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String token = prefs.getString("token")!;
      String authorizationHeader = 'Bearer $token';
      final httpResponse = await api.getWallOfTheMonth(authorizationHeader);
      List<WallpaperDataDto> wallpaperList = httpResponse.data.data;

      List<WallpaperEntity> wallpaperEntities =
          convertToWallpaperEntities(wallpaperList);

      return Resource.success(data: wallpaperEntities);
    } catch (e) {
      if (e is DioException) {
        return Resource.failure(
            errorMessage: 'Error in getting user', dioException: e);
      } else {
        return Resource.failure(errorMessage: 'Something went wrong');
      }
    }
  }

  @override
  Future<Resource> toggleFavouriteWallpaper(WallpaperEntity wallpaper) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String token = prefs.getString("token")!;
      String authorizationHeader = 'Bearer $token';
      int wallpaperId = wallpaper.id!;
      final httpResponse =
          await api.toggleFavouriteWallpaper(authorizationHeader, wallpaperId);

      return Resource.success(data: httpResponse);
    } catch (e) {
      if (e is DioException) {
        return Resource.failure(
            errorMessage: 'Error in getting user', dioException: e);
      } else {
        return Resource.failure(errorMessage: 'Something went wrong');
      }
    }
  }

  @override
  Future<Resource> getFavouriteWallpapers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String token = prefs.getString("token")!;
      String authorizationHeader = 'Bearer $token';
      final httpResponse =
          await api.getFavouriteWallpapers(authorizationHeader);
      List<WallpaperDataDto> wallpaperList = httpResponse.data.data;

      List<WallpaperEntity> wallpaperEntities =
          convertToWallpaperEntities(wallpaperList);

      return Resource.success(data: wallpaperEntities);
    } catch (e) {
      if (e is DioException) {
        return Resource.failure(
            errorMessage: 'Error in getting user', dioException: e);
      } else {
        return Resource.failure(errorMessage: 'Something went wrong');
      }
    }
  }
}
