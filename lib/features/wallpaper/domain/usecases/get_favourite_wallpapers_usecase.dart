import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/wallpaper/domain/repository/wallpaper_repository.dart';

class GetFavouriteWallpapersUseCase {
  final WallpaperRepository repository;

  GetFavouriteWallpapersUseCase({required this.repository});

  Future<Resource> call() {
    return repository.getFavouriteWallpapers();
  }
}
