import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/wallpaper/domain/repository/wallpaper_repository.dart';

class GetCategoryWallpapersUseCase {
  final WallpaperRepository repository;

  GetCategoryWallpapersUseCase({required this.repository});

  Future<Resource> call(categoryId) {
    return repository.getWallpapersByCategory(categoryId);
  }
}
