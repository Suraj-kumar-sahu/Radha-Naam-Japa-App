import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the devotional application.
/// Implements Sacred Warmth color palette with Mindful Minimalism design principles.
class AppTheme {
  AppTheme._();

  // Sacred Warmth Color Palette
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color secondaryOrange = Color(0xFFFF8E53);
  static const Color backgroundCream = Color(0xFFFFF8F3);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2D1810);
  static const Color textSecondary = Color(0xFF6B4E3D);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color dividerGray = Color(0xFFE8E0D8);
  static const Color shadowColor = Color(0x10000000); // 6% opacity
  static const Color hindiAccent = Color(0xFFD84315);

  // Dark theme adaptations
  static const Color primaryOrangeDark = Color(0xFFFF8E53);
  static const Color backgroundDark = Color(0xFF1A1410);
  static const Color cardDark = Color(0xFF2D2520);
  static const Color textPrimaryDark = Color(0xFFFFF8F3);
  static const Color textSecondaryDark = Color(0xFFD4C4B8);
  static const Color dividerDark = Color(0xFF3D3530);
  static const Color shadowDark = Color(0x12FFFFFF); // 7% opacity for dark mode

  // Text emphasis levels for light theme
  static const Color textHighEmphasisLight = textPrimary;
  static const Color textMediumEmphasisLight = textSecondary;
  static const Color textDisabledLight = Color(0x61000000); // 38% opacity

  // Text emphasis levels for dark theme
  static const Color textHighEmphasisDark = textPrimaryDark;
  static const Color textMediumEmphasisDark = textSecondaryDark;
  static const Color textDisabledDark = Color(0x61FFFFFF); // 38% opacity

  /// Light theme - Sacred Warmth with Contemplative Serenity
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryOrange,
      onPrimary: cardWhite,
      primaryContainer: secondaryOrange,
      onPrimaryContainer: cardWhite,
      secondary: secondaryOrange,
      onSecondary: cardWhite,
      secondaryContainer: Color(0xFFFFD7C4),
      onSecondaryContainer: textPrimary,
      tertiary: hindiAccent,
      onTertiary: cardWhite,
      tertiaryContainer: Color(0xFFFFCCBC),
      onTertiaryContainer: textPrimary,
      error: Color(0xFFD32F2F),
      onError: cardWhite,
      surface: backgroundCream,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: dividerGray,
      outlineVariant: Color(0xFFF0E8E0),
      shadow: shadowColor,
      scrim: Color(0x80000000),
      inverseSurface: cardDark,
      onInverseSurface: textPrimaryDark,
      inversePrimary: primaryOrangeDark,
    ),
    scaffoldBackgroundColor: backgroundCream,
    cardColor: cardWhite,
    dividerColor: dividerGray,
    appBarTheme: AppBarTheme(
      color: backgroundCream,
      foregroundColor: textPrimary,
      elevation: 0,
      shadowColor: shadowColor,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.15,
      ),
    ),
    cardTheme: CardThemeData(
      color: cardWhite,
      elevation: 2.0,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: cardWhite,
      selectedItemColor: primaryOrange,
      unselectedItemColor: textSecondary,
      elevation: 8.0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryOrange,
      foregroundColor: cardWhite,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: cardWhite,
        backgroundColor: primaryOrange,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        elevation: 2.0,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryOrange,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        side: const BorderSide(color: primaryOrange, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryOrange,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    textTheme: _buildTextTheme(isLight: true),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: cardWhite,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: dividerGray, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: dividerGray, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryOrange, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2.0),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textDisabledLight,
        fontSize: 16,
        fontWeight: FontWeight.w300,
      ),
      errorStyle: GoogleFonts.inter(
        color: Color(0xFFD32F2F),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryOrange;
        }
        return dividerGray;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryOrange.withValues(alpha: 0.5);
        }
        return dividerGray.withValues(alpha: 0.5);
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryOrange;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(cardWhite),
      side: const BorderSide(color: dividerGray, width: 2.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryOrange;
        }
        return dividerGray;
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryOrange,
      circularTrackColor: dividerGray,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryOrange,
      thumbColor: primaryOrange,
      overlayColor: primaryOrange.withValues(alpha: 0.2),
      inactiveTrackColor: dividerGray,
      trackHeight: 4.0,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: primaryOrange,
      unselectedLabelColor: textSecondary,
      indicatorColor: primaryOrange,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: textPrimary.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        color: cardWhite,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimary,
      contentTextStyle: GoogleFonts.inter(
        color: cardWhite,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: secondaryOrange,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: cardWhite,
      elevation: 8.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      modalBackgroundColor: cardWhite,
      modalElevation: 8.0,
    ),
    dividerTheme: const DividerThemeData(
      color: dividerGray,
      thickness: 1.0,
      space: 1.0,
    ), dialogTheme: DialogThemeData(backgroundColor: cardWhite),
  );

  /// Dark theme - Sacred Warmth adapted for low-light meditation
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryOrangeDark,
      onPrimary: backgroundDark,
      primaryContainer: primaryOrange,
      onPrimaryContainer: cardWhite,
      secondary: secondaryOrange,
      onSecondary: backgroundDark,
      secondaryContainer: Color(0xFF4D3020),
      onSecondaryContainer: textPrimaryDark,
      tertiary: hindiAccent,
      onTertiary: cardWhite,
      tertiaryContainer: Color(0xFF5D2F1A),
      onTertiaryContainer: textPrimaryDark,
      error: Color(0xFFEF5350),
      onError: backgroundDark,
      surface: backgroundDark,
      onSurface: textPrimaryDark,
      onSurfaceVariant: textSecondaryDark,
      outline: dividerDark,
      outlineVariant: Color(0xFF2D2520),
      shadow: shadowDark,
      scrim: Color(0x80000000),
      inverseSurface: backgroundCream,
      onInverseSurface: textPrimary,
      inversePrimary: primaryOrange,
    ),
    scaffoldBackgroundColor: backgroundDark,
    cardColor: cardDark,
    dividerColor: dividerDark,
    appBarTheme: AppBarTheme(
      color: backgroundDark,
      foregroundColor: textPrimaryDark,
      elevation: 0,
      shadowColor: shadowDark,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
        letterSpacing: 0.15,
      ),
    ),
    cardTheme: CardThemeData(
  color: cardDark,
  elevation: 2.0,
  shadowColor: shadowDark,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12.0),
  ),
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: cardDark,
      selectedItemColor: primaryOrangeDark,
      unselectedItemColor: textSecondaryDark,
      elevation: 8.0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryOrangeDark,
      foregroundColor: backgroundDark,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: backgroundDark,
        backgroundColor: primaryOrangeDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        elevation: 2.0,
        shadowColor: shadowDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryOrangeDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        side: const BorderSide(color: primaryOrangeDark, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryOrangeDark,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    textTheme: _buildTextTheme(isLight: false),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: cardDark,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: dividerDark, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: dividerDark, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryOrangeDark, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Color(0xFFEF5350), width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Color(0xFFEF5350), width: 2.0),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondaryDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textDisabledDark,
        fontSize: 16,
        fontWeight: FontWeight.w300,
      ),
      errorStyle: GoogleFonts.inter(
        color: Color(0xFFEF5350),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryOrangeDark;
        }
        return dividerDark;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryOrangeDark.withValues(alpha: 0.5);
        }
        return dividerDark.withValues(alpha: 0.5);
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryOrangeDark;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(backgroundDark),
      side: const BorderSide(color: dividerDark, width: 2.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryOrangeDark;
        }
        return dividerDark;
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryOrangeDark,
      circularTrackColor: dividerDark,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryOrangeDark,
      thumbColor: primaryOrangeDark,
      overlayColor: primaryOrangeDark.withValues(alpha: 0.2),
      inactiveTrackColor: dividerDark,
      trackHeight: 4.0,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: primaryOrangeDark,
      unselectedLabelColor: textSecondaryDark,
      indicatorColor: primaryOrangeDark,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: textPrimaryDark.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        color: backgroundDark,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: cardDark,
      contentTextStyle: GoogleFonts.inter(
        color: textPrimaryDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: primaryOrangeDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: cardDark,
      elevation: 8.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      modalBackgroundColor: cardDark,
      modalElevation: 8.0,
    ),
    dividerTheme: const DividerThemeData(
      color: dividerDark,
      thickness: 1.0,
      space: 1.0,
    ), dialogTheme: DialogThemeData(backgroundColor: cardDark),
  );

  /// Helper method to build text theme based on brightness
  /// Implements typography standards: Inter for headings, Inter for body (replacing Source Sans Pro),
  /// Roboto for captions, and JetBrains Mono for data display
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHighEmphasis =
        isLight ? textHighEmphasisLight : textHighEmphasisDark;
    final Color textMediumEmphasis =
        isLight ? textMediumEmphasisLight : textMediumEmphasisDark;
    final Color textDisabled = isLight ? textDisabledLight : textDisabledDark;

    return TextTheme(
      // Display styles - Inter for spiritual dignity
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.22,
      ),

      // Headline styles - Inter with weights for hierarchy
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.33,
      ),

      // Title styles - Inter for clean mobile readability
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0.1,
        height: 1.43,
      ),

      // Body styles - Inter (replacing Source Sans Pro) for extended reading
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: textMediumEmphasis,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Label styles - Roboto for platform-native clarity
      labelLarge: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textMediumEmphasis,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.roboto(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: textDisabled,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  /// Helper method to get JetBrains Mono for counter displays
  /// Used for numerical data requiring monospaced precision
  static TextStyle getCounterTextStyle({
    required bool isLight,
    double fontSize = 48,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: isLight ? textPrimary : textPrimaryDark,
      letterSpacing: 0,
      height: 1.2,
    );
  }

  /// Helper method for Hindi accent text (राधा animations)
  static TextStyle getHindiAccentStyle({
    required bool isLight,
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: hindiAccent,
      letterSpacing: 0.5,
      height: 1.3,
    );
  }
}
