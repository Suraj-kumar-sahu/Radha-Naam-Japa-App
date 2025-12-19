import 'package:flutter/material.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/counting_screen/counting_screen.dart';
import '../presentation/japa_summary_screen/japa_summary_screen.dart';
import '../presentation/statistics_screen/statistics_screen.dart';
import '../presentation/leaderboard_screen/leaderboard_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/notification_screen/notification_screen.dart';
import '../presentation/app_settings_screen/app_settings_screen.dart';
import '../presentation/kids_mode_screen/kids_mode_screen.dart';

class AppRoutes {
  static const String initial = splash;
  static const String home = '/home';
  static const String counting = '/counting';
  static const String japaSummary = '/japa-summary';
  static const String statistics = '/statistics';
  static const String leaderboard = '/leaderboard';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String login = '/login';
  static const String splash = '/splash';
  static const String notification = '/notification';
  static const String appSettings = '/app-settings';
  static const String kidsMode = '/kids-mode';

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const HomeScreen(),
    counting: (context) => const CountingScreen(),
    japaSummary: (context) => const JapaSummaryScreen(),
    statistics: (context) => const StatisticsScreen(),
    leaderboard: (context) => const LeaderboardScreen(),
    profile: (context) => const ProfileScreen(),
    settings: (context) => const SettingsScreen(),
    login: (context) => const LoginScreen(),
    splash: (context) => const SplashScreen(),
    notification: (context) => const NotificationScreen(),
    appSettings: (context) => const AppSettingsScreen(),
    kidsMode: (context) => const KidsModeScreen(),
  };
}
