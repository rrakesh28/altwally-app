import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/category/data/mapper/category_mapper.dart';
import 'package:alt__wally/features/category/data/remote/category_api_service.dart';
import 'package:alt__wally/features/category/domain/entities/category_entity.dart';
import 'package:alt__wally/features/category/domain/repository/category_repository.dart';
import 'package:alt__wally/features/wallpaper/data/mapper/wallpaper_mapper.dart';
import 'package:alt__wally/features/wallpaper/data/remote/dto/wallpapers_dto.dart';
import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryApiService api;

  CategoryRepositoryImpl({required this.api});
  @override
  Future<Resource> getCategories() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String token = prefs.getString("token")!;
      String authorizationHeader = 'Bearer $token';

      final httpResponse =
          await api.getCategories(authorizationHeader: authorizationHeader);

      List<CategoryEntity> categories = httpResponse.data
          .map((categoryDto) => categoryDtoToCategoryEntity(categoryDto))
          .toList();
      ;
      return Resource.success(data: categories);
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
  Future<Resource> getWallpapers(categoryId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String token = prefs.getString("token")!;
      String authorizationHeader = 'Bearer $token';
      final httpResponse = await api.getWallpapers(
        authorizationHeader: authorizationHeader,
        categoryId: categoryId,
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
}
