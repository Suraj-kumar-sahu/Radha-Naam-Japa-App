import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../services/japa_storage_service.dart';
import 'widgets/greeting_header_widget.dart';
import 'widgets/japa_progress_card_widget.dart';
import 'widgets/action_buttons_widget.dart';
import 'widgets/spiritual_progress_row.dart';
import 'widgets/daily_insight_cart.dart';
import 'widgets/community_section_widget.dart';
import 'widgets/pro_hook_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Preference keys
  static const String _prefsSessionHistoryKey = 'japa_session_history';
  static const String _prefsDailyGoalKey = 'daily_goal';

  // Mock user data
  final String _userName = 'Devotee';
  int _todayCount = 0;
  int _dailyGoal = 1080; // 10 malas
  int _totalChants = 0;
  int _currentStreak = 0;
  String _currentLevel = 'Bhakta';
  bool _isLoading = false;
  bool _isOffline = false;

  // Session history stored as list of maps:
  // { 'id': int, 'date': DateTime, 'count': int, 'duration': String }
  final List<Map<String, dynamic>> _sessionHistory = [];

  @override
  void initState() {
    super.initState();
    _loadFromPrefs();
  }

  /// Load persisted session history and compute today's count.
  Future<void> _loadFromPrefs() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();

      // Load daily goal
      _dailyGoal = prefs.getInt(_prefsDailyGoalKey) ?? 1080;

      final sessionsJson = prefs.getString(_prefsSessionHistoryKey);
      _sessionHistory.clear();

      if (sessionsJson != null && sessionsJson.isNotEmpty) {
        final List<dynamic> decodedList = jsonDecode(sessionsJson);
        for (final item in decodedList) {
          if (item is Map<String, dynamic>) {
            final id = item['id'] is int ? item['id'] as int : int.tryParse(item['id']?.toString() ?? '') ?? 0;
            final dateStr = item['date']?.toString() ?? '';
            final date = DateTime.tryParse(dateStr) ?? DateTime.now();
            final count = item['count'] is int ? item['count'] as int : int.tryParse(item['count']?.toString() ?? '') ?? 0;
            final duration = item['duration']?.toString() ?? '';

            _sessionHistory.add({
              'id': id,
              'date': date,
              'count': count,
              'duration': duration,
            });
          } else if (item is Map) {
            // fallback for dynamic maps
            final id = item['id'] ?? 0;
            final dateStr = item['date']?.toString() ?? '';
            final date = DateTime.tryParse(dateStr) ?? DateTime.now();
            final count = item['count'] ?? 0;
            final duration = item['duration']?.toString() ?? '';

            _sessionHistory.add({
              'id': id is int ? id : int.tryParse(id.toString()) ?? 0,
              'date': date,
              'count': count is int ? count : int.tryParse(count.toString()) ?? 0,
              'duration': duration,
            });
          }
        }
      } else {
        // If no persisted sessions, populate sample history (optional)
        _sessionHistory.addAll([
          {
            'id': 1,
            'date': DateTime.now().subtract(const Duration(days: 1)),
            'count': 1296,
            'duration': '00:45:00',
          },
          {
            'id': 2,
            'date': DateTime.now().subtract(const Duration(days: 2)),
            'count': 1080,
            'duration': '00:40:00',
          },
          {
            'id': 3,
            'date': DateTime.now().subtract(const Duration(days: 3)),
            'count': 864,
            'duration': '00:32:00',
          },
          {
            'id': 4,
            'date': DateTime.now().subtract(const Duration(days: 4)),
            'count': 1512,
            'duration': '00:55:00',
          },
          {
            'id': 5,
            'date': DateTime.now().subtract(const Duration(days: 5)),
            'count': 1080,
            'duration': '00:42:00',
          },
        ]);
      }

      // Compute today's count by summing sessions whose date is today (local)
      final now = DateTime.now();
      final todayTotal = _sessionHistory.fold<int>(0, (acc, s) {
        final DateTime dt = s['date'] is DateTime ? s['date'] as DateTime : DateTime.tryParse(s['date'].toString()) ?? DateTime.now();
        if (_isSameLocalDay(dt, now)) {
          return acc + (s['count'] is int ? s['count'] as int : int.tryParse(s['count'].toString()) ?? 0);
        }
        return acc;
      });

      // Load total chants from JapaStorageService
      final totalChants = await JapaStorageService.getTotalJaps();

      // Compute current streak
      final currentStreak = _calculateCurrentStreak();

      // Determine current level based on total chants
      final currentLevel = _getLevelFromTotalChants(totalChants);

      setState(() {
        _todayCount = todayTotal;
        _totalChants = totalChants;
        _currentStreak = currentStreak;
        _currentLevel = currentLevel;
        _isLoading = false;
      });
    } catch (e) {
      // On error, fall back to empty state
      debugPrint('Failed to load sessions from prefs: $e');
      setState(() {
        _todayCount = 0;
        _isLoading = false;
      });
    }
  }

  /// Persist current session history to SharedPreferences
  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert session history to JSON-serializable list
      final List<Map<String, dynamic>> serializable = _sessionHistory.map((s) {
        final DateTime date = s['date'] is DateTime ? s['date'] as DateTime : DateTime.tryParse(s['date'].toString()) ?? DateTime.now();
        return {
          'id': s['id'] ?? 0,
          'date': date.toIso8601String(),
          'count': s['count'] ?? 0,
          'duration': s['duration']?.toString() ?? '',
        };
      }).toList();

      final encoded = jsonEncode(serializable);
      await prefs.setString(_prefsSessionHistoryKey, encoded);
    } catch (e) {
      debugPrint('Failed to save sessions to prefs: $e');
    }
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);

    // Simulate cloud sync
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _isOffline = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Data synced successfully'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Start a japa session and refresh data when returning
  Future<void> _startJapaSession() async {
    await Navigator.pushNamed(context, AppRoutes.counting);
    // Refresh data when returning from counting screen
    await _loadFromPrefs();
  }

  /// Start kids mode and refresh data when returning
  Future<void> _startKidsMode() async {
    await Navigator.pushNamed(
      context,
      AppRoutes.counting,
      arguments: {'kidsMode': true},
    );
    // Refresh data when returning from counting screen
    await _loadFromPrefs();
  }

  /// Centralized handler for session data returned from CountingScreen
  Future<void> _handleReturnedSession(Map<String, dynamic> session) async {
    // Expecting keys: 'totalCount', 'malas', 'remainingJapas', 'duration', 'timestamp'
    final dynamic totalCountRaw = session['totalCount'];
    final int totalCount = (totalCountRaw is int)
        ? totalCountRaw
        : int.tryParse(totalCountRaw?.toString() ?? '') ?? 0;

    final String timestampStr = session['timestamp']?.toString() ?? '';
    final DateTime date = DateTime.tryParse(timestampStr) ?? DateTime.now();
    final String duration = session['duration']?.toString() ?? '';

    // Update UI and persisted state
    setState(() {
      // Add the returned count to today's count.
      // If you prefer to replace instead of add, change this to `_todayCount = totalCount;`
      _todayCount = _todayCount + totalCount;

      // Insert new session at the top of history
      final nextId = (_sessionHistory.isEmpty ? 1 : ((_sessionHistory.first['id'] as int?) ?? 0) + 1);
      _sessionHistory.insert(
        0,
        {
          'id': nextId,
          'date': date,
          'count': totalCount,
          'duration': duration,
        },
      );
    });

    // Recalculate totals after adding new session
    final updatedTotalChants = _sessionHistory.fold<int>(0, (acc, s) {
      return acc + (s['count'] is int ? s['count'] as int : int.tryParse(s['count'].toString()) ?? 0);
    });
    final updatedCurrentStreak = _calculateCurrentStreak();
    final updatedCurrentLevel = _getLevelFromTotalChants(updatedTotalChants);

    setState(() {
      _totalChants = updatedTotalChants;
      _currentStreak = updatedCurrentStreak;
      _currentLevel = updatedCurrentLevel;
    });

    // Persist the updated session history
    await _saveToPrefs();
  }

  void _viewSessionDetails(Map<String, dynamic> session) {
    Navigator.pushNamed(
      context,
      AppRoutes.japaSummary,
      arguments: session,
    );
  }

  /// Handle target change from the progress card
  Future<void> _onTargetChanged(int newTarget) async {
    setState(() {
      _dailyGoal = newTarget;
    });

    // Save the new target to SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_prefsDailyGoalKey, newTarget);
    } catch (e) {
      debugPrint('Failed to save daily goal: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(
        variant: AppBarVariant.transparent,
        height: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // 🌟 COSMIC BACKGROUND
        decoration: const BoxDecoration(
          gradient: AppTheme.cosmicNebulaGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.goldRadiance,
                  ),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 1.h),

                      // 1. SACRED HEADER
                      const GreetingHeaderWidget(),
                      SizedBox(height: 2.h),

                      // 2. TODAY'S NAAM JAPA CARD
                      Center(
                        child: JapaProgressCardWidget(
                          todayCount: _todayCount,
                          dailyGoal: _dailyGoal,
                          onTargetChanged: _onTargetChanged,
                        ),
                      ),
                      SizedBox(height: 3.h),

                      // 3. PRIMARY CTA & 4. GAME MODE
                      ActionButtonsWidget(
                        onStartJapa: _startJapaSession,
                        onKidsMode: _startKidsMode,
                      ),
                      SizedBox(height: 3.h),

                      // 5. SPIRITUAL PROGRESS ROW
                      SpiritualProgressRow(
                        currentStreak: _currentStreak,
                        totalChants: _totalChants,
                        currentLevel: _currentLevel,
                      ),
                      SizedBox(height: 3.h),

                      // 6. DAILY AI INSIGHT CARD
                      const DailyInsightCard(),
                      SizedBox(height: 3.h),

                      // 7. GROUPS & 8. LEADERBOARD PREVIEW
                      const CommunitySectionWidget(),
                      SizedBox(height: 3.h),

                      // 9. SUBSCRIPTION / PRO HOOK
                      const ProHookCard(),

                      // Bottom padding for navigation bar
                      SizedBox(height: 12.h),
                    ],
                  ),
                ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 0,
        onTap: (index) {
          if (index != 0) {
            final route = CustomBottomBar.getRouteForIndex(index);
            Navigator.pushReplacementNamed(context, route);
          }
        },
      ),
    );
  }

  /// Helper: check whether two DateTimes are on same local calendar day.
  bool _isSameLocalDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Calculate the current streak of consecutive days with japa sessions
  int _calculateCurrentStreak() {
    if (_sessionHistory.isEmpty) return 0;

    // Sort sessions by date (most recent first)
    final sortedSessions = List<Map<String, dynamic>>.from(_sessionHistory)
      ..sort((a, b) {
        final dateA = a['date'] is DateTime ? a['date'] as DateTime : DateTime.tryParse(a['date'].toString()) ?? DateTime.now();
        final dateB = b['date'] is DateTime ? b['date'] as DateTime : DateTime.tryParse(b['date'].toString()) ?? DateTime.now();
        return dateB.compareTo(dateA);
      });

    // Get unique dates with sessions
    final sessionDates = <DateTime>{};
    for (final session in sortedSessions) {
      final date = session['date'] is DateTime ? session['date'] as DateTime : DateTime.tryParse(session['date'].toString()) ?? DateTime.now();
      sessionDates.add(DateTime(date.year, date.month, date.day));
    }

    final uniqueDates = sessionDates.toList()..sort((a, b) => b.compareTo(a));

    if (uniqueDates.isEmpty) return 0;

    int streak = 0;
    DateTime currentDate = DateTime.now();
    currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);

    // Check if today has a session
    if (!uniqueDates.contains(currentDate)) {
      // If no session today, check yesterday
      currentDate = currentDate.subtract(const Duration(days: 1));
      if (!uniqueDates.contains(currentDate)) {
        return 0; // No recent session
      }
    }

    // Count consecutive days
    for (int i = 0; i < uniqueDates.length; i++) {
      final expectedDate = currentDate.subtract(Duration(days: i));
      if (uniqueDates.contains(expectedDate)) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  /// Get the spiritual level based on total chants
  String _getLevelFromTotalChants(int totalChants) {
    if (totalChants >= 1000000) return 'Mahabhakta'; // 1M+
    if (totalChants >= 500000) return 'Paramabhakta'; // 500k+
    if (totalChants >= 250000) return 'Uttamabhakta'; // 250k+
    if (totalChants >= 100000) return 'Madhyamabhakta'; // 100k+
    if (totalChants >= 50000) return 'Kanisthabhakta'; // 50k+
    if (totalChants >= 25000) return 'Neophyte'; // 25k+
    if (totalChants >= 10000) return 'Initiate'; // 10k+
    if (totalChants >= 5000) return 'Seeker'; // 5k+
    if (totalChants >= 1000) return 'Bhakta'; // 1k+
    return 'Beginner'; // < 1k
  }
}
