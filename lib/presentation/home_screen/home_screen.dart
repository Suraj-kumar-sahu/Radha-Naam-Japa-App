import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:convert';
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
  int _currentIndex = 0;
  int _todayCount = 0;
  int _dailyGoal = 108;
  int _currentStreak = 7;
  int _totalChants = 15420;
  String _currentLevel = 'Beginner';

  @override
  void initState() {
    super.initState();
    _loadTodayCount();
  }

  Future<void> _loadTodayCount() async {
    final todayCount = await JapaStorageService.getTodayCount();
    setState(() {
      _todayCount = todayCount;
    });
  }

  /// 🌟 CRITICAL FIX: Handle the return from Counting Screen
  Future<void> _handleStartJapa() async {
    // 1. Wait for the session to complete
    final result = await Navigator.pushNamed(context, AppRoutes.counting);

    // 2. Check if data was returned (user saved session)
    if (result != null && result is Map<String, dynamic>) {
      // 3. Update local state (optional, for immediate feedback)
      if (result.containsKey('totalCount')) {
        setState(() {
          _todayCount += (result['totalCount'] as int);
        });
      }

      // 4. Navigate to Summary Screen
      if (mounted) {
        Navigator.pushNamed(
          context,
          AppRoutes.japaSummary,
          arguments: result,
        );
      }
    }
  }

  void _handleTargetChanged(int newTarget) {
    setState(() {
      _dailyGoal = newTarget;
    });
  }

  /// Handle kids mode navigation
  Future<void> _handleKidsMode() async {
    // Navigate to kids mode screen
    final result = await Navigator.pushNamed(context, AppRoutes.kidsMode);

    // Handle the result similar to counting screen
    if (result != null && result is Map<String, dynamic>) {
      if (result.containsKey('totalCount')) {
        setState(() {
          _todayCount += (result['totalCount'] as int);
        });
      }

      if (mounted) {
        Navigator.pushNamed(
          context,
          AppRoutes.japaSummary,
          arguments: result,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(
        height: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppTheme.cosmicNebulaGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.h),
                const GreetingHeaderWidget(),
                SizedBox(height: 2.h),

                JapaProgressCardWidget(
                  todayCount: _todayCount,
                  dailyGoal: _dailyGoal,
                  onTargetChanged: _handleTargetChanged,
                ),

                SizedBox(height: 3.h),

                SpiritualProgressRow(
                  currentStreak: _currentStreak,
                  totalChants: _totalChants,
                  currentLevel: _currentLevel,
                ),

                SizedBox(height: 3.h),

                // 🌟 FIX: Use the handler method here
                ActionButtonsWidget(
                  onStartJapa: _handleStartJapa,
                  onKidsMode: _handleKidsMode,
                ),
                SizedBox(height: 3.h),
                const DailyInsightCard(),
                SizedBox(height: 3.h),
                const CommunitySectionWidget(),
                SizedBox(height: 3.h),
                const ProHookCard(),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar.withNavigation(
        context: context,
        currentIndex: _currentIndex,
      ),
    );
  }
}
