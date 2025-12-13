import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onStartJapa;
  final VoidCallback onKidsMode;

  const ActionButtonsWidget({
    super.key,
    required this.onStartJapa,
    required this.onKidsMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 3. Primary CTA
        GestureDetector(
          onTap: onStartJapa,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              gradient: AppTheme.goldGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppTheme.buttonGlow,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_circle_fill, color: AppTheme.deepMysticBlack, size: 28),
                    SizedBox(width: 2.w),
                    Text(
                      'Start Naam Japa',
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.deepMysticBlack,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Tap anywhere on the screen to count',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.deepMysticBlack.withOpacity(0.7),
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 2.h),

        // 4. Naam Japa with Game (Kids Mode)
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.purpleMist.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.indigoAura.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.indigoAura.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.child_care, color: AppTheme.glowGold),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Naam Japa with Game',
                          style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                            color: AppTheme.moonlightWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.goldRadiance,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'KIDS MODE',
                            style: TextStyle(
                              fontSize: 7.sp,
                              color: AppTheme.deepMysticBlack,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Playful devotion for children',
                      style: AppTheme.darkTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.ashGray),
            ],
          ),
        ),
      ],
    );
  }
}