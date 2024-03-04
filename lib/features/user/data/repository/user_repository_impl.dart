import 'dart:convert';
import 'dart:io';

import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/user/data/model/user_model.dart';
import 'package:alt__wally/features/user/domain/entities/user_entity.dart';
import 'package:alt__wally/features/user/domain/repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;

  UserRepositoryImpl({required this.fireStore, required this.auth});

  @override
  Future<Resource> forgotPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return Resource.success(data: '');
    } catch (e) {
      return Resource.failure(errorMessage: "Something went wrong");
    }
  }

  @override
  Future<String> getCurrentUId() async {
    return auth.currentUser!.uid;
  }

  @override
  Future<Resource> getUserById(String uid) async {
    try {
      final userCollection = fireStore.collection("users");

      final UserEntity? user = await userCollection
          .limit(1)
          .where("uid", isEqualTo: uid)
          .get()
          .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          return UserEntity.fromUserModel(
            UserModel.fromSnapshot(querySnapshot.docs.first),
          );
        } else {
          return null;
        }
      });

      return Resource.success(data: user);
    } catch (e) {
      return Resource.failure(errorMessage: "Something went wrong");
    }
  }

  @override
  Future<Resource> getUpdateUser(
      UserEntity user, String currentPassword) async {
    try {
      final userCollection = fireStore.collection('users');

      Map<String, dynamic> updates = {
        'name': user.name,
        'updated_at': Timestamp.fromDate(DateTime.now()),
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

      if (user.email != FirebaseAuth.instance.currentUser!.email) {
        await auth.currentUser!.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: auth.currentUser!.email!,
            password: currentPassword,
          ),
        );
        await FirebaseAuth.instance.currentUser!
            .verifyBeforeUpdateEmail(user.email!);
        updates['email'] = user.email;
      }

      if (user.password != null && user.password!.trim().isNotEmpty) {
        await auth.currentUser!.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: auth.currentUser!.email!,
            password: currentPassword,
          ),
        );
        await FirebaseAuth.instance.currentUser!.updatePassword(user.password!);
      }

      String uid = await getCurrentUId();
      await userCollection.doc(uid).update(updates);

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
    return auth.currentUser?.uid != null;
  }

  @override
  Future<Resource> signIn(UserEntity user) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: user.email!, password: user.password!);

      User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        return Resource.success(data: '');
      } else {
        return Resource.failure(errorMessage: 'Credentials not found.');
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        return Resource.failure(errorMessage: 'Credentials not found.');
      } else {
        return Resource.failure(errorMessage: 'Something went wrong');
      }
    }
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Future<Resource> signUp(UserEntity user) async {
    try {
      var authResult = await auth.createUserWithEmailAndPassword(
          email: user.email!, password: user.password!);

      var uid = authResult.user!.uid;

      final CollectionReference userCollection = fireStore.collection('users');

      var userDoc = await userCollection.doc(uid).get();

      if (!userDoc.exists) {
        var newUser = UserModel(
                email: user.email!,
                uid: uid,
                name: user.name!,
                createdAt: Timestamp.fromDate(DateTime.now()),
                updatedAt: Timestamp.fromDate(DateTime.now()),
                profileImageUrl:
                    "https://res.cloudinary.com/dklkwu5fw/image/upload/v1707755056/profile_images/lkidtk25byxho4aljtvc.jpg",
                bannerImageUrl:
                    "https://res.cloudinary.com/dklkwu5fw/image/upload/v1707755095/banner_images/f9j4mav0zlqrj51u9bg5.jpg")
            .toDocument();
        await userCollection.doc(uid).set(newUser);
        return Resource.success(data: '');
      } else {
        return Resource.failure(errorMessage: "Email Id Already Exists");
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        String errorMessage = e.toString().replaceAll(RegExp(r'\[.*\]'), '');
        return Resource.failure(errorMessage: errorMessage.trim());
      } else {
        return Resource.failure(errorMessage: "Something went wrong");
      }
    }
  }
}
