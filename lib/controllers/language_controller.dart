import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final _storageKey = 'app_language';
  final _box = GetStorage();

  static const startLocale = Locale('en', 'US');
  static const fallbackLocale = Locale('ar', 'SA');

  Locale get initialLocale {
    final langCode = _box.read<String>(_storageKey);
    if (langCode != null) {
      if (langCode == 'ar') return fallbackLocale;
    }
    return startLocale;
  }

  bool get isEnglish => Get.locale?.languageCode == 'en';

  @override
  void onInit() {
    super.onInit();
    Get.updateLocale(initialLocale);
  }

  void toggleLanguage() {
    final newLocale = isEnglish ? fallbackLocale : startLocale;

    Get.updateLocale(newLocale);

    _box.write(_storageKey, newLocale.languageCode);
  }
}
