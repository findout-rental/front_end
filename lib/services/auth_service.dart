import 'dart:io';
import 'package:dio/dio.dart';
import 'package:project/core/network/api_endpoints.dart';
import 'package:project/core/network/dio_client.dart';

class AuthService {
  final DioClient _dioClient;

  AuthService(this._dioClient);

  // ---------------------------------------------------------------------------
  // LOGIN
  // ---------------------------------------------------------------------------
  Future<Response> login({
    required String mobileNumber,
    required String password,
  }) {
    return _dioClient.post(
      ApiEndpoints.login,
      data: {
        'mobile_number': mobileNumber,
        'password': password,
      },
    );
  }

  // SEND OTP
  Future<Response> sendOtp({
    required String mobileNumber,
  }) {
    return _dioClient.post(
      ApiEndpoints.sendOtp,
      data: {
        'mobile_number': mobileNumber,
      },
    );
  }  // VERIFY OTP
  Future<Response> verifyOtp({
    required String mobileNumber,
    required String otpCode,
  }) {
    return _dioClient.post(
      ApiEndpoints.verifyOtp,
      data: {
        'mobile_number': mobileNumber,
        'otp_code': otpCode,
      },
    );
  }

  // REGISTER (بعد OTP)
  Future<Response> register({
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String password,
    required String dateOfBirth,
    required String role,
    required File personalPhoto,
    required File idPhoto,
    required String otpCode,
  }) async {
    final formData = FormData.fromMap({
      'first_name': firstName,
      'last_name': lastName,
      'mobile_number': mobileNumber,
      'password': password,
      'password_confirmation': password,
      'date_of_birth': dateOfBirth,
      'role': role,
      'otp_code': otpCode,

      // الصور
      'personal_photo': await MultipartFile.fromFile(
        personalPhoto.path,
        filename: personalPhoto.path.split('/').last,
      ),
      'id_photo': await MultipartFile.fromFile(
        idPhoto.path,
        filename: idPhoto.path.split('/').last,
      ),
    });

    return _dioClient.post(
      ApiEndpoints.register,
      data: formData,
    );
  }

  // ---------------------------------------------------------------------------
  // FORGOT / RESET PASSWORD
  // ---------------------------------------------------------------------------
  Future<Response> forgotPassword({
    required String mobileNumber,
  }) {
    return _dioClient.post(
      ApiEndpoints.forgotPassword,
      data: {'mobile_number': mobileNumber},
    );
  }

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

  // ---------------------------------------------------------------------------
  // UPDATE PROFILE
  // ---------------------------------------------------------------------------
  Future<Response> updateProfile({
    required String firstName,
    required String lastName,
    File? profileImage,
  }) async {
    final Map<String, dynamic> data = {
      'first_name': firstName,
      'last_name': lastName,
      '_method': 'PUT', // Laravel method spoofing
    };

    if (profileImage != null) {
      data['personal_photo'] = await MultipartFile.fromFile(
        profileImage.path,
        filename: profileImage.path.split('/').last,
      );
    }

    return _dioClient.post(
      ApiEndpoints.profile,
      data: FormData.fromMap(data),
    );
  }
}
