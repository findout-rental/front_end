// lib/core/routing/app_router.dart

import 'package:flutter/material.dart';
import 'package:project/data/models/apartment_model.dart' show Apartment;
import 'package:project/data/models/chat_model.dart' show Chat;
import 'package:project/features/apartment/add_apartment/add_apartment_page.dart'
    show AddApartmentPage;
import 'package:project/features/apartment/apartment_detail_page.dart'
    show ApartmentDetailPage;
import 'package:project/features/auth/sign_in_page.dart' show SignInPage;
import 'package:project/features/auth/sign_up_page.dart' show SignUpPage;
import 'package:project/features/booking/booking_page.dart' show BookingPage;
import 'package:project/features/chat/screens/chat_detail_screen.dart'
    show ChatDetailScreen;
import 'package:project/features/chat/screens/chats_screen.dart'
    show ChatsScreen;
import 'package:project/features/home/home_page.dart' show HomePage;
import 'package:project/features/onboarding/onboarding_screen.dart'
    show OnboardingScreen;
import 'package:project/notification/notification_screen.dart'
    show NotificationsScreen;

class AppRouter {
  AppRouter._();

  static const String onboarding = '/';
  static const String signIn = '/signIn';
  static const String signUp = '/signUp';
  static const String home = '/home';
  static const String chats = '/chats';
  static const String chatDetail = '/chatDetail';
  static const String apartmentDetail = '/apartmentDetail';
  static const String booking = '/booking';
  static const String notifications = '/notifications';
  static const String addApartment = '/addApartment';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case signIn:
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case chats:
        return MaterialPageRoute(builder: (_) => const ChatsScreen());
      case notifications:
        return MaterialPageRoute(builder: (_) => NotificationsScreen());

      case addApartment:
        return MaterialPageRoute(builder: (_) => const AddApartmentPage());

      case chatDetail:
        final arguments = settings.arguments;
        if (arguments is Chat) {
          return MaterialPageRoute(
            builder: (_) => ChatDetailScreen(chat: arguments),
          );
        }
        return _errorRoute(
          'Invalid arguments for chatDetail. Expected Chat, got ${arguments.runtimeType}',
        );

      case apartmentDetail:
        final arguments = settings.arguments;
        if (arguments is Apartment) {
          return MaterialPageRoute(
            builder: (_) => ApartmentDetailPage(apartment: arguments),
          );
        }
        return _errorRoute(
          'Invalid arguments for apartmentDetail. Expected Apartment, got ${arguments.runtimeType}',
        );
      case booking:
        final arguments = settings.arguments;
        if (arguments is Apartment) {
          return MaterialPageRoute(
            builder: (_) => BookingPage(apartment: arguments),
          );
        }
        return _errorRoute(
          'Invalid arguments for booking route. Expected Apartment, got ${arguments.runtimeType}',
        );

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
            padding: const EdgeInsets.all(16.0),
            child: Text(
              message,
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
