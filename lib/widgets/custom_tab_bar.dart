import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Time period options for filtering spiritual progress data
enum TimePeriod {
  weekly,
  monthly,
  yearly;

  String get label {
    switch (this) {
      case TimePeriod.weekly:
        return 'Weekly';
      case TimePeriod.monthly:
        return 'Monthly';
      case TimePeriod.yearly:
        return 'Yearly';
    }
  }
}

/// Custom tab bar for time period filtering with gesture-enhanced interactions
/// Implements swipeable tabs with orange selection indicators
class CustomTabBar extends StatefulWidget {
  final TimePeriod selectedPeriod;
  final Function(TimePeriod) onPeriodChanged;
  final EdgeInsetsGeometry? padding;
  final bool showDivider;

  const CustomTabBar({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    this.padding,
    this.showDivider = true,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: TimePeriod.values.length,
      vsync: this,
      initialIndex: TimePeriod.values.indexOf(widget.selectedPeriod),
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        widget.onPeriodChanged(TimePeriod.values[_tabController.index]);
      }
    });
  }

  @override
  void didUpdateWidget(CustomTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedPeriod != widget.selectedPeriod) {
      final newIndex = TimePeriod.values.indexOf(widget.selectedPeriod);
      if (_tabController.index != newIndex) {
        _tabController.animateTo(
          newIndex,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor:
                  isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
              unselectedLabelColor:
                  isDark ? const Color(0xFFB0B0B0) : const Color(0xFF9E9E9E),
              labelStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              ),
              unselectedLabelStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.1,
              ),
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return colorScheme.primary.withValues(alpha: 0.1);
                }
                return Colors.transparent;
              }),
              splashFactory: InkRipple.splashFactory,
              tabs: TimePeriod.values.map((period) {
                return Tab(
                  height: 40,
                  child: Center(
                    child: Text(
                      period.label,
                      style: GoogleFonts.inter(),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        if (widget.showDivider)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Divider(
              height: 1,
              thickness: 1,
              color: isDark ? const Color(0x1FFFFFFF) : const Color(0x1F000000),
            ),
          ),
      ],
    );
  }
}

/// Compact variant of CustomTabBar for inline usage
class CustomTabBarCompact extends StatelessWidget {
  final TimePeriod selectedPeriod;
  final Function(TimePeriod) onPeriodChanged;

  const CustomTabBarCompact({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: TimePeriod.values.map((period) {
          final isSelected = period == selectedPeriod;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onPeriodChanged(period),
                borderRadius: BorderRadius.circular(6),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? colorScheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    period.label,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? (isDark
                              ? const Color(0xFF000000)
                              : const Color(0xFFFFFFFF))
                          : (isDark
                              ? const Color(0xFFB0B0B0)
                              : const Color(0xFF9E9E9E)),
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Page view wrapper for swipeable content with tab synchronization
class CustomTabBarView extends StatelessWidget {
  final TabController controller;
  final List<Widget> children;
  final bool physics;

  const CustomTabBarView({
    super.key,
    required this.controller,
    required this.children,
    this.physics = true,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      physics: physics
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}
