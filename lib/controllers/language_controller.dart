// lib/controllers/language_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  // ✅ تعريف المتغيرات الصحيحة
  final _storageKey = 'app_language';
  final _box = GetStorage();

  // اللغة الافتراضية عند أول تشغيل
  static const startLocale = Locale('en', 'US');
  static const fallbackLocale = Locale('ar', 'SA');

  // جلب اللغة المحفوظة، أو استخدام اللغة الافتراضية
  Locale get initialLocale {
    // ✅ استخدام _box و _storageKey مباشرة هنا
    final langCode = _box.read<String>(_storageKey);
    if (langCode != null) {
      if (langCode == 'ar') return fallbackLocale;
    }
    // في جميع الحالات الأخرى، استخدم الإنجليزية
    return startLocale;
  }

  // خاصية لمعرفة ما إذا كانت اللغة الحالية هي الإنجليزية
  bool get isEnglish => Get.locale?.languageCode == 'en';

  @override
  void onInit() {
    super.onInit();
    // تعيين اللغة عند بدء تشغيل المراقب
    Get.updateLocale(initialLocale);
  }

  /// يغير اللغة ويحفظ الاختيار
  void toggleLanguage() {
    final newLocale = isEnglish ? fallbackLocale : startLocale;

    // 1. تحديث لغة التطبيق
    Get.updateLocale(newLocale);

    // 2. حفظ الاختيار الجديد في التخزين
    // ✅ استخدام _box و _storageKey مباشرة هنا
    _box.write(_storageKey, newLocale.languageCode);
  }
}
