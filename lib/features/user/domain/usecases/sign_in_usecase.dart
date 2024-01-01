import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/user/domain/entities/user_entity.dart';
import 'package:alt__wally/features/user/domain/repository/user_repository.dart';

class SignInUseCase {
  final UserRepository repository;

  SignInUseCase({required this.repository});

  Future<Resource> call(UserEntity user) {
    return repository.signIn(user);
  }
}
