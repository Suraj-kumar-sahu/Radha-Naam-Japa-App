import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './widgets/action_buttons_widget.dart';
import './widgets/congratulations_header_widget.dart';
import './widgets/time_period_card_widget.dart';
import './widgets/total_japa_count_widget.dart';

/// My Ranking Modal - Displays personal leaderboard statistics
class MyRankingModal extends StatefulWidget {
  const MyRankingModal({super.key});

  @override
  State<MyRankingModal> createState() => _MyRankingModalState();
}

class _MyRankingModalState extends State<MyRankingModal> {
  // Real user data
  Map<String, dynamic> _userData = {
    'userName': 'Devotee',
    'totalCount': 0,
    'todayRank': 1,
    'todayCount': 0,
    'todayChange': null,
    'weekRank': 1,
    'weekCount': 0,
    'weekChange': null,
    'allTimeRank': 1,
    'allTimeCount': 0,
    'allTimeChange': null,
  };

  // Preference key
  static const String _prefsSessionHistoryKey = 'japa_session_history';

  // Session history stored as list of maps:
  // { 'id': int, 'date': DateTime, 'count': int, 'duration': String }
  final List<Map<String, dynamic>> _sessionHistory = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Get current user from Firebase Auth
    final User? currentUser = FirebaseAuth.instance.currentUser;

    // Load session history
    await _loadFromPrefs();

    // Calculate user statistics
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final weekStart = todayStart.subtract(Duration(days: now.weekday - 1));

    int todayCount = 0;
    int weekCount = 0;
    int allTimeCount = 0;

    for (final session in _sessionHistory) {
      final sessionDate = session['date'] is DateTime
          ? session['date'] as DateTime
          : DateTime.tryParse(session['date'].toString()) ?? DateTime.now();
      final count = session['count'] is int
          ? session['count'] as int
          : int.tryParse(session['count'].toString()) ?? 0;

      allTimeCount += count;

      if (sessionDate.isAfter(todayStart.subtract(const Duration(seconds: 1)))) {
        todayCount += count;
      }

      if (sessionDate.isAfter(weekStart.subtract(const Duration(seconds: 1)))) {
        weekCount += count;
      }
    }

    // Calculate rankings (simplified - in a real app, this would compare with other users)
    // For now, we'll assume the user is ranked based on their counts
    final todayRank = todayCount > 0 ? 1 : 1; // Simplified ranking
    final weekRank = weekCount > 0 ? 1 : 1;
    final allTimeRank = allTimeCount > 0 ? 1 : 1;

    setState(() {
      _userData = {
        'userName': currentUser?.displayName ?? 'Devotee',
        'totalCount': allTimeCount,
        'todayRank': todayRank,
        'todayCount': todayCount,
        'todayChange': null, // Would need historical data to calculate change
        'weekRank': weekRank,
        'weekCount': weekCount,
        'weekChange': null,
        'allTimeRank': allTimeRank,
        'allTimeCount': allTimeCount,
        'allTimeChange': null,
      };
    });
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? sessionHistoryJson = prefs.getString(_prefsSessionHistoryKey);
      if (sessionHistoryJson != null) {
        final List<dynamic> decoded = json.decode(sessionHistoryJson);
        _sessionHistory.clear();
        _sessionHistory.addAll(decoded.map((item) => Map<String, dynamic>.from(item)));
      }
    } catch (e) {
      // Handle error silently or show a message
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag indicator
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 10.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3D3D3D) : const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Congratulations header
          CongrulationsHeaderWidget(
            userName: _userData['userName'] as String,
          ),
          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Total japa count
                  TotalJapaCountWidget(
                    totalCount: _userData['totalCount'] as int,
                  ),
                  // Divider
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark
                          ? const Color(0x1FFFFFFF)
                          : const Color(0x1F000000),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  // Time period cards
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Today card
                        TimePeriodCardWidget(
                          period: 'Today',
                          rank: _userData['todayRank'] as int,
                          count: _userData['todayCount'] as int,
                          percentageChange: _userData['todayChange'] as double?,
                          index: 0,
                        ),
                        SizedBox(height: 2.h),
                        // This Week card
                        TimePeriodCardWidget(
                          period: 'This Week',
                          rank: _userData['weekRank'] as int,
                          count: _userData['weekCount'] as int,
                          percentageChange: _userData['weekChange'] as double?,
                          index: 1,
                        ),
                        SizedBox(height: 2.h),
                        // All Time card
                        TimePeriodCardWidget(
                          period: 'All Time',
                          rank: _userData['allTimeRank'] as int,
                          count: _userData['allTimeCount'] as int,
                          percentageChange:
                              _userData['allTimeChange'] as double?,
                          index: 2,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  // Action buttons
                  ActionButtonsWidget(
                    onClose: () => Navigator.of(context).pop(),
                    rankingData: _userData,
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper function to show the modal
void showMyRankingModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => const MyRankingModal(),
    ),
  );
}
