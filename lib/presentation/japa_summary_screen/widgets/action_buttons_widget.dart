import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Widget containing action buttons for sharing, starting new session, and viewing statistics
class ActionButtonsWidget extends StatelessWidget {
  final int totalJapaCount;
  final int malaCount;
  final VoidCallback onStartNewSession;
  final VoidCallback onViewStatistics;

  const ActionButtonsWidget({
    super.key,
    required this.totalJapaCount,
    required this.malaCount,
    required this.onStartNewSession,
    required this.onViewStatistics,
  });

  void _shareAchievement(BuildContext context) {
    final shareText = '''🙏 Radha Naam Japa Achievement 🙏

I just completed $totalJapaCount Japa ($malaCount ${malaCount == 1 ? 'Mala' : 'Malas'}) in my spiritual practice!

Join me in this devotional journey with Radha Naam Japa app.

#RadhaNaamJapa #SpiritualPractice #Devotion''';

    Share.share(
      shareText,
      subject: 'My Radha Naam Japa Achievement',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          // Share Achievement Button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton.icon(
              onPressed: () => _shareAchievement(context),
              icon: CustomIconWidget(
                iconName: 'share',
                color: theme.colorScheme.onPrimary,
                size: 20.sp,
              ),
              label: Text(
                'Share Achievement',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Start Another Session Button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: OutlinedButton.icon(
              onPressed: onStartNewSession,
              icon: CustomIconWidget(
                iconName: 'refresh',
                color: theme.colorScheme.primary,
                size: 20.sp,
              ),
              label: Text(
                'Start Another Session',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // View Statistics Button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: TextButton.icon(
              onPressed: onViewStatistics,
              icon: CustomIconWidget(
                iconName: 'bar_chart',
                color: theme.colorScheme.primary,
                size: 20.sp,
              ),
              label: Text(
                'View Statistics',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
