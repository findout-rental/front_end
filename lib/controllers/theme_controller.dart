import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final RxBool isLightMode = true.obs;

  ThemeMode get themeMode =>
      isLightMode.value ? ThemeMode.light : ThemeMode.dark;

  void toggleTheme(bool isLight) {
    isLightMode.value = isLight;
    Get.changeThemeMode(themeMode);
  }
}