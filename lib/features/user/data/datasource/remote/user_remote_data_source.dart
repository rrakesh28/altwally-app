import 'package:alt__wally/core/util/resource.dart';

abstract class UserRemoteDataSource {
  Future<Resource> getAllUsers();
}
