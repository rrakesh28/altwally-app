import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/user/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Resource> forgotPassword(String email);
  Future<bool> isSignIn();
  Future<Resource> signIn(UserEntity user);
  Future<Resource> signUp(UserEntity user);
  Future<void> signOut();
  Future<Resource> getUpdateUser(UserEntity user);
  Future<int> getCurrentUId();
  Future<Resource> getUserById(int id);
}
