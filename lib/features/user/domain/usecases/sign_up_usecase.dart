import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/user/domain/entities/user_entity.dart';
import 'package:alt__wally/features/user/domain/repository/user_repository.dart';

class SignUpUseCase {
  final UserRepository repository;

  SignUpUseCase({required this.repository});

  Future<Resource> call(UserEntity user) {
    return repository.signUp(user);
  }
}
