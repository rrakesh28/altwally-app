import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/category/domain/repository/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase({required this.repository});

  Future<Resource> call(bool fetchFromRemote) {
    return repository.getCategories(fetchFromRemote);
  }
}
