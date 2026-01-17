class ApiEndpoints {
  ApiEndpoints._();
  static const String baseUrl = 'http://192.168.1.105:8000/api';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String ratings = '/ratings';
  static const String me = '/auth/me';
  static const String favorites = '/favorites';
  static const String profile = '/profile';
  static const String bookings = '/bookings';
  static const String messages = '/messages';
  static const String apartments = '/apartments';
  static const String ownerApartments = '/owner/apartments';
  static const String notifications = '/notifications';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
}
