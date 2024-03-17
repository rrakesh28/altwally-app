import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/user/data/model/user_model.dart';

abstract class UserLocalDataSource {
  Future<Resource> addUser(UserModel user);

  Future<Resource> getUserById(String userId);

  Future<Resource> updateUser(UserModel updatedUser);

  Future<Resource> deleteUser(String userId);
}
