import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sizer/sizer.dart';


/// Main japa progress card showing today's count and circular progress
class JapaProgressCardWidget extends StatelessWidget {
  final int todayCount;
  final int dailyGoal;

  const JapaProgressCardWidget({
    super.key,
    required this.todayCount,
    this.dailyGoal = 1080, // Default: 10 malas
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress =
        dailyGoal > 0 ? (todayCount / dailyGoal).clamp(0.0, 1.0) : 0.0;
    final malaCount = (todayCount / 108).floor();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Today\'s Japa',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3.h),
          CircularPercentIndicator(
            radius: 30.w,
            lineWidth: 3.w,
            percent: progress,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  todayCount.toString(),
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 48,
                  ),
                ),
                Text(
                  'Japa Count',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            progressColor: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animationDuration: 800,
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                'Malas',
                malaCount.toString(),
              ),
              Container(
                height: 5.h,
                width: 1,
                color: theme.colorScheme.outline,
              ),
              _buildStatItem(
                context,
                'Goal',
                '$dailyGoal',
              ),
              Container(
                height: 5.h,
                width: 1,
                color: theme.colorScheme.outline,
              ),
              _buildStatItem(
                context,
                'Progress',
                '${(progress * 100).toInt()}%',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
