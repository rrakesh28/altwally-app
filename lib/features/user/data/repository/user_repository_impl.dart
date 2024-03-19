import 'dart:convert';
import 'dart:io';

import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/user/domain/entities/user_entity.dart';
import 'package:alt__wally/features/user/domain/repository/user_repository.dart';
import 'package:http/http.dart' as http;
import 'package:supabase/supabase.dart';

class UserRepositoryImpl implements UserRepository {
  final SupabaseClient supabaseClient;

  UserRepositoryImpl({required this.supabaseClient});

  @override
  Future<Resource> forgotPassword(String email) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(email);
      return Resource.success(data: '');
    } catch (e) {
      return Resource.failure(errorMessage: "Something went wrong");
    }
  }

  @override
  Future<String> getCurrentUId() async {
    final currentUser = supabaseClient.auth.currentUser;
    if (currentUser != null) {
      return currentUser.id;
    } else {
      throw Exception("User is not logged in.");
    }
  }

  @override
  Future<Resource> getUserById(String uid) async {
    try {
      final userResponse =
          await supabaseClient.from('users').select().eq('id', uid).single();

      final user = UserEntity.fromJson(userResponse);

      return Resource.success(data: user);
    } catch (e) {
      return Resource.failure(errorMessage: "Something went wrong: $e");
    }
  }

  @override
  Future<Resource> getUpdateUser(
      UserEntity user, String currentPassword) async {
    try {
      final userTable = supabaseClient.from('users');

      Map<String, dynamic> updates = {
        'name': user.name,
        'updated_at': DateTime.now().toIso8601String(),
      };

      Future<void> updateImageUrl(
          String? imageUrlKey, File? imageFile, String preset) async {
        if (imageFile != null) {
          final imageUrl = await uploadImage(imageFile, preset);
          if (imageUrl != null) {
            updates[imageUrlKey!] = imageUrl;
          }
        }
      }

      await Future.wait([
        updateImageUrl('profile_image_url', user.profileImage, 'd2cxv15u'),
        updateImageUrl('banner_image_url', user.bannerImage, 'fjns4yz9'),
      ]);

      if (user.email != supabaseClient.auth.currentUser?.email) {
        final res = await supabaseClient.auth.updateUser(
          UserAttributes(email: user.email),
        );
        if (res.user != null) {
          updates['email'] = user.email;
        } else {
          return Resource.failure(errorMessage: 'Failed to update email');
        }
      }

      if (user.password != null && user.password!.trim().isNotEmpty) {
        final res = await supabaseClient.auth.updateUser(
          UserAttributes(password: user.password),
        );
        if (res.user != null) {
          return Resource.failure(errorMessage: 'Failed to update password');
        }
      }

      String uid = supabaseClient.auth.currentUser?.id ?? '';
      await userTable.update(updates).eq('id', uid);

      return Resource.success(data: '');
    } catch (e) {
      return Resource.failure(errorMessage: "Something went wrong");
    }
  }

  Future<String?> uploadImage(File image, String preset) async {
    final url = Uri.parse("https://api.cloudinary.com/v1_1/dklkwu5fw/upload");
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = preset
      ..files.add(await http.MultipartFile.fromPath('file', image.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      return jsonMap['secure_url'];
    }

    return null;
  }

  @override
  Future<bool> isSignIn() async {
    try {
      final session = supabaseClient.auth.currentSession;
      return session != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Resource> signIn(UserEntity user) async {
    try {
      final AuthResponse response =
          await supabaseClient.auth.signInWithPassword(
        email: user.email!,
        password: user.password!,
      );

      if (response.user != null) {
        return Resource.success(data: '');
      } else {
        return Resource.failure(errorMessage: 'Credentials not found.');
      }
    } catch (e) {
      return Resource.failure(errorMessage: 'Something went wrong');
    }
  }

  @override
  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }

  @override
  Future<Resource> signUp(UserEntity user) async {
    try {
      final users = await supabaseClient
          .from('users')
          .select("*")
          .eq('email', user.email!)
          .limit(1);
      if (users.isNotEmpty) {
        return Resource.failure(errorMessage: 'Email ID already exists');
      }

      AuthResponse response = await supabaseClient.auth.signUp(
        email: user.email!,
        password: user.password!,
      );

      final uid = response.user!.id;
      final email = response.user!.email;

      final newUser = {
        'email': email,
        'id': uid,
        'name': user.name!,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'profile_image_url':
            'https://res.cloudinary.com/dklkwu5fw/image/upload/v1707755056/profile_images/lkidtk25byxho4aljtvc.jpg',
        'banner_image_url':
            'https://res.cloudinary.com/dklkwu5fw/image/upload/v1707755095/banner_images/f9j4mav0zlqrj51u9bg5.jpg',
      };

      await supabaseClient.from('users').insert([newUser]);

      return Resource.success(data: '');
    } catch (e) {
      return Resource.failure(errorMessage: e.toString());
    }
  }
}
