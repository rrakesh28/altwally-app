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
      print('sent');
      print(email);
      return Resource.success(data: '');
    } catch (e) {
      print(e);
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
    print(user);
    try {
      final CollectionReference userCollection = fireStore.collection('users');
      var userDoc = await userCollection.doc(user.uid).get();

      if (userDoc.exists) {
        if (user.email != null && user.email!.isNotEmpty) {
          await auth.currentUser!.verifyBeforeUpdateEmail(user.email!);
        }

        if (user.password != null && user.password!.isNotEmpty) {
          await auth.currentUser!.updatePassword(user.password!);
        }
        await userCollection.doc(user.uid).update({
          'name': user.name,
          'updatedAt': Timestamp.fromDate(DateTime.now()),
          'email': user.email,
        });

        return Resource.success(data: '');
      } else {
        return Resource.failure(errorMessage: "User not found");
      }
    } catch (e) {
      return Resource.failure(errorMessage: "Something went wrong");
    }
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
      print(e);
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          return Resource.failure(errorMessage: "Email Id Already Exists");
        } else {
          return Resource.failure(errorMessage: "Something went wrong");
        }
      } else {
        return Resource.failure(errorMessage: "Something went wrong");
      }
    }
  }
}
