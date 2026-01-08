// lib/data/models/user_model.dart

import 'dart:io';

enum UserRole {
  tenant,
  owner,
  unknown,
} // ✅ إضافة حالة "غير معروف" كقيمة افتراضية آمنة

class UserModel {
  final String uid;
  final String fullName;
  final String phone;
  final UserRole role;
  final DateTime? dateOfBirth; // ✅ جعله String ليتوافق مع ما يرسله Flutter
  final String? profileImageUrl;
  final File? profileImageFile; // هذا للاستخدام المحلي فقط
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

  /// ✅ دالة Factory لتحويل JSON القادم من الخادم إلى كائن UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // دالة مساعدة لتحويل نص الدور إلى enum
    UserRole parseRole(String? roleString) {
      if (roleString == 'owner') return UserRole.owner;
      if (roleString == 'tenant') return UserRole.tenant;
      return UserRole.unknown;
    }

    // دالة مساعدة لدمج الاسم الأول والأخير
    String parseFullName(String? first, String? last) {
      final f = first ?? '';
      final l = last ?? '';
      return '$f $l'.trim();
    }

    return UserModel(
      // استخدام .toString() للتعامل مع id سواء كان int أو String
      uid: json['id']?.toString() ?? json['uid']?.toString() ?? '',

      // ⚠️ تأكد من أن لارافيل تعيد 'first_name' و 'last_name' أو 'full_name'
      fullName:
          json['full_name'] ??
          parseFullName(json['first_name'], json['last_name']),

      phone: json['mobile_number'] ?? json['phone'] ?? '',

      role: parseRole(json['role']),

      // ⚠️ تأكد من أن لارافيل تعيد 'profile_image_url'
      profileImageUrl: json['profile_image_url'],

      dateOfBirth: json['date_of_birth'],

      // تحويل تاريخ الإنشاء من نص إلى DateTime
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// دالة لإنشاء مستخدم وهمي للاختبار والعرض الأولي
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
