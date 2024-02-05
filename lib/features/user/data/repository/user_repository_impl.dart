import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/user/data/mapper/user_mapper.dart';
import 'package:alt__wally/features/user/data/remote/user_api_service.dart';
import 'package:alt__wally/features/user/domain/entities/user_entity.dart';
import 'package:alt__wally/features/user/domain/repository/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepositoryImpl implements UserRepository {
  final UserApiService api;

  UserRepositoryImpl({required this.api});

  @override
  Future<Resource> forgotPassword(String email) async {
    try {
      // HttpResponse httpResponse = await api.forgotPassword(email: email);
      HttpResponse httpResponse = await api.forgotPassword(email: email);
      return Resource.success(data: httpResponse.data);
    } catch (e) {
      if (e is DioException) {
        return Resource.failure(
            errorMessage: 'Error in sending reset link', dioException: e);
      } else {
        return Resource.failure(errorMessage: 'An unexpected error occurred');
      }
    }
  }

  @override
  Future<int> getCurrentUId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int value = prefs.getInt("user_id")!;
    return value;
  }

  @override
  Future<Resource> getUserById(int id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String token = prefs.getString("token")!;
      String authorizationHeader = 'Bearer $token';

      HttpResponse httpResponse = await api.getUser(
          userId: id, authorizationHeader: authorizationHeader);

      return Resource.success(data: userDtoToUserEntity(httpResponse.data));
    } catch (e) {
      if (e is DioException) {
        return Resource.failure(
            errorMessage: 'Error in getting user', dioException: e);
      } else {
        return Resource.failure(errorMessage: 'Something went wrong');
      }
    }
  }

  @override
  Future<Resource> getUpdateUser(UserEntity user) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> isSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? userId = prefs.getInt("user_id");
    return userId != null;
  }

  @override
  Future<Resource> signIn(UserEntity user) async {
    try {
      HttpResponse httpResponse =
          await api.login(email: user.email, password: user.password);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("user_id", httpResponse.data.user.id);
      prefs.setString("token", httpResponse.data.token);
      return Resource.success(data: httpResponse.data);
    } catch (e) {
      if (e is DioException) {
        if (e.response != null && e.response!.statusCode == 422) {
          final validationErrors = e.response!.data['errors'];
          return Resource.failure(
            errorMessage: 'Validation error',
            validationErrors: validationErrors,
          );
        } else if (e.response != null && e.response!.statusCode == 401) {
          return Resource.failure(
            errorMessage: e.response!.data['message'],
            dioException: e,
          );
        } else {
          return Resource.failure(
            errorMessage: 'Error in sign up',
            dioException: e,
          );
        }
      } else {
        return Resource.failure(errorMessage: "Something went wrong");
      }
    }
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<Resource> signUp(UserEntity user) async {
    try {
      HttpResponse httpResponse = await api.register(
          name: user.name, email: user.email, password: user.password);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("user_id", httpResponse.data.user.id);
      prefs.setString("token", httpResponse.data.token);

      return Resource.success(data: httpResponse.data);
    } catch (e) {
      if (e is DioException) {
        if (e.response != null && e.response!.statusCode == 422) {
          final validationErrors = e.response!.data['errors'];
          return Resource.failure(
            errorMessage: 'Validation error',
            validationErrors: validationErrors,
          );
        } else {
          return Resource.failure(
            errorMessage: 'Error in sign up',
            dioException: e,
          );
        }
      } else {
        return Resource.failure(errorMessage: "Something went wrong");
      }
    }
  }
}
