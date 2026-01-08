import 'dart:io';
import 'package:dio/dio.dart';
import 'package:project/core/network/api_endpoints.dart';
import 'package:project/core/network/dio_client.dart';

class AuthService {
  final DioClient _dioClient;

  AuthService(this._dioClient);

  Future<Response> login({
    required String mobileNumber,
    required String password,
  }) {
    return _dioClient.post(
      ApiEndpoints.login,
      data: {'mobile_number': mobileNumber, 'password': password},
    );
  }

  Future<Response> sendOtp({required String mobileNumber}) {
    return _dioClient.post(
      ApiEndpoints.sendOtp,
      data: {'mobile_number': mobileNumber},
    );
  }

  // ✅ دالة جديدة للتحقق من ال-OTP
  Future<Response> verifyOtp({
    required String mobileNumber,
    required String otpCode,
  }) {
    return _dioClient.post(
      ApiEndpoints.verifyOtp,
      data: {'mobile_number': mobileNumber, 'otp_code': otpCode},
    );
  }

  // ✅ دالة جديدة لتحديث الملف الشخصي
  Future<Response> updateProfile({
    required String firstName,
    required String lastName,
    File? profileImage, // الصورة اختيارية
  }) async {
    final Map<String, dynamic> data = {
      'first_name': firstName,
      'last_name': lastName,
      // ⚠️ ملاحظة: لارافيل تتوقع PUT، ولكن FormData لا تعمل جيدًا مع PUT
      // لذا سنستخدم POST مع _method spoofing، وهو نمط شائع في لارافيل
      '_method': 'PUT',
    };

    if (profileImage != null) {
      data['personal_photo'] = await MultipartFile.fromFile(
        profileImage.path,
        filename: profileImage.path.split('/').last,
      );
    }

    final formData = FormData.fromMap(data);

    // ✅ نستخدم POST إلى /profile، ولارافيل ستفهمها كـ PUT
    return _dioClient.post(ApiEndpoints.profile, data: formData);
  }

  Future<Response> register({
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String password,
    required String dateOfBirth,
    required String role,
    required File personalPhoto,
    required File idPhoto,
  }) async {
    final formData = FormData.fromMap({
      'first_name': firstName,
      'last_name': lastName,
      'mobile_number': mobileNumber,
      'password': password,
      'password_confirmation': password, // ✅ مهم
      'date_of_birth': dateOfBirth,
      'role': role,
      // 'otp_code': '123456', // ✅ 6 digits
      'personal_photo': await MultipartFile.fromFile(
        personalPhoto.path,
        filename: personalPhoto.path.split('/').last,
      ),
      'id_photo': await MultipartFile.fromFile(
        idPhoto.path,
        filename: idPhoto.path.split('/').last,
      ),
    });

    return _dioClient.post(ApiEndpoints.register, data: formData);
  }

  /// ✅ يرسل طلبًا لإعادة تعيين كلمة المرور (يرسل OTP)
  Future<Response> forgotPassword({required String mobileNumber}) {
    return _dioClient.post(
      ApiEndpoints.forgotPassword,
      data: {'mobile_number': mobileNumber},
    );
  }

  /// ✅ يعيد تعيين كلمة المرور باستخدام الرمز والكلمة الجديدة
  Future<Response> resetPassword({
    required String mobileNumber,
    required String otpCode,
    required String newPassword,
    required String confirmPassword,
  }) {
    return _dioClient.post(
      ApiEndpoints.resetPassword,
      data: {
        'mobile_number': mobileNumber,
        'otp_code': otpCode,
        'password': newPassword,
        'password_confirmation': confirmPassword,
      },
    );
  }
}
