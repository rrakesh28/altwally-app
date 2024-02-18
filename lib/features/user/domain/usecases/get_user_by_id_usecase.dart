import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/user/domain/repository/user_repository.dart';

class GetUserByIdUseCase {
  final UserRepository repository;

  GetUserByIdUseCase({required this.repository});

  Future<Resource> call(String id) {
    return repository.getUserById(id);
  }
}
