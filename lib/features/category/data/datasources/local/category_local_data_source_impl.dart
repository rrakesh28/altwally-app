import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/category/data/datasources/local/cateogry_local_data_source.dart';
import 'package:alt__wally/features/category/data/model/category_model.dart';
import 'package:hive/hive.dart';

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  static const String _boxName = 'categories';

  @override
  Future<Resource> getCategories() async {
    try {
      final box = await Hive.openBox<CategoryModel>(_boxName);
      final List<CategoryModel> categories = box.values.toList();
      return Resource.success(data: categories);
    } catch (e) {
      return Resource.failure(errorMessage: e.toString());
    }
  }

  @override
  Future<Resource> addCategories(List<CategoryModel> categories) async {
    print('add categories');
    print(categories);
    try {
      final box = await Hive.openBox<CategoryModel>(_boxName);
      await box.clear();
      await box.addAll(categories);
      return Resource.success(data: null);
    } catch (e) {
      return Resource.failure(errorMessage: e.toString());
    }
  }

  @override
  Future<Resource> addCategory(CategoryModel category) async {
    try {
      final box = await Hive.openBox<CategoryModel>(_boxName);

      final existingCategory = await _findCategoryById(box, category.id);

      if (existingCategory != null) {
        return Resource.failure(errorMessage: "Category already exists");
      }

      await box.add(category);
      return Resource.success(data: null);
    } catch (e) {
      return Resource.failure(errorMessage: e.toString());
    }
  }

  Future<CategoryModel?> _findCategoryById(
      Box<CategoryModel> box, String categoryId) async {
    for (var i = 0; i < box.length; i++) {
      final storedCategory = box.getAt(i);
      if (storedCategory != null && storedCategory.id == categoryId) {
        return storedCategory;
      }
    }
    return null;
  }

  @override
  Future<Resource> deleteCategory(String id) async {
    try {
      final box = await Hive.openBox<CategoryModel>(_boxName);
      await box.clear();
      return Resource.success(data: null);
    } catch (e) {
      return Resource.failure(errorMessage: e.toString());
    }
  }

  @override
  Future<Resource> updateCategory(CategoryModel category) async {
    try {
      final box = await Hive.openBox<CategoryModel>(_boxName);

      final existingCategory = box.get(category.id);

      CategoryModel updatedCategory;

      if (existingCategory != null) {
        updatedCategory = CategoryModel(
          id: category.id,
          name: category.name,
          bannerImageUrl: category.bannerImageUrl,
          createdAt: category.createdAt,
          updatedAt: DateTime.now(),
        );
      } else {
        updatedCategory = category;
      }

      await box.put(category.id, updatedCategory);

      return Resource.success(data: null);
    } catch (e) {
      return Resource.failure(errorMessage: e.toString());
    }
  }

  @override
  Future<Resource> getCategoryById(String id) async {
    try {
      final box = await Hive.openBox<CategoryModel>(_boxName);

      final CategoryModel category = box.values.firstWhere(
        (element) => element.id == id,
        orElse: () => CategoryModel(
            id: '',
            name: 'Default Category',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now()),
      );

      return Resource.success(data: category);
    } catch (e) {
      return Resource.failure(errorMessage: 'Failed to get category: $e');
    }
  }

  @override
  Future<Resource> getLastUpdatedRecord() async {
    try {
      final box = await Hive.openBox<CategoryModel>(_boxName);

      final List<CategoryModel> sortedRecords = box.values.toList()
        ..sort((a, b) => (b.updatedAt).compareTo(a.updatedAt));

      print('catrogy sroted reods local');
      print(sortedRecords);

      if (sortedRecords.isNotEmpty) {
        return Resource.success(data: sortedRecords.first);
      }

      return Resource.failure(errorMessage: 'No records found');
    } catch (e) {
      print('catelogy local hive error');
      print(e);
      return Resource.failure(
          errorMessage: 'Failed to get last updated record: $e');
    }
  }

  @override
  Future<Resource> getAllCategoryIds() async {
    try {
      final box = await Hive.openBox<CategoryModel>(_boxName);

      final List<String> categoryIds =
          box.values.map((category) => category.id).toList();

      return Resource.success(data: categoryIds);
    } catch (e) {
      print('local cateogyr ids');
      print(e);
      print('Failed to get category IDs: $e');
      return Resource.failure(errorMessage: 'Failed to get category IDs: $e');
    }
  }
}
