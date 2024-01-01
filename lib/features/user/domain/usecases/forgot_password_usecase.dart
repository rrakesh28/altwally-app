import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/user/domain/repository/user_repository.dart';

class ForgotPasswordUseCase {
  final UserRepository repository;

  ForgotPasswordUseCase({required this.repository});

  Future<Resource> call(String email) {
    return repository.forgotPassword(email);
  }
}
