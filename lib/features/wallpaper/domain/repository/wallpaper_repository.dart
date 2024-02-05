import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';

abstract class WallpaperRepository {
  Future<Resource> addWallpaper(WallpaperEntity wallpaper);
  Future<Resource> getWallpapersByUserId(userId);
  Future<Resource> getWallOfTheMonth();
  Future<Resource> getFavouriteWallpapers();
  Future<Resource> toggleFavouriteWallpaper(WallpaperEntity wallpaper);
}
