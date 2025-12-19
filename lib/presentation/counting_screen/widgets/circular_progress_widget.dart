import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../theme/app_theme.dart';

/// Circular progress indicator showing japa count and mala completion
/// Displays real-time progress with orange gradient styling
class CircularProgressWidget extends StatelessWidget {
  final int currentCount;
  final VoidCallback onTap;

  const CircularProgressWidget({
    super.key,
    required this.currentCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final malas = currentCount ~/ 108;
    final currentMalaProgress = currentCount % 108;
    final progressPercent = currentMalaProgress / 108;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 75.w,
        height: 75.w,
        constraints: BoxConstraints(
          maxWidth: 320,
          maxHeight: 320,
        ),
        child: CircularPercentIndicator(
          radius: 37.5.w > 160 ? 160 : 37.5.w,
          lineWidth: 14.0,
          percent: progressPercent,
          center: _buildCenterContent(theme, malas, currentMalaProgress),
          progressColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
          circularStrokeCap: CircularStrokeCap.round,
          animation: false,
        ),
      ),
    );
  }

  /// Build center content showing progress details
  Widget _buildCenterContent(ThemeData theme, int malas, int currentProgress) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Current mala progress
        Text(
          '$currentProgress / 108',
          style: theme.textTheme.headlineLarge?.copyWith(
            color: AppTheme.glowGold,
            fontWeight: FontWeight.w700,
            fontSize: 28.sp,
            shadows: [
              Shadow(
                color: AppTheme.glowGold.withOpacity(0.6),
                blurRadius: 20,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.5.h),

        // Mala count
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            '$malas Malas',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
            ),
          ),
        ),
        SizedBox(height: 2.5.h),

        // Tap instruction
        Text(
          'Tap anywhere to count',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }
}
