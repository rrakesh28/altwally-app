import 'package:alt__wally/features/user/domain/repository/user_repository.dart';

class SignOutUseCase {
  final UserRepository   repository;

  SignOutUseCase({required this.repository});

  Future<void> call() {
    return repository.signOut();
  }
}
