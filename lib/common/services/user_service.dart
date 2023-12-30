import 'package:alt__wally/common/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static final UserService _instance = UserService._internal();

  factory UserService() {
    return _instance;
  }

  UserService._internal() {
    setAuthUser();
  }

  User? _authUser;

  User? get authUser => _authUser;

  void setAuthUser() async {
    _authUser = FirebaseAuth.instance.currentUser;

    if (_authUser?.displayName != null && _authUser?.displayName != '') {
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name') ?? '';

    if (_authUser != null) {
      String updatedDisplayName = _authUser?.displayName != null
          ? '${_authUser?.displayName} $name'
          : name;

      try {
        await _authUser?.updateDisplayName(updatedDisplayName);

        _authUser = FirebaseAuth.instance.currentUser;
      } catch (e) {
        showToast(message: 'Error: $e');
      }
    }
  }
}
