import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Japa calendar with month navigation and status indicators
class JapaCalendarWidget extends StatefulWidget {
  const JapaCalendarWidget({super.key});

  @override
  State<JapaCalendarWidget> createState() => _JapaCalendarWidgetState();
}

class _JapaCalendarWidgetState extends State<JapaCalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Mock data for calendar status
  final Map<DateTime, String> _japaStatus = {
    DateTime(2024, 12, 1): 'completed',
    DateTime(2024, 12, 2): 'completed',
    DateTime(2024, 12, 3): 'missed',
    DateTime(2024, 12, 4): 'completed',
    DateTime(2024, 12, 5): 'completed',
    DateTime(2024, 12, 6): 'completed',
    DateTime(2024, 12, 7): 'missed',
    DateTime(2024, 12, 8): 'completed',
    DateTime(2024, 12, 9): 'completed',
    DateTime(2024, 12, 10): 'completed',
  };

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Text(
            'Japa Calendar',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildMonthNavigation(theme),
              SizedBox(height: 2.h),
              _buildCalendar(theme),
              SizedBox(height: 2.h),
              _buildLegend(theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMonthNavigation(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _focusedDay =
                  DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
            });
          },
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        Text(
          '${_getMonthName(_focusedDay.month)} ${_focusedDay.year}',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _focusedDay =
                  DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
            });
          },
          icon: CustomIconWidget(
            iconName: 'arrow_forward_ios',
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return TableCalendar(
      firstDay: DateTime(2020, 1, 1),
      lastDay: DateTime(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerVisible: false,
      daysOfWeekHeight: 40,
      rowHeight: 48,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        todayDecoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.primary,
            width: 2,
          ),
          shape: BoxShape.circle,
        ),
        todayTextStyle: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w600,
        ),
        selectedDecoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        selectedTextStyle: theme.textTheme.bodyMedium!.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        defaultTextStyle: theme.textTheme.bodyMedium!,
        weekendTextStyle: theme.textTheme.bodyMedium!,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: theme.textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark ? const Color(0xFFB0B0B0) : const Color(0xFF9E9E9E),
        ),
        weekendStyle: theme.textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark ? const Color(0xFFB0B0B0) : const Color(0xFF9E9E9E),
        ),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          return _buildDayCell(day, theme);
        },
        todayBuilder: (context, day, focusedDay) {
          return _buildDayCell(day, theme, isToday: true);
        },
        selectedBuilder: (context, day, focusedDay) {
          return _buildDayCell(day, theme, isSelected: true);
        },
      ),
    );
  }

  Widget _buildDayCell(DateTime day, ThemeData theme,
      {bool isToday = false, bool isSelected = false}) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    final status = _japaStatus[normalizedDay];

    // Determine background color based on status
    Color? backgroundColor;
    Color? textColor;
    Widget? statusIcon;

    if (status == 'completed') {
      backgroundColor = const Color(0xFF4CAF50);
      textColor = Colors.white;
      statusIcon = const Icon(
        Icons.check,
        color: Colors.white,
        size: 16,
      );
    } else if (status == 'missed') {
      backgroundColor = const Color(0xFFF44336);
      textColor = Colors.white;
      statusIcon = const Icon(
        Icons.close,
        color: Colors.white,
        size: 16,
      );
    }

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: isToday && status == null
            ? Border.all(
                color: Colors.orange,
                width: 2,
              )
            : null,
        color: backgroundColor ??
            (isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.2)
                : null),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (status == null)
            Text(
              '${day.day}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight:
                    isToday || isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? theme.colorScheme.primary : null,
              ),
            ),
          if (status != null)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${day.day}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                statusIcon!,
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildLegend(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLegendItem(
            theme,
            CustomIconWidget(
              iconName: 'check_circle',
              color: const Color(0xFF4CAF50),
              size: 16,
            ),
            'Completed',
          ),
          _buildLegendItem(
            theme,
            CustomIconWidget(
              iconName: 'cancel',
              color: const Color(0xFFF44336),
              size: 16,
            ),
            'Missed',
          ),
          _buildLegendItem(
            theme,
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
            ),
            'Today',
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(ThemeData theme, Widget icon, String label) {
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        icon,
        SizedBox(width: 1.w),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isDark ? const Color(0xFFB0B0B0) : const Color(0xFF9E9E9E),
          ),
        ),
      ],
    );
  }
}
