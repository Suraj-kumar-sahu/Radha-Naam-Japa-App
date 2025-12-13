import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

/// Total japa count display with large typography
class TotalJapaCountWidget extends StatelessWidget {
  final int totalCount;

  const TotalJapaCountWidget({
    super.key,
    required this.totalCount,
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

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Total Japa Count',
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFFB0B0B0) : const Color(0xFF9E9E9E),
              letterSpacing: 0.1,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _formatCount(totalCount),
            style: GoogleFonts.inter(
              fontSize: 32.sp,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
              letterSpacing: -0.25,
              height: 1.12,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Radha Naam Japas',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFFB0B0B0) : const Color(0xFF9E9E9E),
              letterSpacing: 0.25,
            ),
          ),
        ],
      ),
    );
  }
}
