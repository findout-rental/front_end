import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/bindings/otp_binding.dart';

// Models
import 'package:project/data/models/apartment_model.dart';
import 'package:project/data/models/booking_model.dart'; // From HEAD
import 'package:project/data/models/chat_model.dart'; // From OTP

// Auth
import 'package:project/features/auth/forgot_password_page.dart';
import 'package:project/features/auth/reset_password_page.dart';
import 'package:project/features/auth/otp_page.dart'; // From OTP
import 'package:project/features/auth/sign_in_page.dart';
import 'package:project/features/auth/sign_up_page.dart';
import 'package:project/features/auth/pending_approval_page.dart';

// Home & Onboarding
import 'package:project/features/home/home_page.dart';
import 'package:project/features/onboarding/onboarding_screen.dart';

// Chat
// import 'package:project/features/chat/chats_screen.dart'; // Ensure this import exists
// import 'package:project/features/chat/chat_detail_screen.dart'; // Ensure this import exists

// Apartment
import 'package:project/features/apartment/apartment_detail_page.dart';
import 'package:project/features/apartment/add_apartment/add_apartment_page.dart';

// Booking & Notifications
import 'package:project/features/booking/booking_page.dart';
import 'package:project/features/notification/notification_screen.dart'; // From OTP

// Profile
import 'package:project/features/profile/presentation/screens/edit_profile_page.dart';

class AppRouter {
  AppRouter._();
  // ===============================
  // Route names
  // ===============================
  static const String onboarding = '/';
  static const String signIn = '/signIn';
  static const String signUp = '/signUp';
  static const String pendingApproval = '/pendingApproval';
  static const String home = '/home';
  static const String chats = '/chats';
  static const String chatDetail = '/chatDetail';
  static const String apartmentDetail = '/apartmentDetail';
  static const String booking = '/booking';
  static const String notifications = '/notifications';
  static const String addApartment = '/addApartment';
  static const String editProfile = '/editProfile';
  static const String forgotPassword = '/forgotPassword';
  static const String resetPassword = '/resetPassword';
  static const String otp = '/otp'; // From OTP

  // ===============================
  // GetX Routes
  // ===============================
  static final routes = [
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(name: signIn, page: () => const SignInPage()),
    GetPage(name: signUp, page: () => const SignUpPage()),
    GetPage(name: pendingApproval, page: () => const PendingApprovalPage()),
    GetPage(name: home, page: () => const HomePage()),

    // Merged: Activated Chat routes from OTP branch
    // GetPage(name: chats, page: () => const ChatsScreen()),
    // GetPage(
    //   name: chatDetail,
    //   page: () => ChatDetailScreen(chat: Get.arguments as Chat),
    // ),

    GetPage(
      name: apartmentDetail,
      page: () => ApartmentDetailPage(apartment: Get.arguments as Apartment),
    ),

    GetPage(name: addApartment, page: () => const AddApartmentPage()),
    GetPage(name: notifications, page: () => NotificationsScreen()),
    GetPage(name: editProfile, page: () => const EditProfilePage()),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordPage()),
    GetPage(name: resetPassword, page: () => const ResetPasswordPage()),

    // Merged: Kept the new, more complex booking route from HEAD
    GetPage(
      name: AppRouter.booking,
      page: () {
        final arguments = Get.arguments as Map<String, dynamic>;
        final apartment = arguments['apartment'] as Apartment;
        final booking = arguments['booking'] as BookingModel?; // Can be null
        return BookingPage(apartment: apartment, existingBooking: booking);
      },
    ),

    // Merged: Added OTP route from OTP branch
    GetPage(
      name: AppRouter.otp,
      page: () => const OtpPage(),
      binding: OtpBinding(),
    ),
  ];

  // ===============================
  // Legacy Navigator (Optional)
  // ===============================
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return _page(const OnboardingScreen());
      case signIn:
        return _page(const SignInPage());
      case signUp:
        return _page(const SignUpPage());
      case pendingApproval:
        return _page(const PendingApprovalPage());

      // Merged: Kept consistent style from OTP branch
      case home:
        return _page(const HomePage());
      // case chats:
      //   return _page(const ChatsScreen());

      case notifications:
        return _page(NotificationsScreen());
      case addApartment:
        return _page(const AddApartmentPage());

      // Merged: Activated chatDetail from OTP branch
      // case chatDetail:
      //   final args = settings.arguments;
      //   if (args is Chat) {
      //     return _page(ChatDetailScreen(chat: args));
      //   }
      //   return _errorRoute('Chat expected, got ${args.runtimeType}');

      case apartmentDetail:
        final args = settings.arguments;
        if (args is Apartment) {
          return _page(ApartmentDetailPage(apartment: args));
        }
        return _errorRoute('Apartment expected, got ${args.runtimeType}');

      // Note: Legacy booking route might need adjustment based on new GetPage logic
      case booking:
        final args = settings.arguments;
        if (args is Apartment) {
          return _page(BookingPage(apartment: args));
        }
        return _errorRoute(
          'Apartment expected for legacy route, got ${args.runtimeType}',
        );

      default:
        return _errorRoute('No route defined for ${settings.name}');
    }
  }

  static MaterialPageRoute _page(Widget child) =>
      MaterialPageRoute(builder: (_) => child);

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Routing Error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              message,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
