import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/inspirational_quote_widget.dart';
import './widgets/session_stats_card_widget.dart';

/// Japa Summary Screen - Celebrates completed sessions with progress visualization
class JapaSummaryScreen extends StatefulWidget {
  const JapaSummaryScreen({super.key});

  @override
  State<JapaSummaryScreen> createState() => _JapaSummaryScreenState();
}

class _JapaSummaryScreenState extends State<JapaSummaryScreen> {
  final int _currentIndex = 0; // For bottom bar, fixed to home or something
  // Session data from navigation arguments
  int _totalJapaCount = 0;
  int _malaCount = 0;

  // Inspirational quotes pool
  final List<Map<String, String>> _quotes = [
    {
      'quote': "Radha's love rules Krishna's heart.",
      'author': 'Swami Prabhupadananda'
    },
    {
      'quote':
          'The name of Radha is the essence of all mantras. Chanting it purifies the heart and brings divine love.',
      'author': 'Ancient Vedic Wisdom'
    },
    {
      'quote':
          'In every repetition of the divine name, we draw closer to the supreme consciousness.',
      'author': 'Spiritual Masters'
    },
    {
      'quote':
          'The path of devotion is paved with the sacred syllables of the divine name.',
      'author': 'Bhakti Tradition'
    },
    {
      'quote':
          'Through consistent practice, the divine name becomes our constant companion.',
      'author': 'Yoga Sutras'
    },
  ];

  late Map<String, String> _currentQuote;

  @override
  void initState() {
    super.initState();
    // Select quote with preference to the first one matching screenshot
    _currentQuote = _quotes.first;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Extract navigation arguments
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      setState(() {
        _totalJapaCount = args['totalCount'] ?? 0;
        _malaCount = args['malas'] ?? 0;
      });
    }
  }

  void _handleBackToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                // Header with title and close button
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left icon (meditation symbol)
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'self_improvement',
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                      // Title
                      Text(
                        'Japa Summary',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // Close button
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _handleBackToHome,
                        tooltip: 'Close',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),

                // Circular progress with count - matching screenshot
                SessionStatsCardWidget(
                  totalJapaCount: _totalJapaCount,
                  malaCount: _malaCount,
                ),

                SizedBox(height: 2.h),

                // Inspirational quote - matching screenshot
                InspirationalQuoteWidget(
                  quote: _currentQuote['quote']!,
                  author: _currentQuote['author']!,
                ),

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