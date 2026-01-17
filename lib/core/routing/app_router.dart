import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/bindings/otp_binding.dart';
import 'package:project/data/models/apartment_model.dart';
import 'package:project/data/models/booking_model.dart';
import 'package:project/features/auth/forgot_password_page.dart';
import 'package:project/features/auth/reset_password_page.dart';
import 'package:project/features/auth/otp_page.dart';
import 'package:project/features/auth/sign_in_page.dart';
import 'package:project/features/auth/sign_up_page.dart';
import 'package:project/features/auth/pending_approval_page.dart';
import 'package:project/features/home/home_page.dart';
import 'package:project/features/onboarding/onboarding_screen.dart';
import 'package:project/features/apartment/apartment_detail_page.dart';
import 'package:project/features/apartment/add_apartment/add_apartment_page.dart';
import 'package:project/features/booking/booking_page.dart';
import 'package:project/features/notification/notification_screen.dart';
import 'package:project/features/profile/presentation/screens/edit_profile_page.dart';

class AppRouter {
  AppRouter._();
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
  static const String otp = '/otp';
  static final routes = [
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(name: signIn, page: () => const SignInPage()),
    GetPage(name: signUp, page: () => const SignUpPage()),
    GetPage(name: pendingApproval, page: () => const PendingApprovalPage()),
    GetPage(name: home, page: () => const HomePage()),
    GetPage(
      name: apartmentDetail,
      page: () => ApartmentDetailPage(apartment: Get.arguments as Apartment),
    ),
    GetPage(name: addApartment, page: () => const AddApartmentPage()),
    GetPage(name: notifications, page: () => NotificationsScreen()),
    GetPage(name: editProfile, page: () => const EditProfilePage()),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordPage()),
    GetPage(name: resetPassword, page: () => const ResetPasswordPage()),
    GetPage(
      name: AppRouter.booking,
      page: () {
        final args = Get.arguments;
        Apartment apartment;
        BookingModel? booking;
        if (args is Apartment) {
          apartment = args;
        } else if (args is Map) {
          final map = Map<String, dynamic>.from(args);
          final aptArg = map['apartment'];
          if (aptArg is Apartment) {
            apartment = aptArg;
          } else if (aptArg is Map) {
            apartment = Apartment.fromJson(Map<String, dynamic>.from(aptArg));
          } else {
            throw ArgumentError(
              'Booking route expected "apartment" as Apartment/Map but got: ${aptArg.runtimeType}',
            );
          }
          final bArg = map['booking'];
          if (bArg is BookingModel) {
            booking = bArg;
          } else if (bArg is Map) {
            booking = BookingModel.fromJson(Map<String, dynamic>.from(bArg));
          } else {
            booking = null;
          }
        } else {
          throw ArgumentError(
            'Booking route expected Apartment or Map but got: ${args.runtimeType}',
          );
        }
        return BookingPage(apartment: apartment, existingBooking: booking);
      },
    ),
    GetPage(
      name: AppRouter.otp,
      page: () => const OtpPage(),
      binding: OtpBinding(),
    ),
  ];
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
      case home:
        return _page(const HomePage());
      case notifications:
        return _page(NotificationsScreen());
      case addApartment:
        return _page(const AddApartmentPage());
      case apartmentDetail:
        final args = settings.arguments;
        if (args is Apartment) {
          return _page(ApartmentDetailPage(apartment: args));
        }
        return _errorRoute('Apartment expected, got ${args.runtimeType}');
      case booking:
        final args = settings.arguments;
        Apartment apartment;
        BookingModel? booking;
        if (args is Apartment) {
          apartment = args;
        } else if (args is Map) {
          final map = Map<String, dynamic>.from(args);
          final aptArg = map['apartment'];
          if (aptArg is Apartment) {
            apartment = aptArg;
          } else if (aptArg is Map) {
            apartment = Apartment.fromJson(Map<String, dynamic>.from(aptArg));
          } else {
            return _errorRoute(
              'Booking expected "apartment" but got ${aptArg.runtimeType}',
            );
          }
          final bArg = map['booking'];
          if (bArg is BookingModel) {
            booking = bArg;
          } else if (bArg is Map) {
            booking = BookingModel.fromJson(Map<String, dynamic>.from(bArg));
          }
        } else {
          return _errorRoute(
            'Apartment/Map expected for booking, got ${args.runtimeType}',
          );
        }
        return _page(
          BookingPage(apartment: apartment, existingBooking: booking),
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
