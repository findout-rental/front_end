import 'dart:io';

/// أدوار المستخدم داخل التطبيق
enum UserRole {
  tenant,
  owner,
  unknown,
}

class UserModel {
  final String uid;
  final String fullName;
  final String phone;
  final UserRole role;
  final DateTime? dateOfBirth;
  final String? profileImageUrl;

  /// صورة محلية (للاستخدام المؤقت فقط – لا تُخزَّن في السيرفر)
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

  // ===============================
  // FACTORIES
  // ===============================

  /// تحويل JSON القادم من الخادم إلى UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
  UserRole parseRole(String? roleString) {
    switch (roleString) {
      case 'owner':
        return UserRole.owner;
      case 'tenant':
        return UserRole.tenant;
      default:
        return UserRole.unknown;
    }
  }

  String parseFullName(String? first, String? last, String? full) {
    if (full != null && full.isNotEmpty) return full;
    final f = first ?? '';
    final l = last ?? '';
    return '$f $l'.trim();
  }

  return UserModel(
    uid: (json['id'] ?? json['uid'] ?? '').toString(),

    fullName: parseFullName(
      json['first_name']?.toString(),
      json['last_name']?.toString(),
      json['full_name']?.toString(),
    ),

    phone: (json['mobile_number'] ?? json['phone'] ?? '').toString(),

    role: parseRole(json['role']?.toString()),

    profileImageUrl: json['profile_image_url']?.toString(),

    dateOfBirth: DateTime.tryParse(json['date_of_birth']?.toString() ?? ''),

    createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
  );
}


  /// مستخدم وهمي (للتجربة والـ UI)
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

  // ===============================
  // SERIALIZATION (للتحديثات)
  // ===============================
  Map<String, dynamic> toJson() {
    return {
      'id': uid,
      'full_name': fullName,
      'mobile_number': phone,
      'role': role.name,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'profile_image_url': profileImageUrl,
    };
  }

  // ===============================
  // HELPERS (UI-friendly)
  // ===============================
  bool get isTenant => role == UserRole.tenant;
  bool get isOwner => role == UserRole.owner;
}
