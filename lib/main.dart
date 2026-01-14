import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/bindings/initial_binding.dart';
import 'package:project/core/routing/app_router.dart';
import 'package:project/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureWebSockets();
  runApp(const MyApp());
}

Future<void> configureWebSockets() async {
  // TODO: initialize your WebSocket client or service here
  await Future.delayed(Duration.zero);
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
      themeMode: ThemeMode.system, // 👈 لا Obx هنا
      initialRoute: AppRouter.onboarding,
      getPages: AppRouter.routes,
      initialBinding: InitialBinding(), // 👈 هنا التحكم
    );
  }
}
