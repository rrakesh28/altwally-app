import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/user/data/datasource/local/user_local_data_source.dart';
import 'package:alt__wally/features/user/data/model/user_model.dart';
import 'package:hive/hive.dart';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  static const String _userBoxName = 'userBox';

  @override
  Future<Resource> addUser(UserModel user) async {
    try {
      final box = await Hive.openBox<UserModel>(_userBoxName);
      await box.put(user.id, user);
      return Resource.success(data: null);
    } catch (e) {
      return Resource.failure(errorMessage: e.toString());
    }
  }

  @override
  Future<Resource> deleteUser(String userId) async {
    try {
      final box = await Hive.openBox<UserModel>(_userBoxName);
      await box.delete(userId);
      return Resource.success(data: null);
    } catch (e) {
      return Resource.failure(errorMessage: e.toString());
    }
  }

  @override
  Future<Resource> getUserById(String userId) async {
    try {
      final box = await Hive.openBox<UserModel>(_userBoxName);
      final user = box.get(userId);
      return Resource.success(data: user);
    } catch (e) {
      return Resource.failure(errorMessage: e.toString());
    }
  }

  @override
  Future<Resource> updateUser(UserModel updatedUser) async {
    try {
      final box = await Hive.openBox<UserModel>(_userBoxName);
      await box.put(updatedUser.id, updatedUser);
      return Resource.success(data: null);
    } catch (e) {
      return Resource.failure(errorMessage: e.toString());
    }
  }
}
