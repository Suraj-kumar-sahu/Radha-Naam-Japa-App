import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/japa_summary_screen/japa_summary_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/counting_screen/counting_screen.dart';
import '../presentation/save_confirmation_modal/save_confirmation_modal.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String japaSummary = '/japa-summary-screen';
  static const String login = '/login-screen';
  static const String home = '/home-screen';
  static const String counting = '/counting-screen';
  static const String saveConfirmationModal = '/save-confirmation-modal';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    japaSummary: (context) => const JapaSummaryScreen(),
    login: (context) => const LoginScreen(),
    home: (context) => const HomeScreen(),
    counting: (context) => const CountingScreen(),
    saveConfirmationModal: (context) => SaveConfirmationModal(
      sessionCount: 0,
      onConfirm: () {},
    ),
    // TODO: Add your other routes here
  };
}