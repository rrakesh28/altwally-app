import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/wallpaper/data/model/wallpaper_model.dart';

abstract class WallpaperLocalDataSource {
  Future<Resource> addWallpaper(WallpaperModel wallpaper);
  Future<Resource> getWallpapersByUserId(userId);
  Future<Resource> getWallpapersByCategory(categoryId);
  Future<Resource> getWallOfTheMonth();
  Future<Resource> getFavouriteWallpapers();
  Future<Resource> toggleFavouriteWallpaper(
      WallpaperModel wallpaper, String type);
  Future<Resource> getRecentlyAddedWallpapers();
  Future<Resource> getPopularWallpapers();
  Future<Resource> updateWallpaper(WallpaperModel wallpaper);
  Future<Resource> deleteWallpaper(String wallpaperId);
  Future<Resource> getLastUpdatedRecord();
  Future<Resource> getAllWallpaperIds();
  Future<Resource> getWallpaperById(String id);
}
