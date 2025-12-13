import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_service.dart';

/// Service for managing Japa counting data persistence
class JapaStorageService {
  static const String _totalJapsKey = 'total_japs';
  static const String _malasCompletedKey = 'malas_completed';
  static const String _showProfileInLeaderboardKey =
      'show_profile_in_leaderboard';

  /// Get total japs count
  static Future<int> getTotalJaps() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalJapsKey) ?? 0;
  }

  /// Get malas completed count
  static Future<int> getMalasCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_malasCompletedKey) ?? 0;
  }

  /// Save japa session data
  static Future<void> saveJapaSession(
    int sessionJaps, {
    String duration = '00:00:00',
    DateTime? timestamp,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Get current totals
    final currentTotal = prefs.getInt(_totalJapsKey) ?? 0;
    final currentMalas = prefs.getInt(_malasCompletedKey) ?? 0;

    // Calculate new totals
    final newTotal = currentTotal + sessionJaps;
    final newMalas = newTotal ~/ 108;

    // Save updated totals
    await prefs.setInt(_totalJapsKey, newTotal);
    await prefs.setInt(_malasCompletedKey, newMalas);

    // Save to Firestore if user is authenticated
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirestoreService.saveJapaSession(
          count: sessionJaps,
          duration: duration,
          timestamp: timestamp ?? DateTime.now(),
        );
      } catch (e) {
        // Silently fail if Firestore save fails - local data is still saved
        print('Failed to save session to Firestore: $e');
      }
    }
  }

  /// Get leaderboard visibility preference
  static Future<bool> getShowProfileInLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showProfileInLeaderboardKey) ?? true;
  }

  /// Set leaderboard visibility preference
  static Future<void> setShowProfileInLeaderboard(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showProfileInLeaderboardKey, value);
  }

  /// Clear daily analytics (called on sign out)
  /// Note: Keeps total japs but clears other temporary data
  static Future<void> clearDailyAnalytics() async {
    final prefs = await SharedPreferences.getInstance();
    // Add keys for daily analytics when they exist
    // For now, this is a placeholder for future daily analytics features
  }

  /// Clear all data (complete reset)
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
