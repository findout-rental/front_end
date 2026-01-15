import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Models
import 'package:project/data/models/apartment_model.dart';
import 'package:project/data/models/booking_model.dart';
import 'package:project/data/models/chat_model.dart';
import 'package:project/features/auth/forgot_password_page.dart';
import 'package:project/features/auth/reset_password_page.dart';

// Auth
import 'package:project/features/auth/sign_in_page.dart';
import 'package:project/features/auth/sign_up_page.dart';
import 'package:project/features/auth/pending_approval_page.dart';

// Home & Onboarding
import 'package:project/features/home/home_page.dart';
import 'package:project/features/notification/notification_screen.dart';
import 'package:project/features/onboarding/onboarding_screen.dart';

// Chat
import 'package:project/features/chat/screens/chats_screen.dart';
import 'package:project/features/chat/screens/chat_detail_screen.dart';

// Apartment
import 'package:project/features/apartment/apartment_detail_page.dart';
import 'package:project/features/apartment/add_apartment/add_apartment_page.dart';

// Booking & Notifications
import 'package:project/features/booking/booking_page.dart';
import 'package:project/bindings/booking_binding.dart';

// Bindings
import 'package:project/bindings/auth_binding.dart';
import 'package:project/features/profile/presentation/screens/edit_profile_page.dart';

class AppRouter {
  AppRouter._();

  // Route names
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

  // -------------------------------
  // GetX Routes (Navigator 2 style)
  // -------------------------------
  static final routes = [
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(
      name: signIn,
      page: () => const SignInPage(),
      binding: AuthBinding(),
    ),
    GetPage(name: signUp, page: () => const SignUpPage()),
    GetPage(name: pendingApproval, page: () => const PendingApprovalPage()),
    GetPage(name: home, page: () => const HomePage()),
    // GetPage(name: chats, page: () => const ChatsScreen()),
    // GetPage(
    //   name: chatDetail,
    //   page: () => ChatDetailScreen(chat: Get.arguments as Chat),
    // ),
    GetPage(
      name: apartmentDetail,
      page: () => ApartmentDetailPage(apartment: Get.arguments as Apartment),
    ),
    // GetPage(
    //   name: booking,
    //   page: () => BookingPage(apartment: Get.arguments as Apartment),
    // ),
    GetPage(name: addApartment, page: () => const AddApartmentPage()),
    GetPage(name: notifications, page: () => NotificationsScreen()),
    // GetPage(
    //   name: AppRouter.home,
    //   page: () => const HomePage(),
    //   bindings: [AuthBinding(), BookingBinding()],
    // ),
    GetPage(name: editProfile, page: () => const EditProfilePage()),

    GetPage(name: forgotPassword, page: () => const ForgotPasswordPage()),
    GetPage(name: resetPassword, page: () => const ResetPasswordPage()),


    GetPage(
  name: AppRouter.booking,
  page: () {
    // ✅ استخراج المعاملات
    final arguments = Get.arguments as Map<String, dynamic>;
    final apartment = arguments['apartment'] as Apartment;
    final booking = arguments['booking'] as BookingModel?; // قد يكون null
    
    return BookingPage(
      apartment: apartment,
      existingBooking: booking,
    );
  },
),
  ];

  // --------------------------------
  // Legacy Navigator (MaterialApp)
  // --------------------------------
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case signIn:
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case pendingApproval:
        return MaterialPageRoute(builder: (_) => const PendingApprovalPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      // case chats:
      //   return MaterialPageRoute(builder: (_) => const ChatsScreen());
      case notifications:
        return MaterialPageRoute(builder: (_) => NotificationsScreen());
      case addApartment:
        return MaterialPageRoute(builder: (_) => const AddApartmentPage());

      // case chatDetail:
      //   final args = settings.arguments;
      //   if (args is Chat) {
      //     return MaterialPageRoute(
      //       builder: (_) => ChatDetailScreen(chat: args),
      //     );
      //   }
        // return _errorRoute('Chat expected, got ${args.runtimeType}');

      case apartmentDetail:
        final args = settings.arguments;
        if (args is Apartment) {
          return MaterialPageRoute(
            builder: (_) => ApartmentDetailPage(apartment: args),
          );
        }
        return _errorRoute('Apartment expected, got ${args.runtimeType}');

      case booking:
        final args = settings.arguments;
        if (args is Apartment) {
          return MaterialPageRoute(
            builder: (_) => BookingPage(apartment: args),
          );
        }
        return _errorRoute('Apartment expected, got ${args.runtimeType}');

      default:
        return _errorRoute('No route defined for ${settings.name}');
    }
  }

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
