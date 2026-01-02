import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project/data/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;

  UserModel? get user => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  void signUp({
    required String fullName,
    required String phone,
    required UserRole role,
    DateTime? dateOfBirth,
    File? profileImageFile,
  }) {
    _currentUser = UserModel(
      uid: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      phone: phone,
      role: role,
      dateOfBirth: dateOfBirth,
      profileImageFile: profileImageFile,

      profileImageUrl: null,
      createdAt: DateTime.now(),
    );
    notifyListeners();
  }

  void signIn({required String phone, required String password}) {
    _currentUser = UserModel.dummy();
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
