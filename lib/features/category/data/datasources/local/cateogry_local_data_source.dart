import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/category/data/model/category_model.dart';

abstract class CategoryLocalDataSource {
  Future<Resource> getCategories();
  Future<Resource> addCategories(List<CategoryModel> categories);
  Future<Resource> addCategory(CategoryModel category);
  Future<Resource> getCategoryById(String id);
  Future<Resource> deleteCategory(String id);
  Future<Resource> updateCategory(CategoryModel category);
  Future<Resource> getLastUpdatedRecord();
  Future<Resource> getAllCategoryIds();
}
