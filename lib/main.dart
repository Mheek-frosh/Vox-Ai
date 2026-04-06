import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/onboarding_screen.dart';
import 'controllers/auth_controller.dart';
import 'controllers/theme_controller.dart';
import 'theme/app_themes.dart';

/// The main entry point for the Vox AI application.
/// It ensures that Flutter bindings are initialized before running the app.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VoxAiApp());
}

/// The root widget of the Vox AI application.
/// 
/// This widget is responsible for setting up the global theme, routing,
/// and initializing core controllers like [ThemeController] and [AuthController].
class VoxAiApp extends StatelessWidget {
  const VoxAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ThemeController
    final themeController = Get.put(ThemeController());
    // Initialize AuthController
    Get.put(AuthController());

    return Obx(
      () => GetMaterialApp(
        title: 'Vox AI',
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: themeController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const SplashScreen()),
          GetPage(name: '/login', page: () => const LoginScreen()),
          GetPage(name: '/register', page: () => const RegisterScreen()),
          GetPage(name: '/dashboard', page: () => DashboardScreen()),
          GetPage(name: '/onboarding', page: () => const OnboardingScreen()),
          GetPage(name: '/settings', page: () => const SettingsScreen()),
          GetPage(name: '/profile', page: () => const ProfileScreen()),
        ],
      ),
    );
  }
}
