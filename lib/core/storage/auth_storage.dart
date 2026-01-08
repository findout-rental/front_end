import 'package:get_storage/get_storage.dart';

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
}
