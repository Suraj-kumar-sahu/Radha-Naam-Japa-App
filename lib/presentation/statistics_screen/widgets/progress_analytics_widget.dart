import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_tab_bar.dart';

/// Progress analytics section with time period tabs and bar chart
class ProgressAnalyticsWidget extends StatefulWidget {
  const ProgressAnalyticsWidget({super.key});

  @override
  State<ProgressAnalyticsWidget> createState() =>
      _ProgressAnalyticsWidgetState();
}

class _ProgressAnalyticsWidgetState extends State<ProgressAnalyticsWidget> {
  TimePeriod _selectedPeriod = TimePeriod.weekly;
  DateTime _currentDate = DateTime.now();

  // Mock data for different time periods
  final Map<TimePeriod, List<Map<String, dynamic>>> _mockData = {
    TimePeriod.weekly: [
      {'day': 'Mon', 'count': 108},
      {'day': 'Tue', 'count': 216},
      {'day': 'Wed', 'count': 324},
      {'day': 'Thu', 'count': 180},
      {'day': 'Fri', 'count': 270},
      {'day': 'Sat', 'count': 432},
      {'day': 'Sun', 'count': 540},
    ],
    TimePeriod.monthly: [
      {'day': 'Week 1', 'count': 1512},
      {'day': 'Week 2', 'count': 1890},
      {'day': 'Week 3', 'count': 2160},
      {'day': 'Week 4', 'count': 1944},
    ],
    TimePeriod.yearly: [
      {'day': 'Jan', 'count': 6480},
      {'day': 'Feb', 'count': 5832},
      {'day': 'Mar', 'count': 7020},
      {'day': 'Apr', 'count': 6156},
      {'day': 'May', 'count': 7344},
      {'day': 'Jun', 'count': 6912},
      {'day': 'Jul', 'count': 7560},
      {'day': 'Aug', 'count': 6804},
      {'day': 'Sep', 'count': 7128},
      {'day': 'Oct', 'count': 7452},
      {'day': 'Nov', 'count': 6588},
      {'day': 'Dec', 'count': 7236},
    ],
  };

  String _getDateRangeText() {
    switch (_selectedPeriod) {
      case TimePeriod.weekly:
        final startDate =
            _currentDate.subtract(Duration(days: _currentDate.weekday - 1));
        final endDate = startDate.add(const Duration(days: 6));
        return '${_formatDate(startDate)} - ${_formatDate(endDate)}';
      case TimePeriod.monthly:
        return '${_getMonthName(_currentDate.month)} ${_currentDate.year}';
      case TimePeriod.yearly:
        return '${_currentDate.year}';
    }
  }

  String _formatDate(DateTime date) {
    return '${_getMonthName(date.month).substring(0, 3)} ${date.day.toString().padLeft(2, '0')}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  void _navigatePrevious() {
    setState(() {
      switch (_selectedPeriod) {
        case TimePeriod.weekly:
          _currentDate = _currentDate.subtract(const Duration(days: 7));
          break;
        case TimePeriod.monthly:
          _currentDate = DateTime(_currentDate.year, _currentDate.month - 1, 1);
          break;
        case TimePeriod.yearly:
          _currentDate = DateTime(_currentDate.year - 1, 1, 1);
          break;
      }
    });
  }

  void _navigateNext() {
    setState(() {
      switch (_selectedPeriod) {
        case TimePeriod.weekly:
          _currentDate = _currentDate.add(const Duration(days: 7));
          break;
        case TimePeriod.monthly:
          _currentDate = DateTime(_currentDate.year, _currentDate.month + 1, 1);
          break;
        case TimePeriod.yearly:
          _currentDate = DateTime(_currentDate.year + 1, 1, 1);
          break;
      }
    });
  }

  int _getTotalCount() {
    final data = _mockData[_selectedPeriod] ?? [];
    return data.fold(0, (sum, item) => sum + (item['count'] as int));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Text(
            'Progress Analytics',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        CustomTabBar(
          selectedPeriod: _selectedPeriod,
          onPeriodChanged: (period) {
            setState(() {
              _selectedPeriod = period;
            });
          },
          showDivider: false,
        ),
        SizedBox(height: 2.h),
        _buildDateNavigation(theme),
        SizedBox(height: 2.h),
        _buildBarChart(theme),
        SizedBox(height: 2.h),
        _buildTotalSummaryCard(theme),
      ],
    );
  }

  Widget _buildDateNavigation(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _navigatePrevious,
            icon: CustomIconWidget(
              iconName: 'arrow_back_ios',
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          Text(
            _getDateRangeText(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: _navigateNext,
            icon: CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(ThemeData theme) {
    final data = _mockData[_selectedPeriod] ?? [];
    final maxCount = data.fold(
        0,
        (max, item) =>
            (item['count'] as int) > max ? (item['count'] as int) : max);

    return Container(
      height: 30.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxCount.toDouble() * 1.2,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: theme.colorScheme.primary,
              tooltipPadding: const EdgeInsets.all(8),
              tooltipMargin: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${data[groupIndex]['day']}\n${rod.toY.toInt()}',
                  theme.textTheme.bodySmall!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < data.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        data[value.toInt()]['day'] as String,
                        style: theme.textTheme.bodySmall,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: theme.textTheme.bodySmall,
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxCount / 5,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(
            data.length,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: (data[index]['count'] as int).toDouble(),
                  color: theme.colorScheme.primary,
                  width: 16,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalSummaryCard(ThemeData theme) {
    final totalCount = _getTotalCount();
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Japa Count',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                _selectedPeriod.label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? const Color(0xFFB0B0B0)
                      : const Color(0xFF9E9E9E),
                ),
              ),
            ],
          ),
          Text(
            totalCount.toString(),
            style: theme.textTheme.displaySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}