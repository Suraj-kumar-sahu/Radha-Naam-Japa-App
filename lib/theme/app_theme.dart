import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// "MokshaHub" Brand Kit Implementation
/// A cosmic, spiritual design system featuring Gold Radiance and Mystic Blacks.
class AppTheme {
  AppTheme._();

  // ---------------------------------------------------------------------------
  // 🎨 SECTION 1: COLOR SYSTEM
  // ---------------------------------------------------------------------------

  // Primary Colors
  static const Color goldRadiance = Color(0xFFF9D56E); // Logos, icons, highlights
  static const Color glowGold = Color(0xFFFFD78A);     // Glows, gradients
  static const Color deepMysticBlack = Color(0xFF000000); // Backgrounds
  static const Color cosmicBlackMist = Color(0xFF0A0A0F); // UI layers

  // Secondary Colors
  static const Color purpleMist = Color(0xFF3B2F4F);   // Cards, overlays
  static const Color indigoAura = Color(0xFF4A3D7A);   // Accents
  static const Color nebulaBlue = Color(0xFF1A1F3C);   // Transitions

  // Neutral Colors
  static const Color ashGray = Color(0xFF8E8E8E);      // Subtext
  static const Color moonlightWhite = Color(0xFFEDEDED); // Primary Text
  static const Color dustGold = Color(0xFFB09A57);     // Borders, strokes

  // ---------------------------------------------------------------------------
  // 🌈 GRADIENTS & GLOWS (Static Access)
  // ---------------------------------------------------------------------------
  
  static const LinearGradient goldGradient = LinearGradient(
    colors: [goldRadiance, glowGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cosmicNebulaGradient = LinearGradient(
    colors: [deepMysticBlack, nebulaBlue, dustGold],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient mokshaPurpleGradient = LinearGradient(
    colors: [purpleMist, indigoAura],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Returns the specific "Aura Glow" box shadow
  static List<BoxShadow> get auraGlow => [
    BoxShadow(
      color: glowGold.withValues(alpha: 0.4), // 40% Opacity
      blurRadius: 40,
      spreadRadius: 10,
    ),
  ];

  static List<BoxShadow> get buttonGlow => [
    BoxShadow(
      color: glowGold.withValues(alpha: 0.3),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  // ---------------------------------------------------------------------------
  // 🌗 THEME DATA
  // ---------------------------------------------------------------------------

  /// The Main Cosmic Theme (Dark Mode Default)
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: deepMysticBlack,

    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: goldRadiance,
      onPrimary: deepMysticBlack,
      primaryContainer: purpleMist,
      onPrimaryContainer: glowGold,
      secondary: indigoAura,
      onSecondary: moonlightWhite,
      surface: cosmicBlackMist,
      onSurface: moonlightWhite,
      onSurfaceVariant: ashGray,
      error: Color(0xFFCF6679),
      onError: deepMysticBlack,
      outline: dustGold,
    ),

    // 🔤 TYPOGRAPHY SYSTEM
    textTheme: TextTheme(
      // Display / Title Font -> Cinzel (Spiritual Display)
      displayLarge: GoogleFonts.cinzel(
        fontSize: 32, fontWeight: FontWeight.w600, color: goldRadiance),
      displayMedium: GoogleFonts.cinzel(
        fontSize: 28, fontWeight: FontWeight.w500, color: moonlightWhite),
      displaySmall: GoogleFonts.cinzel(
        fontSize: 24, fontWeight: FontWeight.w500, color: moonlightWhite),
      
      // Headlines
      headlineLarge: GoogleFonts.cinzel(
        fontSize: 22, fontWeight: FontWeight.w600, color: glowGold),
      headlineMedium: GoogleFonts.cinzel(
        fontSize: 20, fontWeight: FontWeight.w500, color: moonlightWhite),
      
      // Body Font -> Inter (Modern, Clean)
      bodyLarge: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w400, color: moonlightWhite),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w400, color: ashGray),
      bodySmall: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w400, color: ashGray),
      
      // Labels/Buttons
      labelLarge: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w600, color: deepMysticBlack),
    ),

    // 🎛 COMPONENT THEMES
    
    // Cards: 24pt radius, Soft gold stroke
    cardTheme: CardThemeData(
      color: cosmicBlackMist,
      elevation: 4,
      shadowColor: glowGold.withValues(alpha: 0.1),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
        side: BorderSide(color: dustGold.withValues(alpha: 0.3), width: 1),
      ),
    ),

    // Buttons: Primary Gold
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: goldRadiance,
        foregroundColor: deepMysticBlack,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        elevation: 8,
        shadowColor: glowGold.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Inputs: 12pt corner radius, Gold focus
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: purpleMist.withValues(alpha: 0.3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      hintStyle: GoogleFonts.inter(color: ashGray),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: dustGold.withValues(alpha: 0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: dustGold.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: goldRadiance, width: 1.5),
      ),
    ),

    // App Bar
    appBarTheme: AppBarTheme(
      backgroundColor: deepMysticBlack,
      foregroundColor: goldRadiance,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.cinzel(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: goldRadiance,
        letterSpacing: 1.0,
      ),
    ),
    
    // Bottom Nav
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: cosmicBlackMist,
      selectedItemColor: goldRadiance,
      unselectedItemColor: ashGray,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
    ),
  );

  /// Light Theme (Optional - kept for compatibility)
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: moonlightWhite,
    colorScheme: const ColorScheme.light(
      primary: goldRadiance,
      onPrimary: deepMysticBlack,
      secondary: indigoAura,
      surface: Colors.white,
      onSurface: deepMysticBlack,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: deepMysticBlack,
      elevation: 0,
      titleTextStyle: GoogleFonts.cinzel(
        fontSize: 24, fontWeight: FontWeight.w700, color: deepMysticBlack),
    ),
  );

  // ---------------------------------------------------------------------------
  // 🧩 SPECIAL HELPERS
  // ---------------------------------------------------------------------------

  /// Helper for "Glow Text" (For Greetings & Counters)
  static TextStyle get glowTextStyle {
    return GoogleFonts.cinzel(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: glowGold,
      shadows: [
        Shadow(
          color: glowGold.withValues(alpha: 0.6),
          blurRadius: 20,
          offset: const Offset(0, 0),
        ),
      ],
    );
  }

  /// Helper for Hindi Accent (Radha)
  static TextStyle getHindiAccentStyle({double fontSize = 24}) {
    return GoogleFonts.rozhaOne(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: goldRadiance,
    );
  }
}