import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/wallpaper/domain/repository/wallpaper_repository.dart';

class GetRecentlyAddedUseCase {
  final WallpaperRepository repository;

  GetRecentlyAddedUseCase({required this.repository});

  Future<Resource> call() {
    return repository.getRecentlyAddedWallpapers();
  }
}