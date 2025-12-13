import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';
import '../../../services/japa_storage_service.dart';

class JapaProgressCardWidget extends StatefulWidget {
  final int todayCount;
  final int dailyGoal;
  final Function(int) onTargetChanged;

  const JapaProgressCardWidget({
    super.key,
    required this.todayCount,
    required this.dailyGoal,
    required this.onTargetChanged,
  });

  @override
  State<JapaProgressCardWidget> createState() => _JapaProgressCardWidgetState();
}

class _JapaProgressCardWidgetState extends State<JapaProgressCardWidget> {
  int _totalJaps = 0;
  int _currentMalas = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final totalJaps = await JapaStorageService.getTotalJaps();
    final malas = await JapaStorageService.getMalasCompleted();
    setState(() {
      _totalJaps = totalJaps;
      _currentMalas = malas;
    });
  }

  void _showTargetSettings() {
    final TextEditingController controller = TextEditingController(text: widget.dailyGoal.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cosmicBlackMist,
        title: Text(
          'Set Target Malas',
          style: AppTheme.glowTextStyle,
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter target malas',
            hintStyle: TextStyle(color: AppTheme.ashGray),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppTheme.goldRadiance),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.ashGray),
            ),
          ),
          TextButton(
            onPressed: () {
              final target = int.tryParse(controller.text) ?? widget.dailyGoal;
              widget.onTargetChanged(target);
              Navigator.of(context).pop();
            },
            child: Text(
              'Save',
              style: TextStyle(color: AppTheme.goldRadiance),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (widget.todayCount / widget.dailyGoal).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
      decoration: BoxDecoration(
        color: AppTheme.cosmicBlackMist,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.dustGold.withOpacity(0.2)),
        boxShadow: AppTheme.auraGlow,
      ),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 28.w,
            lineWidth: 12.0,
            percent: progress,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${widget.todayCount}',
                  style: AppTheme.glowTextStyle.copyWith(fontSize: 32.sp),
                ),
              ],
            ),
            progressColor: AppTheme.goldRadiance,
            backgroundColor: AppTheme.purpleMist.withOpacity(0.3),
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.todayCount} / ${widget.dailyGoal} Japs",
                style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.goldRadiance,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(width: 2.w),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: AppTheme.goldRadiance,
                  size: 18.sp,
                ),
                onPressed: _showTargetSettings,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
