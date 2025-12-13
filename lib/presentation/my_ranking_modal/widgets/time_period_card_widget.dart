import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Time period statistics card with rank and count
class TimePeriodCardWidget extends StatelessWidget {
  final String period;
  final int rank;
  final int count;
  final double? percentageChange;
  final int index;

  const TimePeriodCardWidget({
    super.key,
    required this.period,
    required this.rank,
    required this.count,
    this.percentageChange,
    required this.index,
  });

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0x1FFFFFFF) : const Color(0x1F000000),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Period label
            Text(
              period,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color:
                    isDark ? const Color(0xFFB0B0B0) : const Color(0xFF9E9E9E),
                letterSpacing: 0.1,
              ),
            ),
            SizedBox(height: 1.5.h),
            // Rank and count row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Rank section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Rank',
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? const Color(0xFFB0B0B0)
                              : const Color(0xFF9E9E9E),
                          letterSpacing: 0.25,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'emoji_events',
                            color: theme.colorScheme.primary,
                            size: 5.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '#$rank',
                            style: GoogleFonts.inter(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.primary,
                              letterSpacing: 0,
                              height: 1.22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Count section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Count',
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? const Color(0xFFB0B0B0)
                              : const Color(0xFF9E9E9E),
                          letterSpacing: 0.25,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        _formatCount(count),
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? const Color(0xFFE0E0E0)
                              : const Color(0xFF424242),
                          letterSpacing: 0,
                          height: 1.22,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Percentage change indicator
            if (percentageChange != null) ...[
              SizedBox(height: 1.5.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: percentageChange! >= 0
                      ? const Color(0xFF4CAF50).withValues(alpha: 0.1)
                      : const Color(0xFFF44336).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: percentageChange! >= 0
                          ? 'trending_up'
                          : 'trending_down',
                      color: percentageChange! >= 0
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFF44336),
                      size: 3.5.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${percentageChange!.abs().toStringAsFixed(1)}%',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: percentageChange! >= 0
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFF44336),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
