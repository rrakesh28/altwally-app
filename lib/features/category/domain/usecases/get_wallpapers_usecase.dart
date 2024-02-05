import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/category/domain/repository/category_repository.dart';

class GetWallpapersUseCase {
  final CategoryRepository repository;

  GetWallpapersUseCase({required this.repository});

  Future<Resource> call(categoryId) {
    return repository.getWallpapers(categoryId);
  }
}
