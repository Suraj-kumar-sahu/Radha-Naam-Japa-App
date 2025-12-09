import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom app bar variants for different screen contexts
enum AppBarVariant {
  /// Standard app bar with title and actions
  standard,

  /// Minimal app bar for counting screen (transparent, minimal elements)
  minimal,

  /// App bar with back button and title
  withBack,

  /// App bar with search functionality
  withSearch,

  /// Transparent app bar for immersive experiences
  transparent,
}

/// Custom app bar implementing Sacred Warmth design with Mindful Minimalism
/// Provides contextual navigation while maintaining contemplative serenity
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Title text to display
  final String? title;

  /// Title widget (overrides title text)
  final Widget? titleWidget;

  /// Leading widget (typically back button or menu)
  final Widget? leading;

  /// Action widgets displayed on the right
  final List<Widget>? actions;

  /// Visual variant of the app bar
  final AppBarVariant variant;

  /// Whether to show back button automatically
  final bool automaticallyImplyLeading;

  /// Custom background color (overrides theme)
  final Color? backgroundColor;

  /// Custom elevation (default: 0 for flat design)
  final double? elevation;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom height (default: 56.0)
  final double? height;

  /// Callback when back button is pressed
  final VoidCallback? onBackPressed;

  /// System overlay style for status bar
  final SystemUiOverlayStyle? systemOverlayStyle;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.variant = AppBarVariant.standard,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.elevation,
    this.centerTitle = true,
    this.height,
    this.onBackPressed,
    this.systemOverlayStyle,
  });

  @override
  Size get preferredSize => Size.fromHeight(height ?? 56.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appBarTheme = theme.appBarTheme;

    // Handle transparent variant
    if (variant == AppBarVariant.transparent) {
      return _buildTransparentAppBar(context);
    }

    // Handle minimal variant for counting screen
    if (variant == AppBarVariant.minimal) {
      return _buildMinimalAppBar(context);
    }

    // Determine background color based on variant
    final bgColor = backgroundColor ??
        (variant == AppBarVariant.transparent
            ? Colors.transparent
            : appBarTheme.backgroundColor ?? colorScheme.surface);

    // Determine foreground color
    final fgColor = appBarTheme.foregroundColor ?? colorScheme.onSurface;

    // Build leading widget
    final leadingWidget = _buildLeading(context);

    // Build title widget
    final titleContent = titleWidget ??
        (title != null
            ? Text(
                title!,
                style: appBarTheme.titleTextStyle ??
                    theme.textTheme.titleLarge?.copyWith(
                      color: fgColor,
                      fontWeight: FontWeight.w600,
                    ),
              )
            : null);

    return AppBar(
      leading: leadingWidget,
      title: titleContent,
      actions: actions,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      elevation: elevation ?? appBarTheme.elevation ?? 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      systemOverlayStyle: systemOverlayStyle ??
          (theme.brightness == Brightness.light
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light),
      toolbarHeight: height ?? 56.0,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) {
      return leading;
    }

    if (!automaticallyImplyLeading) {
      return null;
    }

    // Show back button if we can pop
    final canPop = Navigator.of(context).canPop();
    if (canPop || variant == AppBarVariant.withBack) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        tooltip: 'Back',
        splashRadius: 24.0,
      );
    }

    return null;
  }

  Widget _buildTransparentAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      leading: _buildLeading(context),
      title: titleWidget,
      actions: actions,
      backgroundColor: Colors.transparent,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      systemOverlayStyle: systemOverlayStyle ??
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: theme.brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
          ),
      toolbarHeight: height ?? 56.0,
    );
  }

  Widget _buildMinimalAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      leading: leading,
      actions: actions,
      backgroundColor: Colors.transparent,
      foregroundColor: colorScheme.onSurface.withValues(alpha: 0.6),
      elevation: 0,
      automaticallyImplyLeading: false,
      systemOverlayStyle: systemOverlayStyle ??
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: theme.brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
          ),
      toolbarHeight: height ?? 56.0,
    );
  }

  /// Factory constructor for standard app bar with title
  factory CustomAppBar.standard({
    required String title,
    List<Widget>? actions,
    Color? backgroundColor,
    double? elevation,
    bool centerTitle = true,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      variant: AppBarVariant.standard,
      backgroundColor: backgroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
    );
  }

  /// Factory constructor for app bar with back button
  factory CustomAppBar.withBack({
    required String title,
    VoidCallback? onBackPressed,
    List<Widget>? actions,
    Color? backgroundColor,
    double? elevation,
    bool centerTitle = true,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      variant: AppBarVariant.withBack,
      onBackPressed: onBackPressed,
      backgroundColor: backgroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
    );
  }

  /// Factory constructor for minimal app bar (counting screen)
  factory CustomAppBar.minimal({
    Widget? leading,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      leading: leading,
      actions: actions,
      variant: AppBarVariant.minimal,
    );
  }

  /// Factory constructor for transparent app bar
  factory CustomAppBar.transparent({
    Widget? titleWidget,
    Widget? leading,
    List<Widget>? actions,
    bool centerTitle = true,
    SystemUiOverlayStyle? systemOverlayStyle,
  }) {
    return CustomAppBar(
      titleWidget: titleWidget,
      leading: leading,
      actions: actions,
      variant: AppBarVariant.transparent,
      centerTitle: centerTitle,
      systemOverlayStyle: systemOverlayStyle,
    );
  }

  /// Factory constructor for search app bar
  factory CustomAppBar.withSearch({
    required String title,
    required VoidCallback onSearchPressed,
    List<Widget>? actions,
    Color? backgroundColor,
    double? elevation,
    bool centerTitle = true,
  }) {
    final searchActions = [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: onSearchPressed,
        tooltip: 'Search',
        splashRadius: 24.0,
      ),
      if (actions != null) ...actions,
    ];

    return CustomAppBar(
      title: title,
      actions: searchActions,
      variant: AppBarVariant.withSearch,
      backgroundColor: backgroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
    );
  }
}
