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
      data: {
        'mobile_number': mobileNumber,
        'password': password,
      },
    );
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
  'otp_code': '123456', // ✅ 6 digits
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

}
