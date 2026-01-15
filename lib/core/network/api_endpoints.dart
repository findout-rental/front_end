class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://192.168.43.158:8000/api';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';

  // Profile
  static const String me = '/auth/me';

  static const String favorites = '/favorites';

  static const String profile = '/profile';
  // Bookings
  static const String bookings = '/bookings';

  static const String messages = '/messages';
  static const String apartments = '/apartments';
  static const String ownerApartments = '/owner/apartments';

  static const String notifications =
      '/notifications'; // ✅ افترض أن هذا هو المسار

  static const String forgotPassword = '/auth/forgot-password'; // يرسل OTP
  static const String resetPassword =
      '/auth/reset-password'; // يعيد تعيين كلمة المرور
}
