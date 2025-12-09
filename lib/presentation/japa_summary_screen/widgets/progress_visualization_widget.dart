import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Widget displaying circular progress visualization for session contribution
class ProgressVisualizationWidget extends StatefulWidget {
  final int sessionJapaCount;
  final int dailyGoal;

  const ProgressVisualizationWidget({
    super.key,
    required this.sessionJapaCount,
    required this.dailyGoal,
  });

  @override
  State<ProgressVisualizationWidget> createState() =>
      _ProgressVisualizationWidgetState();
}

class _ProgressVisualizationWidgetState
    extends State<ProgressVisualizationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    final progress = widget.dailyGoal > 0
        ? (widget.sessionJapaCount / widget.dailyGoal).clamp(0.0, 1.0)
        : 0.0;

    _progressAnimation = Tween<double>(begin: 0.0, end: progress).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressPercentage =
        ((widget.sessionJapaCount / widget.dailyGoal) * 100).clamp(0, 100);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Daily Goal Progress',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          SizedBox(
            width: 50.w,
            height: 50.w,
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background circle
                    SizedBox(
                      width: 50.w,
                      height: 50.w,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 12,
                        backgroundColor:
                            theme.colorScheme.outline.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.outline.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                    // Progress circle
                    SizedBox(
                      width: 50.w,
                      height: 50.w,
                      child: CircularProgressIndicator(
                        value: _progressAnimation.value,
                        strokeWidth: 12,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    // Center text
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${progressPercentage.toStringAsFixed(0)}%',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'of daily goal',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                'Session',
                widget.sessionJapaCount.toString(),
              ),
              Container(
                width: 1,
                height: 4.h,
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
              _buildStatItem(
                context,
                'Goal',
                widget.dailyGoal.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
