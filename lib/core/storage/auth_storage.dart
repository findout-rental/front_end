import 'package:get_storage/get_storage.dart';
import 'package:project/data/models/user_model.dart';

class AuthStorage {
  static const _tokenKey = 'token';
  static const _userKey = 'user';

  final GetStorage _box = GetStorage();

  // Token
  String? get token => _box.read(_tokenKey);

  void saveToken(String token) {
    _box.write(_tokenKey, token);
  }

  void clearToken() {
    _box.remove(_tokenKey);
  }

  // User (اختياري الآن)
  Map<String, dynamic>? get user => _box.read(_userKey);

  void saveUser(Map<String, dynamic> user) {
    _box.write(_userKey, user);
  }

  void clearUser() {
    _box.remove(_userKey);
  }

  bool get isLoggedIn => token != null;



  UserModel? get userModel {
    final u = user;
    if (u == null) return null;
    return UserModel.fromJson(Map<String, dynamic>.from(u));
  }

  UserRole get role => userModel?.role ?? UserRole.unknown;

  String? get roleString => user?['role']?.toString();
}
