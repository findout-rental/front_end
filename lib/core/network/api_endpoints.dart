class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://192.168.1.105:8000/api';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';

  // Profile
  static const String me = '/auth/me';
}
