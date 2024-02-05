import 'package:alt__wally/features/wallpaper/data/remote/dto/wallpapers_dto.dart';
import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';

List<WallpaperEntity> convertToWallpaperEntities(
    List<WallpaperDataDto> wallpapers) {
  return wallpapers
      .map((wallpaper) => WallpaperEntity.fromWallpaper(wallpaper))
      .toList();
}
