import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../services/firestore_service.dart';
import './widgets/my_ranking_button_widget.dart';
import './widgets/podium_display_widget.dart';
import './widgets/time_period_tabs_widget.dart';
import './widgets/user_ranking_list_widget.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  TimePeriod _selectedPeriod = TimePeriod.today;
  bool _isLoading = true;
  bool _isRefreshing = false;
  List<Map<String, dynamic>> _leaderboardData = [];
  Map<String, dynamic>? _currentUserData;

  @override
  void initState() {
    super.initState();
    _loadLeaderboardData();
  }

  Future<void> _loadLeaderboardData() async {
    if (!mounted) return;

    setState(() => _isLoading = true);
    try {
      // Load current user data
      _currentUserData = await FirestoreService.getCurrentUserRanking();

      // Load leaderboard data based on selected period
      final period = _getPeriodString(_selectedPeriod);
      final leaderboard = await FirestoreService.getLeaderboardData(period: period);

      // Update current user data to use the correct count for the selected period
      if (_currentUserData != null) {
        String countField;
        switch (_selectedPeriod) {
          case TimePeriod.today:
            countField = 'todayCount';
            break;
          case TimePeriod.thisWeek:
            countField = 'weekCount';
            break;
          case TimePeriod.allTime:
            countField = 'allTimeCount';
            break;
        }
        _currentUserData!['japaCount'] = _currentUserData![countField];
      }

      // Combine current user with leaderboard if not already included
      final currentUser = FirebaseAuth.instance.currentUser;
      final isCurrentUserInLeaderboard = leaderboard.any((user) =>
          user['uid'] == currentUser?.uid);

      if (!isCurrentUserInLeaderboard && _currentUserData != null && _currentUserData!['japaCount'] > 0) {
        leaderboard.add(_currentUserData!);
      }

      // Sort by japa count
      leaderboard.sort((a, b) => (b['japaCount'] as int).compareTo(a['japaCount'] as int));

      if (mounted) {
        setState(() => _leaderboardData = leaderboard);
      }
    } catch (e) {
      debugPrint('Error loading leaderboard: $e');
      // Show empty state or error message
      if (mounted) {
        setState(() => _leaderboardData = []);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getPeriodString(TimePeriod period) {
    switch (period) {
      case TimePeriod.today:
        return 'today';
      case TimePeriod.thisWeek:
        return 'week';
      case TimePeriod.allTime:
        return 'allTime';
    }
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await _loadLeaderboardData();
    setState(() => _isRefreshing = false);
  }

  void _onPeriodChanged(TimePeriod period) {
    setState(() => _selectedPeriod = period);
    _loadLeaderboardData();
  }

  void _showMyRankingModal() {
    Navigator.pushNamed(context, '/my-ranking-modal');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final topThree = _leaderboardData.take(3).toList();
    final remainingUsers = _leaderboardData.skip(3).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Leaderboard',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF424242),
              size: 24,
            ),
            onPressed: _handleRefresh,
            tooltip: 'Refresh',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: const Color(0xFFFF7A00),
              ),
            )
          : RefreshIndicator(
              onRefresh: _handleRefresh,
              color: const Color(0xFFFF7A00),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFFFF7A00).withValues(alpha: 0.1),
                            theme.scaffoldBackgroundColor,
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          TimePeriodTabsWidget(
                            selectedPeriod: _selectedPeriod,
                            onPeriodChanged: _onPeriodChanged,
                          ),
                          if (_isRefreshing)
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFFFF7A00),
                                ),
                              ),
                            ),
                          PodiumDisplayWidget(topThreeUsers: topThree),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (remainingUsers.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Other Rankings',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    UserRankingListWidget(
                      users: remainingUsers,
                      startRank: 4,
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyRankingButtonWidget(
            onPressed: _showMyRankingModal,
          ),
          CustomBottomBar(
            currentIndex: 2,
            onTap: (index) {
              final routes = ['/home-screen', '/statistics-screen', '/leaderboard-screen', '/settings-screen'];
              if (index >= 0 && index < routes.length) {
                Navigator.pushReplacementNamed(context, routes[index]);
              }
            },
          ),
        ],
      ),
    );
  }
}
