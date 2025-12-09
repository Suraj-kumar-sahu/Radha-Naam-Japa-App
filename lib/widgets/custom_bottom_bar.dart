import 'package:flutter/material.dart';

/// Custom bottom navigation bar for devotional app
/// Implements thumb-zone optimized navigation with spiritual aesthetic
enum BottomBarVariant {
  /// Standard bottom bar with all navigation items visible
  standard,

  /// Reduced opacity variant for counting screen (non-intrusive)
  counting,

  /// Hidden variant for full immersion during meditation
  hidden,
}

/// Navigation item configuration for bottom bar
class BottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String route;

  const BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.route,
  });
}

/// Custom bottom navigation bar widget implementing Sacred Warmth design
/// with Mindful Minimalism principles for devotional practice
class CustomBottomBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when navigation item is tapped
  final ValueChanged<int>? onTap;

  /// Visual variant of the bottom bar
  final BottomBarVariant variant;

  /// Whether to show labels below icons
  final bool showLabels;

  /// Custom elevation (default: 8.0 for gentle depth)
  final double? elevation;

  /// Custom background color (overrides theme)
  final Color? backgroundColor;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.variant = BottomBarVariant.standard,
    this.showLabels = true,
    this.elevation,
    this.backgroundColor,
  });

  /// Navigation items mapped to app routes
  static const List<BottomNavItem> _navItems = [
    BottomNavItem(
      icon: Icons.help_outline,
      activeIcon: Icons.help_outline,
      label: 'Home',
      route: '/home-screen',
    ),
    BottomNavItem(
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart,
      label: 'Statistics',
      route: '/home-screen', // Statistics will be a tab/section in home
    ),
    BottomNavItem(
      icon: Icons.emoji_events_outlined,
      activeIcon: Icons.emoji_events,
      label: 'Leaderboard',
      route: '/home-screen', // Leaderboard will be a tab/section in home
    ),
    BottomNavItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
      route: '/home-screen', // Settings will be accessible from home
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Handle hidden variant
    if (variant == BottomBarVariant.hidden) {
      return const SizedBox.shrink();
    }

    // Calculate opacity for counting variant
    final opacity = variant == BottomBarVariant.counting ? 0.3 : 1.0;

    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Container(
        decoration: BoxDecoration(
          color:
              backgroundColor ?? theme.bottomNavigationBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow,
              blurRadius: 8.0,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: showLabels ? 64.0 : 56.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                _navItems.length,
                (index) => _buildNavItem(
                  context,
                  _navItems[index],
                  index,
                  currentIndex == index,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    BottomNavItem item,
    int index,
    bool isSelected,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomNavTheme = theme.bottomNavigationBarTheme;

    final color = isSelected
        ? (bottomNavTheme.selectedItemColor ?? colorScheme.primary)
        : (bottomNavTheme.unselectedItemColor ??
            colorScheme.onSurface.withValues(alpha: 0.6));

    final icon =
        isSelected && item.activeIcon != null ? item.activeIcon! : item.icon;

    return Expanded(
      child: InkWell(
        onTap: variant == BottomBarVariant.counting
            ? null
            : () {
                if (onTap != null) {
                  onTap!(index);
                } else {
                  // Default navigation behavior
                  Navigator.pushNamed(context, item.route);
                }
              },
        splashColor: colorScheme.primary.withValues(alpha: 0.1),
        highlightColor: colorScheme.primary.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with gentle scale animation
              AnimatedScale(
                scale: isSelected ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Icon(
                  icon,
                  size: 24.0,
                  color: color,
                ),
              ),

              // Label with fade animation
              if (showLabels) ...[
                const SizedBox(height: 4.0),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  style: (isSelected
                          ? bottomNavTheme.selectedLabelStyle
                          : bottomNavTheme.unselectedLabelStyle) ??
                      TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: color,
                        letterSpacing: 0.4,
                      ),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to create bottom bar with custom navigation handler
  static Widget withNavigation({
    required BuildContext context,
    required int currentIndex,
    BottomBarVariant variant = BottomBarVariant.standard,
    bool showLabels = true,
    double? elevation,
    Color? backgroundColor,
  }) {
    return CustomBottomBar(
      currentIndex: currentIndex,
      variant: variant,
      showLabels: showLabels,
      elevation: elevation,
      backgroundColor: backgroundColor,
      onTap: (index) {
        // Navigate to the selected route
        Navigator.pushNamed(context, _navItems[index].route);
      },
    );
  }

  /// Helper method to get route for specific index
  static String getRouteForIndex(int index) {
    if (index >= 0 && index < _navItems.length) {
      return _navItems[index].route;
    }
    return '/home-screen';
  }

  /// Helper method to get index for current route
  static int getIndexForRoute(String route) {
    final index = _navItems.indexWhere((item) => item.route == route);
    return index >= 0 ? index : 0;
  }
}
