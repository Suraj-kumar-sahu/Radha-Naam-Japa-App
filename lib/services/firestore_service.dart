import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Firestore service for managing user data and leaderboard
class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Collection references
  static const String _usersCollection = 'users';
  static const String _sessionsCollection = 'sessions';

  /// Initialize user profile in Firestore when they first sign in
  static Future<void> initializeUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDoc = _firestore.collection(_usersCollection).doc(user.uid);
    final userSnapshot = await userDoc.get();

    if (!userSnapshot.exists) {
      await userDoc.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName ?? 'Devotee',
        'photoURL': user.photoURL,
        'totalJapaCount': 0,
        'todayCount': 0,
        'weekCount': 0,
        'lastUpdated': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Save a japa session to Firestore
  static Future<void> saveJapaSession({
    required int count,
    required String duration,
    required DateTime timestamp,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final sessionData = {
      'uid': user.uid,
      'count': count,
      'duration': duration,
      'timestamp': timestamp,
      'date': timestamp.toIso8601String(),
    };

    try {
      // Add session to sessions collection
      await _firestore.collection(_sessionsCollection).add(sessionData);
    } catch (e) {
      print('Failed to save session to Firestore: $e');
      // Continue to update totals even if session save fails
    }

    try {
      // Update user totals
      await _updateUserTotals(user.uid);
    } catch (e) {
      print('Failed to update user totals in Firestore: $e');
      // Continue even if totals update fails
    }
  }

  /// Update user totals after saving a session
  static Future<void> _updateUserTotals(String uid) async {
    try {
      final userDoc = _firestore.collection(_usersCollection).doc(uid);
      final sessionsQuery = await _firestore
          .collection(_sessionsCollection)
          .where('uid', isEqualTo: uid)
          .get();

      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final weekStart = todayStart.subtract(Duration(days: now.weekday - 1));

      int totalCount = 0;
      int todayCount = 0;
      int weekCount = 0;

      for (final doc in sessionsQuery.docs) {
        final data = doc.data();
        final count = data['count'] as int? ?? 0;
        final timestamp = DateTime.tryParse(data['date'] ?? '') ?? now;

        totalCount += count;

        if (timestamp.isAfter(todayStart.subtract(const Duration(seconds: 1)))) {
          todayCount += count;
        }

        if (timestamp.isAfter(weekStart.subtract(const Duration(seconds: 1)))) {
          weekCount += count;
        }
      }

      await userDoc.update({
        'totalJapaCount': totalCount,
        'todayCount': todayCount,
        'weekCount': weekCount,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Failed to update user totals: $e');
      // Continue even if totals update fails
    }
  }

  /// Get leaderboard data for a specific time period
  static Future<List<Map<String, dynamic>>> getLeaderboardData({
    required String period, // 'today', 'week', 'allTime'
  }) async {
    Query query = _firestore.collection(_usersCollection);

    // Order by the appropriate count field
    String orderField;
    switch (period) {
      case 'today':
        orderField = 'todayCount';
        break;
      case 'week':
        orderField = 'weekCount';
        break;
      case 'allTime':
      default:
        orderField = 'totalJapaCount';
        break;
    }

    query = query.orderBy(orderField, descending: true).limit(50);

    final snapshot = await query.get();
    final leaderboard = <Map<String, dynamic>>[];

    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final count = data[orderField] as int? ?? 0;

      // Include all users, even with 0 count for the period

      leaderboard.add({
        'uid': data['uid'],
        'name': data['displayName'] ?? 'Devotee',
        'avatar': data['photoURL'] ?? 'https://images.unsplash.com/photo-1619734174708-709be4bd4153',
        'semanticLabel': 'Portrait of ${data['displayName'] ?? 'Devotee'}',
        'japaCount': count,
        'todayCount': data['todayCount'] ?? 0,
        'weekCount': data['weekCount'] ?? 0,
        'allTimeCount': data['totalJapaCount'] ?? 0,
      });
    }

    return leaderboard;
  }

  /// Get current user's ranking data
  static Future<Map<String, dynamic>?> getCurrentUserRanking() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final userDoc = await _firestore.collection(_usersCollection).doc(user.uid).get();
    if (!userDoc.exists) return null;

    final data = userDoc.data()!;
    return {
      'uid': data['uid'],
      'name': data['displayName'] ?? 'Devotee',
      'avatar': data['photoURL'] ?? 'https://images.unsplash.com/photo-1619734174708-709be4bd4153',
      'semanticLabel': 'Portrait of current user',
      'japaCount': data['totalJapaCount'] ?? 0,
      'todayCount': data['todayCount'] ?? 0,
      'weekCount': data['weekCount'] ?? 0,
      'allTimeCount': data['totalJapaCount'] ?? 0,
    };
  }

  /// Migrate existing local data to Firestore (one-time migration)
  static Future<void> migrateLocalDataToFirestore() async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Check if migration already done
    final prefs = await SharedPreferences.getInstance();
    final migrated = prefs.getBool('firestore_migrated_${user.uid}') ?? false;
    if (migrated) return;

    // Get local session history
    final sessionHistoryJson = prefs.getString('japa_session_history');
    if (sessionHistoryJson != null) {
      final sessions = json.decode(sessionHistoryJson) as List<dynamic>;

      // Save each session to Firestore
      for (final session in sessions) {
        final sessionMap = session as Map<String, dynamic>;
        await saveJapaSession(
          count: sessionMap['count'] ?? 0,
          duration: sessionMap['duration'] ?? '00:00:00',
          timestamp: DateTime.tryParse(sessionMap['date'] ?? '') ?? DateTime.now(),
        );
      }

      // Mark as migrated
      await prefs.setBool('firestore_migrated_${user.uid}', true);
    }
  }

  /// Get current user's sessions for statistics
  static Future<List<Map<String, dynamic>>> getCurrentUserSessions() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final query = await _firestore
        .collection(_sessionsCollection)
        .where('uid', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .get();

    return query.docs.map((doc) => doc.data()).toList();
  }

  /// Get user progress data for analytics (grouped by period)
  static Future<Map<String, List<Map<String, dynamic>>>> getUserProgressData({
    required String period, // 'weekly', 'monthly', 'yearly'
  }) async {
    final user = _auth.currentUser;
    if (user == null) return {};

    final sessions = await getCurrentUserSessions();
    final Map<String, List<Map<String, dynamic>>> groupedData = {};

    for (final session in sessions) {
      final timestamp = DateTime.tryParse(session['date'] ?? '') ?? DateTime.now();
      final count = session['count'] as int? ?? 0;
      String key;

      switch (period) {
        case 'weekly':
          final weekStart = timestamp.subtract(Duration(days: timestamp.weekday - 1));
          key = '${weekStart.year}-${weekStart.month.toString().padLeft(2, '0')}-W${weekStart.day.toString().padLeft(2, '0')}';
          break;
        case 'monthly':
          key = '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}';
          break;
        case 'yearly':
          key = timestamp.year.toString();
          break;
        default:
          continue;
      }

      if (!groupedData.containsKey(key)) {
        groupedData[key] = [];
      }
      groupedData[key]!.add({'date': timestamp, 'count': count});
    }

    // Aggregate counts per period
    final aggregatedData = <String, List<Map<String, dynamic>>>{};
    for (final entry in groupedData.entries) {
      final totalCount = entry.value.fold(0, (sum, item) => sum + (item['count'] as int));
      aggregatedData[entry.key] = [{'day': entry.key, 'count': totalCount}];
    }

    return aggregatedData;
  }

  /// Get user calendar data for the specified month
  static Future<Map<DateTime, String>> getUserCalendarData(int year, int month) async {
    final user = _auth.currentUser;
    if (user == null) return {};

    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth = DateTime(year, month + 1, 1).subtract(const Duration(days: 1));

    final query = await _firestore
        .collection(_sessionsCollection)
        .where('uid', isEqualTo: user.uid)
        .where('timestamp', isGreaterThanOrEqualTo: startOfMonth)
        .where('timestamp', isLessThanOrEqualTo: endOfMonth)
        .get();

    final Map<DateTime, int> dailyCounts = {};
    for (final doc in query.docs) {
      final data = doc.data();
      final timestamp = DateTime.tryParse(data['date'] ?? '') ?? DateTime.now();
      final normalizedDate = DateTime(timestamp.year, timestamp.month, timestamp.day);
      final count = data['count'] as int? ?? 0;
      dailyCounts[normalizedDate] = (dailyCounts[normalizedDate] ?? 0) + count;
    }

    final Map<DateTime, String> statusMap = {};
    for (final entry in dailyCounts.entries) {
      if (entry.value > 0) {
        statusMap[entry.key] = 'completed';
      } else {
        statusMap[entry.key] = 'missed';
      }
    }

    return statusMap;
  }
}
