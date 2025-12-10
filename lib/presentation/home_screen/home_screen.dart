import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/japa_progress_card_widget.dart';
import './widgets/session_history_widget.dart';

/// Home Screen - Central dashboard for daily japa practice
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Preference key
  static const String _prefsSessionHistoryKey = 'japa_session_history';

  // Mock user data
  final String _userName = 'Devotee';
  int _todayCount = 0;
  final int _dailyGoal = 1080; // 10 malas
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

      setState(() {
        _todayCount = todayTotal;
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

  /// Start a japa session and await the result (session data) when saved.
  Future<void> _startJapaSession() async {
    final result = await Navigator.pushNamed(context, '/counting-screen');

    if (result != null && result is Map<String, dynamic>) {
      await _handleReturnedSession(result);
    }
  }

  /// Start kids mode and await result
  Future<void> _startKidsMode() async {
    final result = await Navigator.pushNamed(
      context,
      '/counting-screen',
      arguments: {'kidsMode': true},
    );

    if (result != null && result is Map<String, dynamic>) {
      await _handleReturnedSession(result);
    }
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

    // Persist the updated session history
    await _saveToPrefs();

    // Optionally open the Japa summary screen to show the session details.
    // We do it here so Home updates first, then shows the summary.
    if (mounted) {
      Navigator.pushNamed(
        context,
        '/japa-summary-screen',
        arguments: session,
      );
    }
  }

  void _viewSessionDetails(Map<String, dynamic> session) {
    Navigator.pushNamed(
      context,
      '/japa-summary-screen',
      arguments: session,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar.standard(
        title: 'Radha Naam Japa',
        actions: [
          if (_isOffline)
            Padding(
              padding: EdgeInsets.only(right: 2.w),
              child: CustomIconWidget(
                iconName: 'cloud_off',
                color: theme.colorScheme.error,
                size: 20,
              ),
            ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'notifications_outlined',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              // Navigate to notifications
            },
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: theme.colorScheme.primary,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting Header
                      GreetingHeaderWidget(userName: _userName),

                      SizedBox(height: 2.h),

                      // Japa Progress Card
                      JapaProgressCardWidget(
                        todayCount: _todayCount,
                        dailyGoal: _dailyGoal,
                      ),

                      SizedBox(height: 3.h),

                      // Action Buttons
                      ActionButtonsWidget(
                        onStartJapa: _startJapaSession,
                        onKidsMode: _startKidsMode,
                      ),

                      SizedBox(height: 4.h),

                      // Session History
                      SessionHistoryWidget(
                        sessions: _sessionHistory,
                        onSessionTap: _viewSessionDetails,
                      ),

                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 0,
        onTap: (index) {
          if (index != 0) {
            // Navigate to other tabs when implemented
            // For now, show coming soon message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  index == 1
                      ? 'Statistics coming soon'
                      : index == 2
                          ? 'Leaderboard coming soon'
                          : 'Settings coming soon',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }

  /// Helper: check whether two DateTimes are on same local calendar day.
  bool _isSameLocalDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
