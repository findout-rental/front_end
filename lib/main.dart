// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // ✅ استيراد جديد
import 'package:project/bindings/initial_binding.dart';
import 'package:project/controllers/language_controller.dart';
import 'package:project/core/localization/app_translations.dart'; // ✅ استيراد جديد
import 'package:project/core/routing/app_router.dart';
import 'package:project/core/theme/app_theme.dart';

void main() async {
  // ✅ تحويلها إلى async
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // ✅ تهيئة GetStorage
  InitialBinding().dependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Real Estate App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      // ✅ --- إضافات الترجمة ---
      translations: AppTranslations(),
      locale: LanguageController.startLocale,
      fallbackLocale: LanguageController.fallbackLocale,
      // -------------------------
      initialRoute: AppRouter.onboarding,
      getPages: AppRouter.routes,
      // لم نعد بحاجة لـ initialBinding هنا لأنه تم استدعاؤه في main
    );
  }
}
