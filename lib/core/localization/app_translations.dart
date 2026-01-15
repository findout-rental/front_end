// lib/core/localization/app_translations.dart

import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    // =====================================================================
    // 🇺🇸 English Translations
    // =====================================================================
    'en_US': {
      // --- General UI & Navigation ---
      'home': 'Home',
      'favorites': 'Favorites',
      'my_apartments':
          'My Bookings', // Changed from 'My Apartments' for tenants
      'profile': 'Profile',
      'language': 'Language',
      'light_mode': 'Light',
      'dark_mode': 'Dark',
      'search_hint': 'Search for an area, city...',
      'apply': 'Apply',
      'reset': 'Reset',
      'next': 'Next',
      'submit': 'Submit',
      'edit': 'Edit',
      'cancel': 'Cancel',
      'no_internet': 'No internet connection.',
      'error_occurred': 'An unexpected error occurred.',
      'oops': 'Oops!!',

      // --- Onboarding ---
      'onboarding_title_1': 'Choose your perfect place...',
      'onboarding_subtitle_1': 'and let comfort begin with a single tap',
      'onboarding_title_2': 'Reserve instantly',
      'onboarding_subtitle_2': 'manage your bookings anytime & anywhere',
      'get_started': 'Get Started',

      // --- Auth ---
      'sign_in': 'Sign In',
      'sign_up': 'Sign Up',
      'welcome_back': 'Welcome Back!',
      'create_your_account': 'Create Your Account',
      'already_have_account': 'Already have an account? ',
      'dont_have_account': "Don't have an account? ",
      'phone_number': 'Phone Number',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'forgot_password': 'Forgot Password?',
      'first_name': 'First Name',
      'last_name': 'Last Name',
      'date_of_birth': 'Date Of Birth',
      'pending_approval_title': 'Pending Approval',
      'pending_approval_message':
          'Your account has been created successfully.\nPlease wait for admin approval.',
      'back_to_sign_in': 'Back to Sign In',
      'forgot_password_instructions':
          'Enter your phone number to receive a reset code.',
      'send_code': 'Send Code',
      'reset_password': 'Reset Password',
      'otp_code': 'OTP Code',
      'new_password': 'New Password',
      'please_fill_all_required_fields_correctly.':
          'Please fill all required fields correctly.',

      // --- Profile ---
      'edit_profile': 'Edit Profile',
      'settings': 'Settings',
      'logout': 'Logout',
      'save_changes': 'Save Changes',

      // --- Apartments ---
      'add_your_apartment': 'Add Your Apartment',
      'add_apartment': 'Add Apartment',
      'apartment_details': 'Apartment Details',
      'about_this_apartment': 'About This Apartment',
      'features': 'Features',
      'your_rating': 'Your Rating',
      'provided_by': 'Provided by',
      'price': 'Price',
      'book_now': 'Book Now',
      'cancel_booking': 'Cancel Booking',
      'no_apartments_found': 'No apartments found.',
      'filtering': 'Filtering',
      'owner_name_hint': 'Owner name (e.g., Ahmed Mohamed)',
      'ad_title_hint': 'Ad Title (e.g., Luxury flat in Yasmin)',
      'description': 'Description',
      'governorate_hint': 'Governorate (e.g., Riyadh)',
      'city_hint': 'City (e.g., Qassim)',
      'price_per_month_hint': 'Price / month (in SAR)',
      'bedrooms': 'Bedrooms',
      'bathrooms': 'Bathrooms',
      'area_hint': 'Area (m²)',
      'has_balcony': 'Has a balcony',
      'apartment_images': 'Apartment Images',
      'choose_images': 'Choose Images',
      'no_images_selected': 'No images selected yet.',

      // --- Bookings ---
      'confirm_booking': 'Confirm Booking',
      'edit_booking': 'Edit Booking',
      'your_trip': 'Your Trip',
      'dates': 'Dates',
      'price_details': 'Price Details',
      'service_fee': 'Service Fee',
      'total': 'Total',
      'complete_booking_and_pay': 'Complete Booking & Pay',
      'active_booking': 'Active Booking',
      'completed_booking': 'Completed Booking',
      'cancelled_booking': 'Cancelled Booking',
      'no_bookings_in_section': 'No bookings in this section.',
      'confirm_cancellation_title': 'Confirm Cancellation',
      'confirm_cancellation_message':
          'Are you sure you want to cancel this booking?',

      // --- Chat & Notifications ---
      'my_chats': 'My Chats',
      'notifications': 'Notifications',
      'no_notifications_yet': 'No notifications yet',
      'notifications_description':
          'Any notification sent will appear here\nand you can follow up at any time',
      'error': 'Erorr',
    },

    // =====================================================================
    // 🇸🇦 Arabic Translations
    // =====================================================================
    'ar_SA': {
      // --- General UI & Navigation ---
      'home': 'الرئيسية',
      'favorites': 'المفضلة',
      'my_apartments': 'حجوزاتي',
      'profile': 'حسابي',
      'language': 'اللغة',
      'light_mode': 'نهاري',
      'dark_mode': 'ليلي',
      'search_hint': 'ابحث عن منطقة، مدينة...',
      'apply': 'تطبيق',
      'reset': 'إعادة تعيين',
      'next': 'التالي',
      'submit': 'إرسال',
      'edit': 'تعديل',
      'cancel': 'إلغاء',
      'no_internet': 'لا يوجد اتصال بالإنترنت.',
      'error_occurred': 'حدث خطأ غير متوقع.',
      'oops': 'عفوًا!!',

      // --- Onboarding ---
      'onboarding_title_1': 'اختر مكانك المثالي...',
      'onboarding_subtitle_1': 'ودع الراحة تبدأ بنقرة واحدة',
      'onboarding_title_2': 'احجز على الفور',
      'onboarding_subtitle_2': 'وأدر حجوزاتك في أي وقت ومن أي مكان',
      'get_started': 'ابدأ الآن',

      // --- Auth ---
      'sign_in': 'تسجيل الدخول',
      'sign_up': 'إنشاء حساب',
      'welcome_back': 'أهلاً بعودتك!',
      'create_your_account': 'أنشئ حسابك',
      'already_have_account': 'لديك حساب بالفعل؟ ',
      'dont_have_account': 'ليس لديك حساب؟ ',
      'phone_number': 'رقم الهاتف',
      'password': 'كلمة المرور',
      'confirm_password': 'تأكيد كلمة المرور',
      'forgot_password': 'نسيت كلمة المرور؟',
      'first_name': 'الاسم الأول',
      'last_name': 'الاسم الأخير',
      'date_of_birth': 'تاريخ الميلاد',
      'pending_approval_title': 'بانتظار الموافقة',
      'pending_approval_message':
          'تم إنشاء حسابك بنجاح.\nيرجى انتظار موافقة المسؤول.',
      'back_to_sign_in': 'العودة لتسجيل الدخول',
      'forgot_password_instructions':
          'أدخل رقم هاتفك لاستلام رمز إعادة التعيين.',
      'send_code': 'أرسل الرمز',
      'reset_password': 'إعادة تعيين كلمة المرور',
      'otp_code': 'رمز التحقق',
      'new_password': 'كلمة المرور الجديدة',

      // --- Profile ---
      'edit_profile': 'تعديل الملف الشخصي',
      'settings': 'الإعدادات',
      'logout': 'تسجيل الخروج',
      'save_changes': 'حفظ التغييرات',

      // --- Apartments ---
      'add_your_apartment': 'أضف شقتك',
      'add_apartment': 'إضافة شقة',
      'apartment_details': 'تفاصيل الشقة',
      'about_this_apartment': 'عن هذه الشقة',
      'features': 'الميزات',
      'your_rating': 'أضف تقييمك',
      'provided_by': 'مقدمة من',
      'price': 'السعر',
      'book_now': 'احجز الآن',
      'cancel_booking': 'إلغاء الحجز',
      'no_apartments_found': 'لم يتم العثور على شقق.',
      'filtering': 'فلترة',
      'owner_name_hint': 'اسم المالك (مثال: أحمد محمد)',
      'ad_title_hint': 'عنوان الإعلان (مثال: شقة فاخرة بحي الياسمين)',
      'description': 'الوصف',
      'governorate_hint': 'المحافظة (مثال: الرياض)',
      'city_hint': 'المدينة (مثال: القصيم)',
      'price_per_month_hint': 'السعر / شهري (بالريال)',
      'bedrooms': 'غرف النوم',
      'bathrooms': 'الحمّامات',
      'area_hint': 'المساحة (م²)',
      'has_balcony': 'يوجد شرفة',
      'apartment_images': 'صور الشقة',
      'choose_images': 'اختر صورًا',
      'no_images_selected': 'لم يتم اختيار أي صور بعد.',

      // --- Bookings ---
      'confirm_booking': 'تأكيد الحجز',
      'edit_booking': 'تعديل الحجز',
      'your_trip': 'رحلتك',
      'dates': 'التواريخ',
      'price_details': 'تفاصيل السعر',
      'service_fee': 'رسوم الخدمة',
      'total': 'الإجمالي',
      'complete_booking_and_pay': 'إتمام الحجز والدفع',
      'active_booking': 'حجز نشط',
      'completed_booking': 'حجز مكتمل',
      'cancelled_booking': 'حجز ملغي',
      'no_bookings_in_section': 'لا توجد حجوزات في هذا القسم.',
      'confirm_cancellation_title': 'تأكيد الإلغاء',
      'confirm_cancellation_message': 'هل أنت متأكد أنك تريد إلغاء هذا الحجز؟',

      // --- Chat & Notifications ---
      'my_chats': 'محادثاتي',
      'notifications': 'الإشعارات',
      'no_notifications_yet': 'لا توجد إشعارات بعد',
      'notifications_description':
          'أي إشعار سيتم إرساله سيظهر هنا\nويمكنك متابعته في أي وقت',

      'error': 'خطأ',
    },
  };
}
