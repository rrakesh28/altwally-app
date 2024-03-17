import 'package:alt__wally/core/util/resource.dart';

abstract class CategoryRemoteDataSource {
  Future<Resource> getCategories();
  Future<Resource> getUpdatedRecords(DateTime updatedAt);
  Future<Resource> getIdsNotInServer(List<String> localIds);
}
