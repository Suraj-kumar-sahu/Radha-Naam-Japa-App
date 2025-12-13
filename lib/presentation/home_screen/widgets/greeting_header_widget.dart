import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';

class GreetingHeaderWidget extends StatelessWidget {
  const GreetingHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Soft Mandala Watermark (Simulated with Icon)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Radhe Radhe 🙏',
                  style: AppTheme.glowTextStyle.copyWith(fontSize: 24.sp),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Today is auspicious for chanting & clarity',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.ashGray,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
            // Profile Icon / Mandala
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.dustGold.withOpacity(0.3)),
              ),
              child: const Icon(Icons.spa_outlined, color: AppTheme.goldRadiance),
            ),
          ],
        ),
      ],
    );
  }
}