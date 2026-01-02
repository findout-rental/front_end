import 'dart:io';

enum UserRole { tenant, owner }
class UserModel {
  final String uid;

  final String fullName;

  final String phone;

  final UserRole role;

  final DateTime? dateOfBirth;

  final String? profileImageUrl;

  final File? profileImageFile;

  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.fullName,
    required this.phone,
    required this.role,
    required this.createdAt,
    this.dateOfBirth,
    this.profileImageUrl,
    this.profileImageFile,
  });

  factory UserModel.dummy() {
    return UserModel(
      uid: 'dummy-uid-12345',
      fullName: 'فلان الفلاني',
      phone: '+966 55 123 4567',
      role: UserRole.tenant,
      createdAt: DateTime.now(),
      profileImageUrl: 'https://i.pravatar.cc/150?img=53',
    );
  }
}
