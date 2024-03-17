import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/category/data/datasources/remote/category_remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final SupabaseClient supabaseClient;

  CategoryRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<Resource> getCategories() async {
    try {
      final categoriesTable = supabaseClient.from('categories');

      final response = await categoriesTable.select();

      if (response.isEmpty) {
        return Resource.failure(errorMessage: 'Something went wrong');
      }

      return Resource.success(data: response);
    } catch (e) {
      return Resource.failure(errorMessage: "Something went wrong");
    }
  }

  @override
  Future<Resource> getUpdatedRecords(DateTime updatedAt) async {
    try {
      final categoriesTable = supabaseClient.from('categories');

      final data = await categoriesTable
          .select()
          .gt('updated_at', updatedAt.toIso8601String());

      return Resource.success(data: data);
    } catch (e) {
      return Resource.failure(
          errorMessage: 'Failed to get updated records: $e');
    }
  }

  @override
  Future<Resource> getIdsNotInServer(List<String> localIds) async {
    print('impl local ids');
    print(localIds);
    try {
      final categoriesTable = supabaseClient.from('categories');

      final serverIdsData =
          await categoriesTable.select('id').inFilter('id', localIds);

      List<String> serverIds = [];
      for (var row in serverIdsData) {
        serverIds.add(row['id']);
      }
      List<String> idsNotInServer =
          localIds.where((id) => !serverIds.contains(id)).toList();

      print('id not in server');
      print(idsNotInServer);

      return Resource.success(data: idsNotInServer);
    } catch (e) {
      return Resource.failure(errorMessage: 'Error: $e');
    }
  }
}
