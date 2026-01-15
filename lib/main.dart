// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project/bindings/initial_binding.dart';
import 'package:project/controllers/language_controller.dart';
import 'package:project/core/localization/app_translations.dart';
import 'package:project/core/routing/app_router.dart';
import 'package:project/core/theme/app_theme.dart';

void main() async {
  // التأكد من تهيئة Flutter قبل أي عمليات async
  WidgetsFlutterBinding.ensureInitialized();
  // تهيئة GetStorage لحفظ اختيار اللغة
  await GetStorage.init();
  // تشغيل الـ Bindings مبكرًا لضمان تسجيل جميع المراقبين والخدمات
  InitialBinding().dependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ الطريقة الصحيحة: استخدام GetBuilder لإدارة المراقب
    // GetBuilder سيقوم بـ `Get.find()` داخليًا وبشكل آمن
    return GetBuilder<LanguageController>(
      builder: (controller) {
        // `controller` هنا هو نسخة LanguageController
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,

          // `builder` يسمح لنا بتحديد اتجاه النص بشكل صريح
          // وهو ضروري لضمان أن اتجاه الواجهة يتغير مع اللغة
          builder: (context, child) {
            return Directionality(
              textDirection: controller.isEnglish
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              child: child!,
            );
          },

          title: 'Real Estate App',

          // --- Theme ---
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          // يمكنك ربط وضع المظهر بـ ThemeController هنا إذا أردت
          // themeMode: Get.find<ThemeController>().themeMode,

          // --- Localization ---
          translations: AppTranslations(),
          // اللغة الحالية يتم تحديدها بواسطة GetX بناءً على updateLocale
          // `locale` هنا يحدد اللغة الأولية فقط
          locale: controller.initialLocale,
          fallbackLocale: LanguageController.fallbackLocale,

          // --- Routing ---
          initialRoute: AppRouter.onboarding,
          getPages: AppRouter.routes,
        );
      },
    );
  }
}
