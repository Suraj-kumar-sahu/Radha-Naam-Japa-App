import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/japa_summary_screen/japa_summary_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/counting_screen/counting_screen.dart';
import '../presentation/save_confirmation_modal/save_confirmation_modal.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/app_settings_screen/app_settings_screen.dart';
import '../presentation/notification_screen/notification_screen.dart';
import '../presentation/statistics_screen/statistics_screen.dart';
import '../presentation/leaderboard_screen/leaderboard_screen.dart';
import '../presentation/my_ranking_modal/my_ranking_modal.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String japaSummary = '/japa-summary-screen';
  static const String login = '/login-screen';
  static const String home = '/home-screen';
  static const String counting = '/counting-screen';
  static const String saveConfirmationModal = '/save-confirmation-modal';
  static const String settings = '/settings-screen';
  static const String profile = '/profile-screen';
  static const String appSettings = '/app-settings-screen';
  static const String notification = '/notification-screen';
  static const String statistics = '/statistics-screen';
  static const String leaderboard = '/leaderboard-screen';
  static const String myRankingModal = '/my-ranking-modal';

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
    statistics: (context) => const StatisticsScreen(),
    leaderboard: (context) => const LeaderboardScreen(),
    myRankingModal: (context) => const MyRankingModal(),
    settings: (context) => const SettingsScreen(),
    profile: (context) => const ProfileScreen(),
    appSettings: (context) => const AppSettingsScreen(),
    notification: (context) => const NotificationScreen(),
  };
}
