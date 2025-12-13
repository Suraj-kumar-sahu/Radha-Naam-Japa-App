import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/header_card_widget.dart';
import './widgets/info_card_widget.dart';
import './widgets/japa_calendar_widget.dart';
import './widgets/progress_analytics_widget.dart';

/// Statistics screen with comprehensive japa analytics
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _currentBottomNavIndex = 1; // Statistics tab active
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;

  // Mock total japa count
  final int _totalJapaCount = 86400;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate Firebase sync
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Analytics updated successfully'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _handleShare() {
    // Share functionality placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Share progress feature coming soon'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar.standard(
        title: 'Statistics',
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _handleShare,
            tooltip: 'Share',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: theme.colorScheme.primary,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              HeaderCardWidget(totalJapaCount: _totalJapaCount),
              SizedBox(height: 1.h),
              const InfoCardWidget(),
              SizedBox(height: 2.h),
              const ProgressAnalyticsWidget(),
              SizedBox(height: 2.h),
              const JapaCalendarWidget(),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          if (index != _currentBottomNavIndex) {
            final routes = ['/home-screen', '/statistics-screen', '/leaderboard-screen', '/settings-screen'];
            if (index >= 0 && index < routes.length) {
              Navigator.pushReplacementNamed(context, routes[index]);
            }
          }
        },
      ),
    );
  }
}
