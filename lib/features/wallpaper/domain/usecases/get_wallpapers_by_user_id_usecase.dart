import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/wallpaper/domain/repository/wallpaper_repository.dart';

class GetWallpapersByUserIdUseCase {
  final WallpaperRepository repository;

  GetWallpapersByUserIdUseCase({required this.repository});

  Future<Resource> call(userId) {
    return repository.getWallpapersByUserId(userId);
  }
}
