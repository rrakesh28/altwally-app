import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:alt__wally/features/wallpaper/domain/repository/wallpaper_repository.dart';

class ToggleFavouriteWallpapersUseCase {
  final WallpaperRepository repository;

  ToggleFavouriteWallpapersUseCase({required this.repository});

  Future<Resource> call(WallpaperEntity wallpaper) {
    return repository.toggleFavouriteWallpaper(wallpaper);
  }
}
