import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/category/data/datasources/local/cateogry_local_data_source.dart';
import 'package:alt__wally/features/category/data/datasources/remote/category_remote_data_source.dart';
import 'package:alt__wally/features/category/data/model/category_model.dart';
import 'package:alt__wally/features/category/domain/repository/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Resource> getCategories(bool fetchFromRemote) async {
    try {
      final localResource = await localDataSource.getCategories();
      final List<CategoryModel> localCategories = localResource.data ?? [];

      if (localCategories.isNotEmpty && !fetchFromRemote) {
        return Resource.success(
          data: localCategories.map((category) => category.toEntity()).toList(),
        );
      }

      await _syncCategoriesInBackground(remoteDataSource, localDataSource);

      final updatedLocalResource = await localDataSource.getCategories();
      final List<CategoryModel> updatedLocalCategories =
          updatedLocalResource.data ?? [];

      return Resource.success(
        data: updatedLocalCategories
            .map((category) => category.toEntity())
            .toList(),
      );
    } catch (e) {
      return Resource.failure(errorMessage: "Something went wrong");
    }
  }

  Future<void> _syncCategoriesInBackground(
      CategoryRemoteDataSource remoteDataSource,
      CategoryLocalDataSource localDataSource) async {
    try {
      final localIdsResource = await localDataSource.getAllCategoryIds();
      if (!localIdsResource.success) {
        print('Failed to fetch local category IDs');
        return;
      }

      final serverRecordsResource =
          await remoteDataSource.getIdsNotInServer(localIdsResource.data);
      if (!serverRecordsResource.success) {
        print('Failed to fetch server records not present locally');
        return;
      }

      for (var record in serverRecordsResource.data) {
        localDataSource.deleteCategory(record);
      }

      DateTime? lastUpdatedAt;
      final lastUpdatedRecordResource =
          await localDataSource.getLastUpdatedRecord();
      if (lastUpdatedRecordResource.success) {
        if (lastUpdatedRecordResource.data.updatedAt != null) {
          lastUpdatedAt = lastUpdatedRecordResource.data.updatedAt;
        }
      }
      final updatedRecordsResource = lastUpdatedAt != null
          ? await remoteDataSource.getUpdatedRecords(lastUpdatedAt)
          : await remoteDataSource.getCategories();
      if (!updatedRecordsResource.success) {
        print('Failed to fetch updated records from the server');
        return;
      }

      for (var record in updatedRecordsResource.data) {
        CategoryModel categoryModel = CategoryModel.fromMap(record);
        final existingRecordResource =
            await localDataSource.getCategoryById(record['id']);
        if (existingRecordResource.success) {
          await localDataSource.updateCategory(categoryModel);
        } else {
          await localDataSource.addCategory(categoryModel);
        }
      }
    } catch (e) {
      print('Error during category synchronization: $e');
    }
  }
}
