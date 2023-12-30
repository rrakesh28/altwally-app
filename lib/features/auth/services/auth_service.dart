import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/toast.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('name', name);
      prefs.setString('email', email);
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      User? _authUser = FirebaseAuth.instance.currentUser;

      if (_authUser != null) {
        return _authUser;
      }

      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;

      prefs.setString('name', userData?['name'] ?? '');
      prefs.setString('email', email);

      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }
}
