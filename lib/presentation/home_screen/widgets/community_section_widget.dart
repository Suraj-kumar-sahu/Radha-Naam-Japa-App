import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';

class CommunitySectionWidget extends StatelessWidget {
  const CommunitySectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Naam Japa Groups',
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.5.h),

        // Group Card
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.cosmicBlackMist,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.dustGold.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              CircleAvatar(backgroundColor: AppTheme.purpleMist, child: Text('VR')),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Vrindavan Dham Group', style: AppTheme.darkTheme.textTheme.titleSmall),
                    Text('🔴 24 members chanting live', style: TextStyle(color: AppTheme.goldRadiance, fontSize: 9.sp)),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Join', style: TextStyle(color: AppTheme.goldRadiance)),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),

        // Leaderboard Preview
        Text('Top Sadhaks Today', style: AppTheme.darkTheme.textTheme.titleMedium),
        SizedBox(height: 1.5.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.cosmicBlackMist,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildLeaderRow(1, 'Priya S.', '10,200'),
              const Divider(color: AppTheme.purpleMist),
              _buildLeaderRow(2, 'Rahul K.', '9,800'),
              const Divider(color: AppTheme.purpleMist),
              _buildLeaderRow(3, 'Amit B.', '9,500'),
              SizedBox(height: 1.h),
              Center(
                child: Text(
                  'View Full Leaderboard',
                  style: TextStyle(color: AppTheme.goldRadiance, fontSize: 10.sp),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderRow(int rank, String name, String score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('#$rank', style: TextStyle(color: AppTheme.ashGray, fontWeight: FontWeight.bold)),
          SizedBox(width: 4.w),
          Text(name, style: TextStyle(color: AppTheme.moonlightWhite)),
          const Spacer(),
          Text(score, style: TextStyle(color: AppTheme.goldRadiance, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}