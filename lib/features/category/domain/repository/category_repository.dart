import 'package:alt__wally/core/util/resource.dart';

abstract class CategoryRepository {
  Future<Resource> getCategories();
  Future<Resource> getWallpapers(categoryId);
}
