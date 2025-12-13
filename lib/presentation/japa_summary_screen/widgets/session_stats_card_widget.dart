import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';

/// Widget displaying session statistics with circular progress ring and mala count
class SessionStatsCardWidget extends StatefulWidget {
  final int totalJapaCount;
  final int malaCount;

  const SessionStatsCardWidget({
    super.key,
    required this.totalJapaCount,
    required this.malaCount,
  });

  @override
  State<SessionStatsCardWidget> createState() => _SessionStatsCardWidgetState();
}

class _SessionStatsCardWidgetState extends State<SessionStatsCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Calculate progress based on mala completion (108 japas per mala)
    final targetMala = ((widget.totalJapaCount / 108).ceil()).toDouble();
    final progress =
        widget.totalJapaCount > 0 ? (widget.totalJapaCount % 108) / 108 : 0.0;

    _progressAnimation = Tween<double>(begin: 0.0, end: progress).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      child: Column(
        children: [
          // Circular progress ring with count
          SizedBox(
            width: 60.w,
            height: 60.w,
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background circle
                    SizedBox(
                      width: 60.w,
                      height: 60.w,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 14,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.grey[200]!,
                        ),
                      ),
                    ),
                    // Progress circle with orange gradient color
                    SizedBox(
                      width: 60.w,
                      height: 60.w,
                      child: CircularProgressIndicator(
                        value: _progressAnimation.value,
                        strokeWidth: 14,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    // Center count and label
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.totalJapaCount.toString(),
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontSize: 56.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Total Japa',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

          SizedBox(height: 4.h),

          // Malas completed section with medal icon
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Medal icon
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'emoji_events',
                    color: theme.colorScheme.primary,
                    size: 32,
                  ),
                ),
                SizedBox(height: 2.h),
                // Malas count
                Text(
                  '${widget.malaCount} Malas Completed',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 1.h),
                // Explanation
                Text(
                  'Each mala = 108 japa',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}