import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
        width: 70.w,
        height: 70.w,
        constraints: BoxConstraints(
          maxWidth: 300,
          maxHeight: 300,
        ),
        child: CircularPercentIndicator(
          radius: 35.w > 150 ? 150 : 35.w,
          lineWidth: 12.0,
          percent: progressPercent,
          center: _buildCenterContent(theme, malas, currentMalaProgress),
          progressColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
          animationDuration: 300,
          curve: Curves.easeInOut,
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
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 1.h),

        // Mala count
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$malas Malas',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 2.h),

        // Tap instruction
        Text(
          'Tap anywhere to count',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
