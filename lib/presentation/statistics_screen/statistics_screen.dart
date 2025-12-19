import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../services/japa_storage_service.dart';
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

class _StatisticsScreenState extends State<StatisticsScreen> with WidgetsBindingObserver {
  final int _currentBottomNavIndex = 1; // Statistics tab active
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;
  bool _isLoading = true;

  // Total japa count from storage
  int _totalJapaCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadTotalJapaCount();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Reload data when app comes back to foreground
      _loadTotalJapaCount();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload data when screen comes back into focus
    _loadTotalJapaCount();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadTotalJapaCount() async {
    final totalCount = await JapaStorageService.getTotalJaps();
    if (mounted) {
      setState(() {
        _totalJapaCount = totalCount;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Reload total japa count from storage
    await _loadTotalJapaCount();

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
          child: _isLoading
              ? SizedBox(
                  height: 80.h,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                )
              : Column(
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
      bottomNavigationBar: CustomBottomBar.withNavigation(
        context: context,
        currentIndex: _currentBottomNavIndex,
      ),
    );
  }
}
