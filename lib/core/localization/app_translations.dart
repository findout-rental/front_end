// lib/core/localization/app_translations.dart

import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    // --- English Translations ---
    'en_US': {
      // General UI
      'home': 'Home',
      'favorites': 'Favorites',
      'my_apartments': 'My Apartments',
      'profile': 'Profile',
      'search_hint': 'Search for an area, city...',
      'language': 'Language',
      'light_mode': 'Light',
      'dark_mode': 'Dark',
      'logout': 'Logout',
      'edit_profile': 'Edit Profile',
      'settings': 'Settings',

      // Auth
      'sign_in': 'Sign In',
      'sign_up': 'Sign Up',
      'welcome_back': 'Welcome Back!',
      'create_your_account': 'Create Your Account',
      'already_have_account': 'Already have an account? ',
    },

    // --- Arabic Translations ---
    'ar_SA': {
      // General UI
      'home': 'الرئيسية',
      'favorites': 'المفضلة',
      'my_apartments': 'شققي',
      'profile': 'حسابي',
      'search_hint': 'ابحث عن منطقة، مدينة...',
      'language': 'اللغة',
      'light_mode': 'نهاري',
      'dark_mode': 'ليلي',
      'logout': 'تسجيل الخروج',
      'edit_profile': 'تعديل الملف الشخصي',
      'settings': 'الإعدادات',

      // Auth
      'sign_in': 'تسجيل الدخول',
      'sign_up': 'إنشاء حساب',
      'welcome_back': 'أهلاً بعودتك!',
      'create_your_account': 'أنشئ حسابك',
      'already_have_account': 'لديك حساب بالفعل؟ ',
    },
  };
}
