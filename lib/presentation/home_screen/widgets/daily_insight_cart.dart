import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';

class DailyInsightCard extends StatelessWidget {
  const DailyInsightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.purpleMist.withOpacity(0.4), AppTheme.cosmicBlackMist],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.indigoAura.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppTheme.goldRadiance, size: 20),
                  SizedBox(width: 2.w),
                  Text(
                    "Today's Spiritual Insight",
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.goldRadiance,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                "Chanting at Brahma Muhurta amplifies the divine vibration...",
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppTheme.moonlightWhite.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: const BoxDecoration(
              color: AppTheme.goldRadiance,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: const Icon(Icons.lock, size: 14, color: AppTheme.deepMysticBlack),
          ),
        ),
      ],
    );
  }
}