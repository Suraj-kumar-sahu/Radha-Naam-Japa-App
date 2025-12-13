import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Action buttons for close and share functionality
class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onClose;
  final Map<String, dynamic> rankingData;

  const ActionButtonsWidget({
    super.key,
    required this.onClose,
    required this.rankingData,
  });

  void _handleShare(BuildContext context) {
    final String shareText = '''
🙏 My Radha Naam Japa Progress 🙏

Total Japa Count: ${rankingData['totalCount']}

📊 Rankings:
• Today: Rank #${rankingData['todayRank']} (${rankingData['todayCount']} japas)
• This Week: Rank #${rankingData['weekRank']} (${rankingData['weekCount']} japas)
• All Time: Rank #${rankingData['allTimeRank']} (${rankingData['allTimeCount']} japas)

Keep chanting! 🌸
    ''';

    Share.share(
      shareText,
      subject: 'My Radha Naam Japa Progress',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Row(
        children: [
          // Close button
          Expanded(
            child: OutlinedButton(
              onPressed: onClose,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                side: BorderSide(
                  color: isDark
                      ? const Color(0x1FFFFFFF)
                      : const Color(0x1F000000),
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Close',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.25,
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          // Share button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _handleShare(context),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: CustomIconWidget(
                iconName: 'share',
                color:
                    isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
                size: 4.5.w,
              ),
              label: Text(
                'Share',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
