import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';

class SessionHistoryWidget extends StatelessWidget {
  const SessionHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: EdgeInsets.only(bottom: 2.h, left: 2.w),
            child: Text(
              'Recent Chants',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.moonlightWhite,
                letterSpacing: 1.0,
              ),
            ),
          ),
          
          // List of "Star Logs"
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3, // Mock data for now
            separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
            itemBuilder: (context, index) {
              return _buildHistoryTile(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTile(int index) {
    // Mock Data logic
    final count = [108, 540, 1080][index];
    final time = ['Morning', 'Yesterday', '2 Days ago'][index];
    
    return Container(
      decoration: BoxDecoration(
        // Glassmorphism: Semi-transparent dark layer
        color: AppTheme.purpleMist.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.dustGold.withOpacity(0.2), 
          width: 1
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.w),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.deepMysticBlack,
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.goldRadiance, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppTheme.goldRadiance.withOpacity(0.2),
                blurRadius: 8,
              )
            ],
          ),
          child: const Icon(Icons.spa, color: AppTheme.goldRadiance, size: 20),
        ),
        title: Text(
          '$count Radhe Naam',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.moonlightWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          time,
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.ashGray,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios, 
          color: AppTheme.dustGold, 
          size: 14.sp
        ),
      ),
    );
  }
}