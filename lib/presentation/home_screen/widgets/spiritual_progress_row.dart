import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';

class SpiritualProgressRow extends StatelessWidget {
  final int currentStreak;
  final int totalChants;
  final String currentLevel;

  const SpiritualProgressRow({
    super.key,
    required this.currentStreak,
    required this.totalChants,
    required this.currentLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatCard('🔥 $currentStreak days', 'Streak'),
        SizedBox(width: 3.w),
        _buildStatCard('🧮 ${_formatTotalChants(totalChants)}', 'Total Chants'),
        SizedBox(width: 3.w),
        _buildStatCard('🌸 $currentLevel', 'Level'),
      ],
    );
  }

  String _formatTotalChants(int chants) {
    if (chants >= 1000) {
      return '${(chants / 1000).toStringAsFixed(1)}k';
    }
    return chants.toString();
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        decoration: BoxDecoration(
          color: AppTheme.cosmicBlackMist,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.dustGold.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.moonlightWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                fontSize: 8.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}