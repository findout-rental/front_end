import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project/bindings/initial_binding.dart';
import 'package:project/controllers/language_controller.dart';
import 'package:project/core/localization/app_translations.dart';
import 'package:project/core/routing/app_router.dart';
import 'package:project/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  InitialBinding().dependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(
      builder: (controller) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return Directionality(
              textDirection: controller.isEnglish
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              child: child!,
            );
          },
          title: 'Real Estate App',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          translations: AppTranslations(),
          locale: controller.initialLocale,
          fallbackLocale: LanguageController.fallbackLocale,
          initialRoute: AppRouter.onboarding,
          getPages: AppRouter.routes,
        );
      },
    );
  }
}
