import 'package:alt__wally/features/user/domain/repository/user_repository.dart';

class GetCurrentUIDUseCase {
  final UserRepository repository;

  GetCurrentUIDUseCase({required this.repository});

  Future<int> call() {
    return repository.getCurrentUId();
  }
}
