import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:alt__wally/features/wallpaper/domain/repository/wallpaper_repository.dart';

class AddWallpaperUseCase {
  final WallpaperRepository repository;

  AddWallpaperUseCase({required this.repository});

  Future<Resource> call(WallpaperEntity wallpaper) {
    return repository.addWallpaper(wallpaper);
  }
}
