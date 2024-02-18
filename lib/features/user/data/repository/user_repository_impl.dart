import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/user/data/model/user_model.dart';
import 'package:alt__wally/features/user/domain/entities/user_entity.dart';
import 'package:alt__wally/features/user/domain/repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Future<Resource> getUpdateUser(UserEntity user) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> isSignIn() async {
    return auth.currentUser?.uid != null;
  }

  @override
  Future<Resource> signIn(UserEntity user) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: user.email!, password: user.password!);
      return Resource.success(data: '');
    } catch (e) {
      return Resource.failure(errorMessage: 'Something Went wrong');
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
      return Resource.failure(errorMessage: "Something went wrong");
    }
  }
}
