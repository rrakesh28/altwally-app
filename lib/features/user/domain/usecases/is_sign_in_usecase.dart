import 'package:alt__wally/features/user/domain/repository/user_repository.dart';

class IsSignInUseCase {
  final UserRepository repository;

  IsSignInUseCase({required this.repository});

  Future<bool> call() {
    return repository.isSignIn();
  }
}
