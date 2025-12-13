import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Save Japa button with pulsing animation
/// Positioned in thumb-reachable zone with orange gradient styling
class SaveJapaButtonWidget extends StatelessWidget {
  final AnimationController pulseController;
  final VoidCallback onPressed;

  const SaveJapaButtonWidget({
    super.key,
    required this.pulseController,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        final scale = 1.0 + (pulseController.value * 0.05);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 80.w,
            constraints: const BoxConstraints(maxWidth: 400),
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: theme.colorScheme.primary.withValues(alpha: 0.4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'save',
                    color: theme.colorScheme.onPrimary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Save Japa',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}