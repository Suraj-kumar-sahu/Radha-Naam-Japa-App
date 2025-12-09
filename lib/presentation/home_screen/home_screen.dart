import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
  // Mock user data
  final String _userName = 'Devotee';
  int _todayCount = 0;
  final int _dailyGoal = 1080; // 10 malas
  bool _isLoading = false;
  bool _isOffline = false;

  // Mock session history data
  final List<Map<String, dynamic>> _sessionHistory = [
    {
      'id': 1,
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'count': 1296,
      'duration': 45,
    },
    {
      'id': 2,
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'count': 1080,
      'duration': 40,
    },
    {
      'id': 3,
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'count': 864,
      'duration': 32,
    },
    {
      'id': 4,
      'date': DateTime.now().subtract(const Duration(days: 4)),
      'count': 1512,
      'duration': 55,
    },
    {
      'id': 5,
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'count': 1080,
      'duration': 42,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadTodayData();
  }

  Future<void> _loadTodayData() async {
    setState(() => _isLoading = true);

    // Simulate loading today's data
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _todayCount = 0; // Reset for new day
      _isLoading = false;
    });
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

  void _startJapaSession() {
    Navigator.pushNamed(context, '/counting-screen');
  }

  void _startKidsMode() {
    Navigator.pushNamed(context, '/counting-screen',
        arguments: {'kidsMode': true});
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
}
